# Directus on SQLite: single-container demo (pocs#25). The database and uploads
# live on the persistent volume at /directus/data, so content survives redeploys.
# KEY, SECRET and ADMIN_PASSWORD are set at runtime by OpenTofu (generated_secrets);
# never put them here. Tested with directus/directus:12.6.1.
FROM directus/directus:12.6.1

# Create data directories with correct ownership for the node user (UID 1000)
USER node
RUN mkdir -p /directus/data/uploads

ENV DB_CLIENT=sqlite3 \
    DB_FILENAME=/directus/data/data.db \
    ADMIN_EMAIL=admin@ardotconsulting.com \
    PUBLIC_URL=https://directus.poc.ardotconsulting.com \
    STORAGE_LOCAL_ROOT=/directus/data/uploads \
    MAX_PAYLOAD_SIZE=100mb

EXPOSE 8055
