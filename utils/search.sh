search_targets() {
  local fields
  local artist
  local cat
  local topic
  local where
  if [ "$#" -eq 0 ]; then
    artist=
    cat=
    topic=
  else
    fields=$(classification_parse_location "$1" search) || return 1
    IFS=$'\t' read -r artist cat topic <<<"$fields"
  fi
  where='1 = 1'
  if [ -n "$artist" ]; then
    where="$where AND artists.name = $(db_quote "$artist")"
  fi
  if [ -n "$cat" ]; then
    where="$where AND cats.name = $(db_quote "$cat")"
  fi
  if [ -n "$topic" ]; then
    where="$where AND topics.name = $(db_quote "$topic")"
  fi
  db_value "
SELECT sequences.id
FROM sequences
JOIN images ON images.sequence_id = sequences.id
JOIN artists ON artists.id = sequences.artist_id
JOIN cats ON cats.id = sequences.cat_id
LEFT JOIN topics ON topics.id = sequences.topic_id
WHERE $where
GROUP BY sequences.id
ORDER BY min(images.id), sequences.id;
"
}
