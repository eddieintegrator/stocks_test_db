PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

INSERT INTO loc_pos (loc_id, pos_id, code, threshold) VALUES (1001, 2001, 'MW01', 50);
INSERT INTO loc_pos (loc_id, pos_id, code, threshold) VALUES (1001, 2002, 'MW02', 50);
INSERT INTO loc_pos (loc_id, pos_id, code, threshold) VALUES (1001, 3001, 'MWPL', 0);
INSERT INTO loc_pos (loc_id, pos_id, code, threshold) VALUES (1002, 3001, 'AWPL', 0);
INSERT INTO loc_pos (loc_id, pos_id, code, threshold) VALUES (1002, 3002, 'AWXP', 50);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
