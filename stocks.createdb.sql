PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: loc_pos
DROP TABLE IF EXISTS loc_pos;

CREATE TABLE loc_pos (
    loc_id    INTEGER      REFERENCES locations (id) 
                           NOT NULL,
    pos_id    INTEGER      REFERENCES positions (id) 
                           NOT NULL,
    code      VARCHAR (12) UNIQUE
                           NOT NULL,
    threshold INTEGER      NOT NULL,
    PRIMARY KEY (
        loc_id,
        pos_id
    )
);


-- Table: locations
DROP TABLE IF EXISTS locations;

CREATE TABLE locations (
    id   INTEGER       PRIMARY KEY AUTOINCREMENT
                       NOT NULL,
    name VARCHAR (160) NOT NULL
);


-- Table: materials
DROP TABLE IF EXISTS materials;

CREATE TABLE materials (
    id        VARCHAR (10)  PRIMARY KEY
                            NOT NULL,
    name      VARCHAR (160) NOT NULL,
    measure   VARCHAR (3)   NOT NULL,
    threshold INTEGER       NOT NULL
);


-- Table: positions
DROP TABLE IF EXISTS positions;

CREATE TABLE positions (
    id     INTEGER       PRIMARY KEY AUTOINCREMENT
                         NOT NULL,
    name   VARCHAR (160) NOT NULL,
    volume INTEGER       NOT NULL
);


-- Table: stock_movements
DROP TABLE IF EXISTS stock_movements;

CREATE TABLE stock_movements (
    created    DATETIME NOT NULL
                        DEFAULT (CURRENT_TIMESTAMP),
    stored     DATE     NOT NULL,
    space_code INTEGER  REFERENCES loc_pos (code) 
                        NOT NULL,
    mat_id     INTEGER  REFERENCES materials (id) 
                        NOT NULL,
    units      INTEGER  NOT NULL
);


-- View: spaces
DROP VIEW IF EXISTS spaces;
CREATE VIEW spaces AS
    SELECT k.code,
           l.name AS location_name,
           p.name AS position_name,
           k.threshold,
           p.volume
      FROM loc_pos k
           INNER JOIN
           locations l ON k.loc_id = l.id
           INNER JOIN
           positions p ON k.pos_id = p.id
     ORDER BY l.name,
              p.name;


-- View: stocks_by_materials
DROP VIEW IF EXISTS stocks_by_materials;
CREATE VIEW stocks_by_materials AS
    SELECT m.mat_id,
           t.name,
           sum(m.units) AS units,
           t.measure
      FROM stock_movements m
           INNER JOIN
           spaces s ON m.space_code = s.code
           INNER JOIN
           materials t ON m.mat_id = t.id
     GROUP BY t.name
     ORDER BY t.name;


-- View: stocks_by_space
DROP VIEW IF EXISTS stocks_by_space;
CREATE VIEW stocks_by_space AS
    SELECT m.space_code,
           s.location_name,
           s.position_name,
           m.mat_id,
           t.name,
           sum(m.units) AS units
      FROM stock_movements m
           INNER JOIN
           spaces s ON m.space_code = s.code
           INNER JOIN
           materials t ON m.mat_id = t.id
     GROUP BY s.code,
              m.mat_id
     ORDER BY s.location_name,
              s.position_name,
              t.name;


-- View: stocks_material_threshold
DROP VIEW IF EXISTS stocks_material_threshold;
CREATE VIEW stocks_material_threshold AS
    SELECT st.*,
           m.threshold
      FROM stocks_by_materials st
           INNER JOIN
           materials m ON st.mat_id = m.id
     WHERE st.units < m.threshold;


-- View: stocks_space_threshold
DROP VIEW IF EXISTS stocks_space_threshold;
CREATE VIEW stocks_space_threshold AS
    SELECT st.*,
           sp.threshold
      FROM stocks_by_space st
           INNER JOIN
           spaces sp ON st.space_code = sp.code
     WHERE st.units < sp.threshold;


-- View: stocks_space_volume
DROP VIEW IF EXISTS stocks_space_volume;
CREATE VIEW stocks_space_volume AS
    SELECT st.*,
           sp.volume
      FROM stocks_by_space st
           INNER JOIN
           spaces sp ON st.space_code = sp.code
     WHERE st.units > sp.volume;


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
