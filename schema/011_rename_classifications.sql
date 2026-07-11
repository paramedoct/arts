ALTER TABLE albums RENAME TO cats;
ALTER TABLE characters RENAME TO topics;

ALTER TABLE objects RENAME COLUMN album_id TO cat_id;
ALTER TABLE objects RENAME COLUMN character_id TO topic_id;

DROP INDEX objects_album_id_idx;
DROP INDEX objects_character_id_idx;

CREATE INDEX objects_cat_id_idx ON objects(cat_id);
CREATE INDEX objects_topic_id_idx ON objects(topic_id);
