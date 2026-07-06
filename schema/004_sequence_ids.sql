CREATE TABLE sequences_new (
  id INTEGER PRIMARY KEY
);

INSERT INTO sequences_new (id)
SELECT id FROM sequences;

CREATE TABLE sequence_items_new (
  sequence_id INTEGER NOT NULL REFERENCES sequences_new(id) ON DELETE CASCADE,
  image_id INTEGER NOT NULL UNIQUE REFERENCES images(id) ON DELETE CASCADE,
  position INTEGER NOT NULL CHECK(position > 0),
  PRIMARY KEY (sequence_id, position)
);

INSERT INTO sequence_items_new (sequence_id, image_id, position)
SELECT sequence_id, image_id, position FROM sequence_items;

DROP TABLE sequence_items;
DROP TABLE sequences;
ALTER TABLE sequences_new RENAME TO sequences;
ALTER TABLE sequence_items_new RENAME TO sequence_items;
