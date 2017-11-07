PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

INSERT INTO locations (id, name) VALUES (1001, 'Main Warehouse');
INSERT INTO locations (id, name) VALUES (1002, 'Auxiliary Warehouse');

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
