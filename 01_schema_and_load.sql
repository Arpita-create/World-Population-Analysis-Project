/*
  Setup: create the database + table and load the world population CSV.
  Run this once before the analysis file.
*/

DROP DATABASE IF EXISTS world_population;
CREATE DATABASE world_population;
USE world_population;

DROP TABLE IF EXISTS population;
CREATE TABLE population (
    rank_no          INT,
    cca3             CHAR(3),
    country          VARCHAR(100),
    continent        VARCHAR(50),
    pop_2023         BIGINT,
    pop_2022         BIGINT,
    pop_2020         BIGINT,
    pop_2015         BIGINT,
    pop_2010         BIGINT,
    pop_2000         BIGINT,
    pop_1990         BIGINT,
    pop_1980         BIGINT,
    pop_1970         BIGINT,
    area_km2         BIGINT,
    density_per_km2  DECIMAL(12,2),
    growth_rate      DECIMAL(8,4),   -- stored as a number, e.g. 0.81 (see note below)
    world_percentage DECIMAL(6,4)    -- same, e.g. 17.85
);

-- MySQL blocks local file loading by default, so turn it on first.
SET GLOBAL local_infile = 1;

-- growth rate and world percentage come in as text with a '%' sign
-- (like "0.81%"), so read them into variables and strip the '%' on load.
-- If this errors on the file path, just use the SQLTools "Import CSV" button.
LOAD DATA LOCAL INFILE 'world_population.csv'
INTO TABLE population
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'          -- change to '\r\n' if the file is Windows-saved
IGNORE 1 ROWS
(rank_no, cca3, country, continent,
 pop_2023, pop_2022, pop_2020, pop_2015, pop_2010, pop_2000,
 pop_1990, pop_1980, pop_1970, area_km2, density_per_km2,
 @growth, @world_pct)
SET growth_rate      = REPLACE(@growth, '%', ''),
    world_percentage = REPLACE(@world_pct, '%', '');

-- sanity check - should be 234 rows
SELECT COUNT(*) FROM population;
SELECT * FROM population LIMIT 5;
