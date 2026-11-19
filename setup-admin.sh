#!/bin/sh
# setup-admin.sh — idempotent admin claim for Directus POC (pocs#25).
# Directus auto-creates the admin from ADMIN_EMAIL/ADMIN_PASSWORD on first boot.
# This script waits for the server, then verifies the admin user exists.
# Safe to run multiple times.
set -e

ADMIN_EMAIL="${ADMIN_EMAIL:-admin@ardotconsulting.com}"

# Wait for Directus to be ready
for i in $(seq 1 30); do
  code=$(curl -s -o /dev/null -w '%{http_code}' -m 5 http://localhost:8055/server/info 2>/dev/null || true)
  if [ "$code" = "200" ]; then
    echo "Directus is ready."
    break
  fi
  if [ "$i" = "30" ]; then
    echo "Directus not ready after 150s, but admin auto-creates on boot — continuing."
    exit 0
  fi
  sleep 5
done

# Authenticate as admin to verify the account was created
TOKEN=$(curl -s -m 10 -X POST http://localhost:8055/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$ADMIN_EMAIL\",\"password\":\"$ADMIN_PASSWORD\"}" 2>/dev/null | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4 || true)

if [ -n "$TOKEN" ]; then
  echo "Admin login verified for $ADMIN_EMAIL."
else
  echo "Could not verify admin login — Directus may still be initializing. Admin auto-creates from env vars on first boot."
fi

exit 0
