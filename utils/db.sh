db_quote() {
  local value
  value=$1
  value=${value//\'/\'\'}
  printf "'%s'\n" "$value"
}

db_run() {
  sqlite3 -batch -bail -cmd 'PRAGMA foreign_keys = ON;' "$ARTS_DB_FILE" "$1"
}

db_value() {
  sqlite3 -batch -bail -noheader -cmd 'PRAGMA foreign_keys = ON;' \
    "$ARTS_DB_FILE" "$1"
}

db_init() {
  local migration
  local name
  local sql
  local violations
  db_run "
CREATE TABLE IF NOT EXISTS schema_migrations (
  name TEXT PRIMARY KEY,
  applied_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%SZ', 'now'))
);
"
  for migration in "$ROOT_DIR"/schema/*.sql; do
    [ -f "$migration" ] || continue
    name=${migration##*/}
    if [ -n "$(db_value "
SELECT name FROM schema_migrations WHERE name = $(db_quote "$name");
")" ]; then
      continue
    fi
    sql=$(<"$migration")
    sqlite3 -batch -bail -cmd 'PRAGMA foreign_keys = OFF;' \
      "$ARTS_DB_FILE" "
BEGIN IMMEDIATE;
$sql
INSERT INTO schema_migrations (name) VALUES ($(db_quote "$name"));
COMMIT;
"
    violations=$(db_value "PRAGMA foreign_key_check;")
    if [ -n "$violations" ]; then
      echo "foreign key check failed after migration: $name" >&2
      return 1
    fi
  done
}
