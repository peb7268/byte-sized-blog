#!/usr/bin/env bash
#
# Render each /cv/<variant> page to PDF using headless Chrome.
# Runs after `npm run build`. Output written into `dist/cv/<slug>.pdf`
# so the static deploy carries the PDFs alongside the HTML pages.
#
# Each CV's @media print stylesheet (defined in src/layouts/CVLayout.astro)
# strips the page chrome — back-link, action buttons, footer nav — and
# tightens type for letter-sized paper.
#
# Requires: Google Chrome at the standard macOS path. No npm dependencies.

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
DIST="$(pwd)/dist"

if [[ ! -x "$CHROME" ]]; then
  echo "[render-cvs] Chrome not found at $CHROME"
  echo "[render-cvs] Install Google Chrome or update CHROME path in this script."
  exit 1
fi

if [[ ! -d "$DIST/cv" ]]; then
  echo "[render-cvs] dist/cv/ missing — run 'npm run build' first"
  exit 1
fi

# Spin up a static file server on a random high port for Chrome to pull from.
PORT=$((40000 + RANDOM % 10000))
python3 -m http.server "$PORT" --directory "$DIST" > /dev/null 2>&1 &
SERVER_PID=$!
trap 'kill "$SERVER_PID" 2>/dev/null || true' EXIT

# Give the server a beat to bind.
sleep 0.5

VARIANTS=(vp-engineering agentic-enablement senior-ic)

for v in "${VARIANTS[@]}"; do
  url="http://127.0.0.1:$PORT/cv/$v/"
  out="$DIST/cv/$v.pdf"
  echo "[render-cvs] $v -> $out"
  "$CHROME" \
    --headless=new \
    --no-sandbox \
    --disable-gpu \
    --no-pdf-header-footer \
    --print-to-pdf="$out" \
    "$url" \
    > /dev/null 2>&1
  if [[ ! -f "$out" ]]; then
    echo "[render-cvs] FAILED to write $out"
    exit 1
  fi
done

echo "[render-cvs] done. PDFs:"
ls -la "$DIST/cv/"*.pdf
