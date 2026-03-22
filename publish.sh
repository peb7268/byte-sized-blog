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

echo "[publish] Done. Symlink restored."
