#!/usr/bin/env bash
#
# Deploy /cv/ pages + PDFs to the NAS, and ensure NPM proxy host 28
# (the nginx-astro fronting blog.byte-sized.io / paul.barrick.dev)
# carries basic-auth location blocks for each gated CV variant.
#
# Idempotent — re-run on every deploy.
#
# Network: prefers LAN, falls back to Tailscale (works from anywhere).

set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

NAS_LAN="root@192.168.1.62"
NAS_TS="root@100.116.220.126"
SSH_OPTS=(-o IdentitiesOnly=yes -i "$HOME/.ssh/id_ed25519" -p 27)

NAS="$NAS_LAN"
if ! ssh "${SSH_OPTS[@]}" -o ConnectTimeout=4 "$NAS_LAN" 'true' 2>/dev/null; then
  echo "[cv-deploy] LAN unreachable, falling back to Tailscale"
  NAS="$NAS_TS"
fi

DIST_LOCAL="$(pwd)/dist"
NAS_DOCROOT="/mnt/user/blog"
NPM_CONF="/mnt/user/appdata/Nginx-Proxy-Manager-Official/data/nginx/proxy_host/28.conf"
NPM_AUTH_DIR="/mnt/user/appdata/Nginx-Proxy-Manager-Official/data/cv-auth"

# 1. rsync the static build
echo "[cv-deploy] rsync $DIST_LOCAL/  →  $NAS:$NAS_DOCROOT/"
rsync -avz --delete \
  -e "ssh ${SSH_OPTS[*]}" \
  "$DIST_LOCAL/" "$NAS:$NAS_DOCROOT/"

# 2. Confirm htpasswd files exist
echo
echo "[cv-deploy] checking auth files on NAS"
ssh "${SSH_OPTS[@]}" "$NAS" "ls -la '$NPM_AUTH_DIR' 2>/dev/null || { echo 'auth dir missing — run bin/cv-passwords.sh <root> first'; exit 1; }"

# 3. Inject nginx location blocks into proxy host conf if not already there
SENTINEL="# >>> CV-AUTH-BLOCK >>>"
echo
echo "[cv-deploy] checking nginx auth config in $NPM_CONF"

ALREADY_PRESENT=$(ssh "${SSH_OPTS[@]}" "$NAS" "grep -F '$SENTINEL' '$NPM_CONF' 2>/dev/null | wc -l" || echo 0)
if [[ "$ALREADY_PRESENT" -gt 0 ]]; then
  echo "[cv-deploy] auth block already present in $NPM_CONF — skipping"
else
  echo "[cv-deploy] injecting auth block"
  ssh "${SSH_OPTS[@]}" "$NAS" "cp '$NPM_CONF' '${NPM_CONF}.bak.$(date +%s)'"

  # Build the snippet locally then pipe it in. Nginx requires location blocks
  # inside a server block. Inject just before the closing brace of the
  # `server { ... }` block in 28.conf.
  read -r -d '' AUTH_SNIPPET <<'EOF' || true
    # >>> CV-AUTH-BLOCK >>>
    # Per-variant basic auth for /cv/<slug>/ and /cv/<slug>.pdf.
    # The /cv/ index is intentionally NOT gated.
    location ~ ^/cv/vp-engineering(/|\.pdf)? {
      auth_basic "CV — VP Engineering";
      auth_basic_user_file /data/cv-auth/vp-engineering.htpasswd;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $http_connection;
      proxy_http_version 1.1;
      include conf.d/include/proxy.conf;
    }
    location ~ ^/cv/agentic-enablement(/|\.pdf)? {
      auth_basic "CV — Head of Agentic Enablement";
      auth_basic_user_file /data/cv-auth/agentic-enablement.htpasswd;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $http_connection;
      proxy_http_version 1.1;
      include conf.d/include/proxy.conf;
    }
    location ~ ^/cv/senior-ic(/|\.pdf)? {
      auth_basic "CV — Principal IC";
      auth_basic_user_file /data/cv-auth/senior-ic.htpasswd;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $http_connection;
      proxy_http_version 1.1;
      include conf.d/include/proxy.conf;
    }
    # <<< CV-AUTH-BLOCK <<<
EOF

  # The NPM nginx container mounts /mnt/user/.../data → /data internally,
  # so reference htpasswd files via /data/cv-auth/... in the conf.

  # Use awk to inject the snippet right before the final `}` of the file.
  # 28.conf is a server { ... } block — last `}` closes it.
  ssh "${SSH_OPTS[@]}" "$NAS" "awk -v block='$AUTH_SNIPPET' '
    {
      lines[NR] = \$0
    }
    END {
      # find the last }
      last = NR
      while (last > 0 && lines[last] !~ /^\\}/) last--
      for (i = 1; i < last; i++) print lines[i]
      print block
      for (i = last; i <= NR; i++) print lines[i]
    }
  ' '$NPM_CONF' > /tmp/28.conf.new && mv /tmp/28.conf.new '$NPM_CONF'"

  echo "[cv-deploy] nginx config updated, testing"
  ssh "${SSH_OPTS[@]}" "$NAS" "docker exec Nginx-Proxy-Manager-Official nginx -t 2>&1 | tail -3"
  ssh "${SSH_OPTS[@]}" "$NAS" "docker exec Nginx-Proxy-Manager-Official nginx -s reload 2>&1 | tail -3"
fi

echo
echo "[cv-deploy] verify"
for u in "https://paul.barrick.dev/cv/" "https://paul.barrick.dev/cv/vp-engineering/" "https://paul.barrick.dev/cv/agentic-enablement/" "https://paul.barrick.dev/cv/senior-ic/" "https://paul.barrick.dev/cv/vp-engineering.pdf"; do
  s=$(curl -s -o /dev/null -w "%{http_code}" "$u")
  printf "  %-60s %s\n" "$u" "$s"
done
echo
echo "[cv-deploy] expected: /cv/ → 200; gated variants → 401 (until creds supplied)"
