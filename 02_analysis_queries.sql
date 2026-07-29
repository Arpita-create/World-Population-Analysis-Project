/*
  World population analysis.
  Run 01_schema_and_load.sql first, then work through these one at a time.
  2023 is the latest year in the data, so most "current" numbers use pop_2023.
*/

USE world_population;


-- First, a quick look at data quality before trusting anything.

-- any missing values in the columns we care about?
SELECT
    SUM(country IS NULL)         AS missing_country,
    SUM(continent IS NULL)       AS missing_continent,
    SUM(pop_2023 IS NULL)        AS missing_pop,
    SUM(density_per_km2 IS NULL) AS missing_density,
    SUM(growth_rate IS NULL)     AS missing_growth
FROM population;

-- any country listed twice?
SELECT country, COUNT(*)
FROM population
GROUP BY country
HAVING COUNT(*) > 1;


-- Overall numbers for 2023 - the average, spread and extremes.
SELECT
    COUNT(*)                        AS countries,
    ROUND(AVG(pop_2023))            AS avg_population,
    MIN(pop_2023)                   AS smallest,
    MAX(pop_2023)                   AS largest,
    ROUND(STDDEV_SAMP(pop_2023))    AS std_dev,
    ROUND(AVG(density_per_km2), 2)  AS avg_density
FROM population;


-- The 10 biggest countries by population.
SELECT country, continent, pop_2023, world_percentage
FROM population
ORDER BY pop_2023 DESC
LIMIT 10;


-- Most crowded countries (people per sq km).
SELECT country, continent, density_per_km2, pop_2023, area_km2
FROM population
WHERE density_per_km2 IS NOT NULL
ORDER BY density_per_km2 DESC
LIMIT 10;


-- Population rolled up by continent, plus each one's share of the world.
SELECT
    continent,
    COUNT(*)      AS countries,
    SUM(pop_2023) AS total_population,
    ROUND(100 * SUM(pop_2023) / (SELECT SUM(pop_2023) FROM population), 2) AS pct_of_world
FROM population
GROUP BY continent
ORDER BY total_population DESC;


-- Which continents are growing fastest on average?
SELECT
    continent,
    ROUND(AVG(growth_rate), 4) AS avg_growth,
    ROUND(MAX(growth_rate), 4) AS fastest,
    ROUND(MIN(growth_rate), 4) AS slowest
FROM population
GROUP BY continent
ORDER BY avg_growth DESC;


-- Fastest growing countries...
SELECT country, continent, growth_rate, pop_2023
FROM population
ORDER BY growth_rate DESC
LIMIT 10;

-- ...and the ones that are shrinking.
SELECT country, continent, growth_rate, pop_2023
FROM population
ORDER BY growth_rate ASC
LIMIT 10;


-- World population at each snapshot year from 1970 to 2023.
-- The years are separate columns, so stack them into rows with UNION.
SELECT '1970' AS year, SUM(pop_1970) AS world_population FROM population
UNION ALL SELECT '1980', SUM(pop_1980) FROM population
UNION ALL SELECT '1990', SUM(pop_1990) FROM population
UNION ALL SELECT '2000', SUM(pop_2000) FROM population
UNION ALL SELECT '2010', SUM(pop_2010) FROM population
UNION ALL SELECT '2015', SUM(pop_2015) FROM population
UNION ALL SELECT '2020', SUM(pop_2020) FROM population
UNION ALL SELECT '2022', SUM(pop_2022) FROM population
UNION ALL SELECT '2023', SUM(pop_2023) FROM population
ORDER BY year;


-- How much each country grew over the full 1970-2023 stretch, ranked.
SELECT
    country,
    continent,
    pop_1970,
    pop_2023,
    ROUND(100 * (pop_2023 - pop_1970) / NULLIF(pop_1970, 0), 1) AS growth_pct,
    RANK() OVER (ORDER BY (pop_2023 - pop_1970) / NULLIF(pop_1970, 0) DESC) AS rnk
FROM population
WHERE pop_1970 > 0
ORDER BY growth_pct DESC
LIMIT 15;


-- Continent totals with a running total, so you can see how quickly
-- the top few continents add up to most of the world.
SELECT
    continent,
    SUM(pop_2023) AS continent_pop,
    SUM(SUM(pop_2023)) OVER (ORDER BY SUM(pop_2023) DESC) AS running_total,
    ROUND(100 * SUM(pop_2023) / SUM(SUM(pop_2023)) OVER (), 2) AS pct_of_world
FROM population
GROUP BY continent
ORDER BY continent_pop DESC;
