#!/usr/bin/env bash
#
# Read a Socialite staging directory and post each platform.md to Buffer.
#
# Stages a `posted_at` + `posted_url` value back into each platform.md
# frontmatter so re-runs are idempotent — a file with `posted_at` set
# is skipped (you can manually unset to re-post).
#
# Usage:
#   bin/socialite-post.sh <staging-dir> [--dry-run] [--schedule <ISO-8601>]
#
# Examples:
#   # Stage to Buffer's queue (no specific time — Buffer's profile
#   # schedule decides):
#   bin/socialite-post.sh ~/Documents/Main/Resources/Social/2026-05-05--what-happens-when-the-partys-over
#
#   # Schedule for a specific time:
#   bin/socialite-post.sh <dir> --schedule "2026-05-07T13:00:00Z"
#
#   # Dry-run — print what would be posted, don't hit Buffer:
#   bin/socialite-post.sh <dir> --dry-run
#
# Secrets: pulls BUFFER_API_TOKEN from Infisical (Agent Infrastructure
# project, /social path). Profile IDs are resolved by querying Buffer's
# /profiles.json endpoint at runtime — no per-machine config needed.
#
# Pre-publish gate:
# - Refuses to post if any platform.md still contains the placeholder
#   `<<PUBLIC_URL_GOES_HERE>>` token. The user must promote the source
#   blog post and search-and-replace before posting.

set -euo pipefail

STAGING="${1:-}"
shift || true
DRY_RUN=0
SCHEDULE=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=1; shift;;
    --schedule) SCHEDULE="$2"; shift 2;;
    *) echo "unknown flag: $1" >&2; exit 2;;
  esac
done

if [[ -z "$STAGING" || ! -d "$STAGING" ]]; then
  echo "Usage: $0 <staging-dir> [--dry-run] [--schedule <ISO-8601>]"
  echo "Staging dir must contain linkedin.md / twitter.md / instagram.md"
  exit 1
fi

# 1. Pre-publish gate — block placeholder URLs
if grep -rq "<<PUBLIC_URL_GOES_HERE>>" "$STAGING" 2>/dev/null; then
  echo "[socialite-post] BLOCKED: staging dir still contains <<PUBLIC_URL_GOES_HERE>> placeholder."
  echo "  Source blog post is still in draft. Promote to public, then sed-replace the placeholder"
  echo "  with the real URL before posting."
  echo
  echo "  Files containing the placeholder:"
  grep -lr "<<PUBLIC_URL_GOES_HERE>>" "$STAGING"
  exit 3
fi

# 2. Pull Buffer token via Infisical
echo "[socialite-post] fetching BUFFER_API_TOKEN from Infisical"
if ! command -v infisical >/dev/null 2>&1; then
  echo "infisical CLI not on PATH — install from infisical.com/docs/cli/overview" >&2
  exit 4
fi
TOKEN="$(infisical secrets get BUFFER_API_TOKEN \
  --projectId="b3187c3b-409b-4c2a-b01b-23bfaf2a5c83" \
  --env=prod \
  --path="/social" \
  --plain 2>/dev/null || true)"
if [[ -z "$TOKEN" ]]; then
  echo "BUFFER_API_TOKEN not found at Agent Infrastructure /social — store it via 007 first." >&2
  exit 5
fi

# 3. Resolve Buffer profile IDs (LinkedIn / Twitter / Instagram)
echo "[socialite-post] resolving Buffer profiles"
profiles_json="$(curl -fsS -H "Authorization: Bearer $TOKEN" \
  https://api.bufferapp.com/1/profiles.json 2>/dev/null || true)"
if [[ -z "$profiles_json" ]]; then
  echo "Buffer /profiles.json failed — check token validity" >&2
  exit 6
fi

resolve_profile() {
  local service="$1"
  python3 - "$service" "$profiles_json" <<'PY'
import json, sys
service = sys.argv[1]
profiles = json.loads(sys.argv[2])
for p in profiles:
    if p.get("service") == service:
        print(p["id"])
        break
PY
}

LINKEDIN_PID="$(resolve_profile linkedin)"
TWITTER_PID="$(resolve_profile twitter)"
INSTAGRAM_PID="$(resolve_profile instagram)"

if [[ -z "$LINKEDIN_PID" && -z "$TWITTER_PID" && -z "$INSTAGRAM_PID" ]]; then
  echo "No connected profiles found in Buffer. Connect LinkedIn / Twitter / Instagram in the Buffer UI first." >&2
  exit 7
fi

# 4. Post one platform file. Reads the Markdown body (everything below
#    the first '# Post' or '# Caption' or '# Thread' heading), strips
#    other sections, and POSTs to Buffer.
post_platform() {
  local platform="$1" file="$2" pid="$3"
  if [[ -z "$pid" ]]; then
    echo "  [skip] $platform — no Buffer profile connected"
    return
  fi
  if [[ ! -f "$file" ]]; then
    echo "  [skip] $platform — $file missing"
    return
  fi

  # Idempotency: skip if posted_at is already set
  if grep -qE "^posted_at:\s*[^n]" "$file" 2>/dev/null; then
    local pa
    pa="$(grep -E "^posted_at:" "$file" | head -1 | awk '{print $2}')"
    echo "  [skip] $platform — already posted at $pa"
    return
  fi

  # Extract the body — for linkedin/instagram, everything under '# Post' or '# Caption'.
  # For twitter threads, we'll need to split posts on `---` separators.
  local body
  body="$(python3 - "$file" "$platform" <<'PY'
import sys, re
path = sys.argv[1]
platform = sys.argv[2]
text = open(path).read()

# Strip frontmatter
m = re.match(r'^---\n.*?\n---\n', text, re.DOTALL)
if m:
    text = text[m.end():]

# For twitter thread, return all posts joined with a separator nginx will recognize.
# For now, single-post flow only — Buffer's /updates/create.json doesn't natively
# do threads (you'd need /updates/create.json calls per post with thread_id linking).
if platform == "twitter-thread":
    # split by '---' lines, strip headers
    posts = re.split(r'\n---\n', text)
    cleaned = []
    for p in posts:
        # strip section headers like '# Thread', '# Image', '# Notes'
        p = re.sub(r'^#[^\n]*\n', '', p, flags=re.M)
        p = p.strip()
        if p and not p.startswith('#'):
            cleaned.append(p)
    print('\n---POST---\n'.join(cleaned))
else:
    # find # Post or # Caption header
    section = re.search(r'^#\s+(?:Post|Caption)\s*\n(.*?)(?=\n#\s+\w|\Z)', text, re.S | re.M)
    if section:
        print(section.group(1).strip())
PY
)"

  if [[ -z "$body" ]]; then
    echo "  [skip] $platform — could not extract body"
    return
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "  [dry-run] $platform — $(echo "$body" | head -c 80)…"
    return
  fi

  # POST to Buffer. scheduled_at is unix-seconds-since-epoch if --schedule given,
  # else "now" (which Buffer queues to the next available slot in the profile schedule).
  local args=(-d "access_token=$TOKEN" -d "profile_ids[]=$pid")
  if [[ -n "$SCHEDULE" ]]; then
    local epoch
    epoch="$(date -j -u -f '%Y-%m-%dT%H:%M:%SZ' "$SCHEDULE" '+%s' 2>/dev/null || date -d "$SCHEDULE" +%s)"
    args+=(-d "scheduled_at=$epoch")
  else
    args+=(-d "now=true")
  fi
  args+=(--data-urlencode "text=$body")

  resp="$(curl -fsS -X POST "${args[@]}" https://api.bufferapp.com/1/updates/create.json)"
  if echo "$resp" | grep -q '"success":true'; then
    update_id="$(echo "$resp" | python3 -c 'import sys,json; d=json.load(sys.stdin); print(d.get("updates",[{}])[0].get("id","?"))')"
    echo "  [posted] $platform — buffer update $update_id"
    # Patch posted_at into frontmatter
    iso="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    sed -i.bak "s/^posted_at:.*$/posted_at: $iso/" "$file" && rm -f "${file}.bak"
  else
    echo "  [FAIL] $platform — buffer response: $resp"
  fi
}

# 5. Run the three posts
echo "[socialite-post] posting"
post_platform linkedin       "$STAGING/linkedin.md"   "$LINKEDIN_PID"
post_platform twitter        "$STAGING/twitter.md"    "$TWITTER_PID"
post_platform instagram      "$STAGING/instagram.md"  "$INSTAGRAM_PID"

echo
echo "[socialite-post] done."
if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "[socialite-post] dry-run mode — nothing actually posted."
fi
