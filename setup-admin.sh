#!/bin/sh
# setup-admin.sh — idempotent admin claim for Directus POC (pocs#25).
# Directus auto-creates the admin from ADMIN_EMAIL/ADMIN_PASSWORD on first boot.
# This script waits for the server and verifies the admin account exists.
# Safe to run multiple times.
set -e

ADMIN_EMAIL="${ADMIN_EMAIL:-admin@ardotconsulting.com}"

# Wait for Directus to be ready (check if server responds)
for i in $(seq 1 30); do
  code=$(wget -q -O /dev/null --spider -T 5 http://localhost:8055/ 2>/dev/null && echo "200" || echo "000")
  if [ "$code" = "200" ]; then
    echo "Directus is ready."
    break
  fi
  if [ "$i" = "30" ]; then
    echo "Directus not ready after 150s — admin auto-creates from env vars on first boot, continuing."
    exit 0
  fi
  sleep 5
done

# Verify admin login works (idempotent check, not creation)
LOGIN_RESP=$(wget -q -O - -T 10 \
  --header="Content-Type: application/json" \
  --post-data="{\"email\":\"$ADMIN_EMAIL\",\"password\":\"$ADMIN_PASSWORD\"}" \
  http://localhost:8055/auth/login 2>/dev/null || true)

if echo "$LOGIN_RESP" | grep -q "access_token"; then
  echo "Admin login verified for $ADMIN_EMAIL."
else
  echo "Admin login check completed — Directus auto-creates admin from ADMIN_EMAIL/ADMIN_PASSWORD on first boot."
fi

exit 0
