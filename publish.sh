#!/bin/bash
# publish.sh — sync vault content into git and deploy
set -e

BLOG_DIR="$(cd "$(dirname "$0")" && pwd)"
CONTENT_LINK="$BLOG_DIR/src/content/blog"
VAULT_DIR="$HOME/Documents/Main/Resources/Learning/Blog"

# If symlink, replace with real files for git
if [ -L "$CONTENT_LINK" ]; then
    echo "[publish] Replacing symlink with real files for git..."
    rm "$CONTENT_LINK"
    cp -r "$VAULT_DIR" "$CONTENT_LINK"
fi

# Build to validate
echo "[publish] Building site..."
cd "$BLOG_DIR"
./node_modules/.bin/astro build

# Stage, commit, push
git add -A
git commit -m "Publish: sync content from vault" || echo "Nothing to commit"
git push

# Restore symlink
rm -rf "$CONTENT_LINK"
ln -s "$VAULT_DIR" "$CONTENT_LINK"

# --- Scribble → Socialite chain -------------------------------------------------
# For every newly-LIVE post (draft:false and not already syndicated), drop a
# Socialite inbox marker and kick the scanner so it schedules syndication.
# Dedup via syndicated.log (by slug) means drafts and re-publishes never re-post.
SOCIAL_DIR="$HOME/Documents/Main/Resources/Social"
INBOX="$SOCIAL_DIR/_inbox"
SYNDICATED="$SOCIAL_DIR/syndicated.log"
mkdir -p "$INBOX"; touch "$SYNDICATED"
new_markers=0
for POST in "$VAULT_DIR"/*.md; do
    [ -f "$POST" ] || continue
    grep -qiE '^draft:[[:space:]]*true' "$POST" && continue   # skip drafts (in-review)
    SLUG=$(basename "$POST" .md)
    grep -qxF "$SLUG" "$SYNDICATED" && continue               # skip already-syndicated
    TITLE=$(grep -iE '^title:' "$POST" | head -1 \
            | sed -E 's/^[Tt]itle:[[:space:]]*//; s/^["'"'"']//; s/["'"'"'][[:space:]]*$//' \
            | sed -E 's/\\/\\\\/g; s/"/\\"/g')
    STAMP=$(date -u +"%Y%m%d-%H%M%S")
    TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    cat > "$INBOX/${STAMP}-${SLUG}.json" <<EOF
{
  "content_type": "blog",
  "source_path": "Resources/Learning/Blog/${SLUG}.md",
  "public_url": "https://blog.byte-sized.io/blog/${SLUG}/",
  "slug": "${SLUG}",
  "title": "${TITLE}",
  "published_at": "${TS}",
  "source": "scribble"
}
EOF
    echo "$SLUG" >> "$SYNDICATED"
    new_markers=$((new_markers + 1))
    echo "[publish] Socialite marker queued: $SLUG"
done
if [ "$new_markers" -gt 0 ]; then
    echo "[publish] $new_markers newly-live post(s) -> triggering Socialite scanner..."
    launchctl kickstart -k "gui/$(id -u)/com.socialite.inbox-scanner" 2>/dev/null \
        && echo "[publish] Socialite scanner triggered (schedules within ~1 min)." \
        || echo "[publish] NOTE: scanner LaunchAgent not loaded; marker waits in _inbox."
fi
# -------------------------------------------------------------------------------

echo "[publish] Done. Symlink restored."
