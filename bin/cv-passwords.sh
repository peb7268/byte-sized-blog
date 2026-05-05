#!/usr/bin/env bash
#
# Provision basic-auth credentials for /cv/<variant>/ pages on the NAS.
# One shared password per variant, all built from a common root that's
# easy for Paul to remember:
#
#   <root>-vp        → guards /cv/vp-engineering*
#   <root>-agentic   → guards /cv/agentic-enablement*
#   <root>-ic        → guards /cv/senior-ic*
#
# Usage:
#   bin/cv-passwords.sh <root>
#
# Example:
#   bin/cv-passwords.sh barrick2026
#   → generates passwords: barrick2026-vp / barrick2026-agentic / barrick2026-ic
#   → bcrypt-hashes each + writes 3 htpasswd files on the NAS
#   → username for all three is "recruiter"
#
# Re-run any time you want to rotate. Old credentials are replaced.

set -euo pipefail

ROOT="${1:-}"
if [[ -z "$ROOT" ]]; then
  echo "Usage: $0 <root>"
  echo "Example: $0 barrick2026"
  exit 1
fi

USER="recruiter"
# Prefer LAN; fall back to Tailscale (works regardless of network).
NAS_LAN="root@192.168.1.62"
NAS_TS="root@100.116.220.126"
NAS="$NAS_LAN"
if ! ssh -o IdentitiesOnly=yes -i "$HOME/.ssh/id_ed25519" -p 27 -o ConnectTimeout=4 "$NAS_LAN" 'true' 2>/dev/null; then
  echo "[cv-passwords] LAN unreachable, falling back to Tailscale"
  NAS="$NAS_TS"
fi
SSH=(ssh -o IdentitiesOnly=yes -i "$HOME/.ssh/id_ed25519" -p 27 "$NAS")
NAS_DIR="/mnt/user/appdata/Nginx-Proxy-Manager-Official/data/cv-auth"

VARIANTS=(vp-engineering:vp agentic-enablement:agentic senior-ic:ic)

echo "[cv-passwords] provisioning under $NAS_DIR"
"${SSH[@]}" "mkdir -p '$NAS_DIR' && chmod 750 '$NAS_DIR'"

for entry in "${VARIANTS[@]}"; do
  IFS=':' read -r variant suffix <<< "$entry"
  pw="${ROOT}-${suffix}"
  # openssl provides bcrypt via apr1; nginx auth_basic accepts apr1, sha, plain.
  # Use openssl's apr1 (Apache MD5) — universally supported, no apache2-utils dependency.
  hash="$(openssl passwd -apr1 "$pw")"
  htpasswd_line="${USER}:${hash}"
  echo "[cv-passwords] $variant → password: ${pw}"
  "${SSH[@]}" "echo '$htpasswd_line' > '$NAS_DIR/$variant.htpasswd' && chmod 640 '$NAS_DIR/$variant.htpasswd'"
done

echo
echo "[cv-passwords] done. Three credentials provisioned:"
echo "  username: $USER"
echo "  /cv/vp-engineering*       password: ${ROOT}-vp"
echo "  /cv/agentic-enablement*   password: ${ROOT}-agentic"
echo "  /cv/senior-ic*            password: ${ROOT}-ic"
echo
echo "Verify:"
echo "  ${SSH[*]} 'ls -la $NAS_DIR'"
