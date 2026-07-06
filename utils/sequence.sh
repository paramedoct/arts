sequence_validate_id() {
  case "${1:-}" in
    '' | *[!0-9]*)
      echo "invalid sequence id: ${1:-}" >&2
      return 1
      ;;
  esac
}

sequence_add() {
  local statements
  local position
  local image_id
  [ "$#" -ge 1 ] || {
    echo "sequence requires at least one image" >&2
    return 1
  }
  statements="
PRAGMA foreign_keys = ON;
BEGIN IMMEDIATE;
INSERT INTO sequences DEFAULT VALUES;"
  position=1
  for image_id in "$@"; do
    image_require "$image_id" >/dev/null
    statements="$statements
INSERT INTO sequence_items (sequence_id, image_id, position)
SELECT max(id), $image_id, $position FROM sequences;"
    position=$((position + 1))
  done
  statements="$statements
SELECT max(id) FROM sequences;
COMMIT;"
  db_value "$statements"
}

sequence_remove() {
  local id
  id=$1
  sequence_require "$id" >/dev/null
  db_run "DELETE FROM sequences WHERE id = $id;"
}

sequence_list() {
  db_value "
SELECT sequences.id || char(9) || count(sequence_items.image_id)
FROM sequences
LEFT JOIN sequence_items ON sequence_items.sequence_id = sequences.id
GROUP BY sequences.id
ORDER BY sequences.id;
"
}

sequence_require() {
  local id
  id=$1
  sequence_validate_id "$id"
  if [ -z "$(db_value "SELECT id FROM sequences WHERE id = $id;")" ]; then
    echo "sequence not found: $id" >&2
    return 1
  fi
  printf '%s\n' "$id"
}

sequence_image_ids() {
  local id
  id=$1
  sequence_require "$id" >/dev/null
  db_value "
SELECT sequence_items.image_id
FROM sequence_items
WHERE sequence_items.sequence_id = $id
ORDER BY sequence_items.position;
"
}
