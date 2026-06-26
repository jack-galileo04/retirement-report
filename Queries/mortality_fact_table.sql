-- Mortality Investment Path fact table
DROP TABLE IF EXISTS analytics.fact_mortality;

CREATE TABLE analytics.fact_mortality (
    sex_key INT,
    starting_age INT,
    year INT,
    current_age INT,
    mortality FLOAT,
    log_mortality FLOAT,
);

INSERT INTO analytics.fact_mortality
SELECT 
    sx.sex_key,
    m.current_age AS starting_age,
    m.year,
    m.current_age + m.year - 2026 AS current_age,
    m.mortality,
    LOG10(m.mortality) AS log_mortality
FROM processed.mortality AS m
INNER JOIN analytics.dim_sex AS sx 
    ON m.sex = sx.sex

SELECT * FROM analytics.fact_mortality