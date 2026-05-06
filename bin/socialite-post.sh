#!/usr/bin/env bash
#
# Read a Socialite staging directory and post each platform.md via Postiz.
#
# Stages a `posted_at` value back into each platform.md frontmatter so
# re-runs are idempotent — a file with `posted_at` set is skipped (manually
# unset the value to re-post).
#
# Usage:
#   bin/socialite-post.sh <staging-dir> [--dry-run] [--schedule <ISO-8601>]
#
# Examples:
#   # Post now (queues immediately on Postiz):
#   bin/socialite-post.sh ~/Documents/Main/Resources/Social/2026-05-05--what-happens-when-the-partys-over
#
#   # Schedule for a specific time:
#   bin/socialite-post.sh <dir> --schedule "2026-05-07T13:00:00Z"
#
#   # Dry-run — print what would be posted, don't hit Postiz:
#   bin/socialite-post.sh <dir> --dry-run
#
# Secrets: pulls POSTIZ_API_KEY from Infisical via universal-auth (creds in
# ~/Desktop/NAS-Tunnels/.env). Integration IDs are resolved by calling
# `postiz integrations:list` at runtime.
#
# Pre-publish gate:
# - Refuses to post if any platform.md still contains the placeholder
#   `<<PUBLIC_URL_GOES_HERE>>` token. Promote the source blog post first.

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

# 1. Pre-publish gate
if grep -rq "<<PUBLIC_URL_GOES_HERE>>" "$STAGING" 2>/dev/null; then
  echo "[socialite-post] BLOCKED: staging dir still contains <<PUBLIC_URL_GOES_HERE>> placeholder."
  echo "  Promote the source blog post to public, then sed-replace the placeholder"
  echo "  with the real URL before posting."
  echo
  echo "  Files containing the placeholder:"
  grep -lr "<<PUBLIC_URL_GOES_HERE>>" "$STAGING"
  exit 3
fi

# 2. Fetch POSTIZ_API_KEY from Infisical via universal-auth
echo "[socialite-post] fetching POSTIZ_API_KEY from Infisical"
INFISICAL_ENV_FILE="${INFISICAL_ENV_FILE:-$HOME/Desktop/NAS-Tunnels/.env}"
if [[ ! -f "$INFISICAL_ENV_FILE" ]]; then
  echo "Infisical universal-auth creds not found at $INFISICAL_ENV_FILE" >&2
  exit 4
fi
set -a; source "$INFISICAL_ENV_FILE"; set +a
: "${INFISICAL_HOST:?}" "${INFISICAL_CLIENT_ID:?}" "${INFISICAL_CLIENT_SECRET:?}"

LOGIN=$(curl -fsS -X POST "$INFISICAL_HOST/api/v1/auth/universal-auth/login" \
  -H "Content-Type: application/json" \
  --data-binary "{\"clientId\":\"$INFISICAL_CLIENT_ID\",\"clientSecret\":\"$INFISICAL_CLIENT_SECRET\"}")
AT=$(printf '%s' "$LOGIN" | sed -n 's/.*"accessToken":"\([^"]*\)".*/\1/p')
[[ -n "$AT" ]] || { echo "infisical auth failed" >&2; exit 5; }

# Note: secret name has trailing dot per current Infisical entry. If renamed
# upstream, update this name accordingly.
fetch_secret() {
  curl -fsS -G "$INFISICAL_HOST/api/v3/secrets/raw/$1" \
    --data-urlencode "workspaceId=b3187c3b-409b-4c2a-b01b-23bfaf2a5c83" \
    --data-urlencode "environment=prod" \
    --data-urlencode "secretPath=/postiz" \
    -H "Authorization: Bearer $AT" \
    | sed -n 's/.*"secretValue":"\([^"]*\)".*/\1/p'
}

POSTIZ_API_KEY="$(fetch_secret 'POSTIZ_API_KEY')"
if [[ -z "$POSTIZ_API_KEY" ]]; then
  echo "POSTIZ_API_KEY not found in Infisical at /postiz" >&2
  exit 6
fi

export POSTIZ_API_KEY
export POSTIZ_API_URL="${POSTIZ_API_URL:-https://postiz.byte-sized.io/api}"

if ! command -v postiz >/dev/null 2>&1; then
  echo "postiz CLI not on PATH — install with: npm install -g postiz" >&2
  exit 7
fi

# 3. Resolve integration IDs from Postiz
echo "[socialite-post] resolving Postiz integrations"
INTEGRATIONS_JSON="$(postiz integrations:list 2>/dev/null | sed -n '/^\[/,/^\]/p' || true)"
if [[ -z "$INTEGRATIONS_JSON" ]]; then
  echo "Postiz integrations:list returned nothing — check API key + URL" >&2
  exit 8
fi

resolve_integration() {
  local ident="$1"
  python3 - "$ident" "$INTEGRATIONS_JSON" <<'PY'
import json, sys
ident = sys.argv[1]
data = json.loads(sys.argv[2])
for i in data:
    if i.get("identifier") == ident and not i.get("disabled"):
        print(i["id"]); break
PY
}

LINKEDIN_ID="$(resolve_integration linkedin)"
TWITTER_ID="$(resolve_integration x || true)"
[[ -z "$TWITTER_ID" ]] && TWITTER_ID="$(resolve_integration twitter || true)"
INSTAGRAM_ID="$(resolve_integration instagram || true)"
[[ -z "$INSTAGRAM_ID" ]] && INSTAGRAM_ID="$(resolve_integration instagram-standalone || true)"

# 4. Compute schedule timestamp (Postiz requires -s)
if [[ -n "$SCHEDULE" ]]; then
  SCHEDULE_ISO="$SCHEDULE"
else
  # +60s from now, ISO-8601 UTC. Postiz queues immediately at the slot.
  SCHEDULE_ISO="$(date -u -v+60S '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || date -u -d '+60 seconds' '+%Y-%m-%dT%H:%M:%SZ')"
fi
echo "[socialite-post] target schedule: $SCHEDULE_ISO"

# 5. Extract a single post body (linkedin/instagram) — text under '# Post' or '# Caption'.
extract_single_body() {
  python3 - "$1" <<'PY'
import sys, re
text = open(sys.argv[1]).read()
# Strip frontmatter
m = re.match(r'^---\n.*?\n---\n', text, re.DOTALL)
if m: text = text[m.end():]
section = re.search(r'^#\s+(?:Post|Caption)\s*\n(.*?)(?=\n#\s+\w|\Z)', text, re.S | re.M)
print((section.group(1) if section else "").strip())
PY
}

# Extract a Twitter thread — list of posts split by '---' lines under '# Thread'.
extract_thread_posts() {
  python3 - "$1" <<'PY'
import sys, re, json
text = open(sys.argv[1]).read()
m = re.match(r'^---\n.*?\n---\n', text, re.DOTALL)
if m: text = text[m.end():]
section = re.search(r'^#\s+Thread\s*\n(.*?)(?=\n#\s+\w|\Z)', text, re.S | re.M)
if not section:
    print(json.dumps([])); sys.exit()
body = section.group(1)
posts = [p.strip() for p in re.split(r'\n---\n', body) if p.strip()]
print(json.dumps(posts))
PY
}

mark_posted() {
  local file="$1" id="$2"
  local iso; iso="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  if grep -q "^posted_at:" "$file"; then
    sed -i.bak "s|^posted_at:.*$|posted_at: $iso|" "$file"
  else
    sed -i.bak "/^---$/{s|^---$|---\\nposted_at: $iso|;:a;n;ba}" "$file"
  fi
  if grep -q "^posted_url:" "$file"; then
    sed -i.bak "s|^posted_url:.*$|posted_url: postiz://$id|" "$file"
  fi
  rm -f "${file}.bak"
}

is_already_posted() {
  # Posted iff posted_at is set to a real value (not null, not empty).
  local val
  val="$(grep -E '^posted_at:' "$1" 2>/dev/null | head -1 | sed -E 's/^posted_at:[[:space:]]*//' | tr -d '"')"
  [[ -n "$val" && "$val" != "null" ]]
}

# 6. Post one platform — single post (linkedin / instagram).
post_single() {
  local platform="$1" file="$2" iid="$3"
  if [[ -z "$iid" ]]; then
    echo "  [skip] $platform — no Postiz integration connected"
    return
  fi
  if [[ ! -f "$file" ]]; then
    echo "  [skip] $platform — $file missing"
    return
  fi
  if is_already_posted "$file"; then
    local pa; pa="$(grep '^posted_at:' "$file" | head -1 | awk '{print $2}')"
    echo "  [skip] $platform — already posted at $pa"
    return
  fi

  local body; body="$(extract_single_body "$file")"
  if [[ -z "$body" ]]; then
    echo "  [skip] $platform — could not extract body"
    return
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "  [dry-run] $platform → integration $iid (chars: ${#body})"
    echo "    preview: $(echo "$body" | head -c 80)…"
    return
  fi

  local resp
  if resp="$(postiz posts:create -c "$body" -s "$SCHEDULE_ISO" -i "$iid" -t schedule 2>&1)"; then
    local id
    id="$(echo "$resp" | python3 -c 'import sys,json,re
out = sys.stdin.read()
m = re.search(r"\{.*\}", out, re.S)
if m:
    try: print(json.loads(m.group(0)).get("id","unknown"))
    except: print("unknown")
else: print("unknown")')"
    echo "  [posted] $platform — postiz post $id"
    mark_posted "$file" "$id"
  else
    echo "  [FAIL] $platform — postiz response: $resp"
  fi
}

# 7. Post a Twitter thread — multiple -c flags + -d delay.
post_thread() {
  local platform="$1" file="$2" iid="$3"
  if [[ -z "$iid" ]]; then
    echo "  [skip] $platform — no Postiz integration connected"
    return
  fi
  if [[ ! -f "$file" ]]; then
    echo "  [skip] $platform — $file missing"
    return
  fi
  if is_already_posted "$file"; then
    local pa; pa="$(grep '^posted_at:' "$file" | head -1 | awk '{print $2}')"
    echo "  [skip] $platform — already posted at $pa"
    return
  fi

  # Read JSON array of posts and convert to repeated -c args.
  local posts_json; posts_json="$(extract_thread_posts "$file")"
  local count; count="$(echo "$posts_json" | python3 -c 'import sys,json; print(len(json.load(sys.stdin)))')"
  if [[ "$count" -eq 0 ]]; then
    echo "  [skip] $platform — no thread posts found"
    return
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    echo "  [dry-run] $platform → integration $iid (thread of $count posts)"
    echo "$posts_json" | python3 -c 'import sys,json
for i,p in enumerate(json.load(sys.stdin),1):
    print(f"    {i}: {p[:70]}…")'
    return
  fi

  # Build -c args from JSON
  local args=()
  while IFS= read -r p; do
    args+=(-c "$p")
  done < <(echo "$posts_json" | python3 -c 'import sys,json
for p in json.load(sys.stdin): print(p)')

  local resp
  if resp="$(postiz posts:create "${args[@]}" -s "$SCHEDULE_ISO" -i "$iid" -t schedule -d 0 2>&1)"; then
    local id; id="$(echo "$resp" | python3 -c 'import sys,json,re
out = sys.stdin.read()
m = re.search(r"\{.*\}", out, re.S)
if m:
    try: print(json.loads(m.group(0)).get("id","unknown"))
    except: print("unknown")
else: print("unknown")')"
    echo "  [posted] $platform — postiz post $id ($count tweets)"
    mark_posted "$file" "$id"
  else
    echo "  [FAIL] $platform — postiz response: $resp"
  fi
}

# 8. Run the three platforms
echo "[socialite-post] posting"
post_single linkedin  "$STAGING/linkedin.md"  "$LINKEDIN_ID"
post_thread twitter   "$STAGING/twitter.md"   "$TWITTER_ID"
post_single instagram "$STAGING/instagram.md" "$INSTAGRAM_ID"

echo
echo "[socialite-post] done."
if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "[socialite-post] dry-run mode — nothing actually posted."
fi
