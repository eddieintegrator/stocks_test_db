PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

INSERT INTO positions (id, name, volume) VALUES (2001, 'Shelf A001', 200);
INSERT INTO positions (id, name, volume) VALUES (2002, 'Shelf A002', 100);
INSERT INTO positions (id, name, volume) VALUES (3001, 'Pool Space', 200);
INSERT INTO positions (id, name, volume) VALUES (3002, 'Expedition', 100);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
