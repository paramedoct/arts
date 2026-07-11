CREATE TABLE settings (
  id INTEGER PRIMARY KEY CHECK(id = 1),
  display_format TEXT NOT NULL
    CHECK(display_format IN ('iterm', 'kitty', 'sixels', 'symbols'))
);

INSERT INTO settings (id, display_format) VALUES (1, 'symbols');
