CREATE TABLE characters (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE CHECK(name <> '')
);

ALTER TABLE objects
ADD COLUMN character_id INTEGER REFERENCES characters(id);

CREATE INDEX objects_character_id_idx ON objects(character_id);
