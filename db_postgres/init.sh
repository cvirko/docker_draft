#!/bin/bash
set -e

DUMP_PATH="$FILES_DIR/999_$DUMP_FILE"
SENTINEL="$PGDATA/.db_init_complete"

# echo "Restoring dump from $DUMP_PATH (filtering conflicting roles)..."

# # Применяем дамп (фильтруем CREATE ROLE/USER)
# sed -E "/CREATE (ROLE|USER) $POSTGRES_USER/d" "$DUMP_PATH" \
#   | psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB"

# echo "Dump restored successfully."

# Принудительный checkpoint чтобы все данные на диске оказались
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -c "CHECKPOINT;"

# Настройки репликации (если ещё не добавлены)
cat >> "$PGDATA/postgresql.conf" <<EOF
wal_level = replica
archive_mode = on
archive_command = 'test ! -f /var/lib/postgresql/wal_archive/%f && cp %p /var/lib/postgresql/wal_archive/%f'
max_wal_senders = 10
max_replication_slots = 10
synchronous_standby_names = 'FIRST 1 (replica_sync)'
EOF

mkdir -p /var/lib/postgresql/wal_archive
chown -R postgres:postgres /var/lib/postgresql/wal_archive

# Обновляем pg_hba.conf
echo "host replication $POSTGRES_USER 0.0.0.0/0 scram-sha-256" >> "$PGDATA/pg_hba.conf"
echo "host all all 0.0.0.0/0 scram-sha-256" >> "$PGDATA/pg_hba.conf"

# Создаём sentinel файл — он сигнализирует, что БД полностью инициализирована
touch "$SENTINEL"
chown postgres:postgres "$SENTINEL"
chmod 600 "$SENTINEL"

echo "Initialization complete — sentinel created at $SENTINEL"

