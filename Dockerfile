# Directus on SQLite: single-container demo (pocs#25). The database and uploads
# live on the persistent volume at /directus/data, so content survives redeploys.
# KEY, SECRET and ADMIN_PASSWORD are set at runtime by OpenTofu (generated_secrets);
# never put them here. Tested with directus/directus:v12.6.1.
FROM directus/directus:v12.6.1

ENV DB_CLIENT=sqlite3 \
    DB_FILENAME=/directus/data/data.db \
    ADMIN_EMAIL=admin@ardotconsulting.com \
    PUBLIC_URL=https://directus.poc.ardotconsulting.com \
    STORAGE_LOCAL_ROOT=/directus/data/uploads \
    MAX_PAYLOAD_SIZE=100mb

EXPOSE 8055
