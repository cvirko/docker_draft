#!/bin/bash
set -e

# Удаляем файл-флаг, если он остался от предыдущего запуска
rm -f /shared_status/dump_complete.flag

# Обновляем pg_hba.conf
echo "host replication $POSTGRES_USER 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf"
echo "host all $POSTGRES_USER 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf"

# DUMP ############################################################################

DUMP_PATH="$FILES_DIR/999_$DUMP_FILE"
echo "Restoring dump from $DUMP_PATH (filtering conflicting roles)..."

# Применяем дамп (фильтруем CREATE ROLE/USER)
sed -E "/(CREATE|ALTER) (ROLE|USER) $POSTGRES_USER/d" "$DUMP_PATH" \
  | psql -a -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB"

echo "Dump restored successfully."
# DUMP ############################################################################

touch /shared_status/dump_complete.flag

# включаем Синхронную реплику
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c "ALTER SYSTEM SET synchronous_standby_names = 'sync_replica';"
psql --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -c "SELECT pg_reload_conf();"

echo "!!!!!!!!!!!!!!!!Complete.!!!!!!!!!!!!!!!!!!!!"
