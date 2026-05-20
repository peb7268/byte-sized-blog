#!/bin/bash
# publish.sh — sync vault content into git and deploy
set -e

BLOG_DIR="$(cd "$(dirname "$0")" && pwd)"
CONTENT_LINK="$BLOG_DIR/src/content/blog"
VAULT_DIR="$HOME/Library/CloudStorage/GoogleDrive-peb7268@gmail.com/My Drive/Main/Resources/Learning/Blog"

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

echo "[publish] Done. Symlink restored."

# Drop Socialite inbox marker for any newly published posts
INBOX="$HOME/Library/CloudStorage/GoogleDrive-peb7268@gmail.com/My Drive/Main/Resources/Social/_inbox"
mkdir -p "$INBOX"

# Find posts that were just committed (non-draft, in the root blog dir)
for POST in "$VAULT_DIR"/*.md; do
    [ -f "$POST" ] || continue
    SLUG=$(basename "$POST" .md)
    TIMESTAMP=$(date +%Y%m%d-%H%M%S)
    MARKER="$INBOX/${TIMESTAMP}-${SLUG}.json"

    # Skip drafts
    if grep -q '^draft: true' "$POST" 2>/dev/null; then
        continue
    fi

    # Skip if marker already exists for this slug (any timestamp)
    if ls "$INBOX"/*"-${SLUG}.json" 2>/dev/null | head -1 | grep -q .; then
        continue
    fi

    TITLE=$(grep '^title:' "$POST" | head -1 | sed "s/^title: *['\"]*//" | sed "s/['\"]* *$//")
    PUBDATE=$(grep '^pubDate:' "$POST" | head -1 | sed "s/^pubDate: *['\"]*//" | sed "s/['\"]* *$//")

    cat > "$MARKER" <<EOF
{
  "content_type": "blog",
  "source_path": "Resources/Learning/Blog/${SLUG}.md",
  "public_url": "https://blog.byte-sized.io/blog/${SLUG}/",
  "slug": "${SLUG}",
  "title": "${TITLE}",
  "published_at": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "source": "scribble"
}
EOF
    echo "[publish] Socialite marker dropped: $SLUG"
done
