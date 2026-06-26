-- Sex dimension table
DROP TABLE IF EXISTS analytics.dim_sex;

CREATE TABLE analytics.dim_sex (
    sex_key INT IDENTITY(1,1) PRIMARY KEY,
    sex VARCHAR(10)
);

INSERT INTO analytics.dim_sex (sex)
SELECT DISTINCT sex
FROM processed.retirement_simulations
WHERE sex IS NOT NULL;

-- Investment Risk Profile dimension table
DROP TABLE IF EXISTS analytics.dim_risk_profile;

CREATE TABLE analytics.dim_risk_profile (
    risk_profile_key INT IDENTITY(1,1) PRIMARY KEY,
    risk_profile VARCHAR(50)
);

INSERT INTO analytics.dim_risk_profile (risk_profile)
SELECT DISTINCT risk_profile
FROM processed.retirement_simulations
WHERE risk_profile IS NOT NULL;

-- Starting Age dimension table
DROP TABLE IF EXISTS analytics.dim_starting_age;

CREATE TABLE analytics.dim_starting_age (
    starting_age INT PRIMARY KEY
);

INSERT INTO analytics.dim_starting_age (starting_age)
SELECT DISTINCT starting_age
FROM processed.retirement_simulations
WHERE starting_age IS NOT NULL;

-- Starting Age dimension table
DROP TABLE IF EXISTS analytics.dim_simulation_id;

CREATE TABLE analytics.dim_simulation_id (
    sim_id INT PRIMARY KEY
);

INSERT INTO analytics.dim_simulation_id (sim_id)
SELECT DISTINCT sim_id
FROM processed.retirement_simulations
WHERE sim_id IS NOT NULL;

-- Retirement Age dimension table
DROP TABLE IF EXISTS analytics.dim_retirement_age;

CREATE TABLE analytics.dim_retirement_age (
    retirement_age INT PRIMARY KEY
);

INSERT INTO analytics.dim_retirement_age (retirement_age)
SELECT DISTINCT retirement_age
FROM processed.retirement_simulations
WHERE retirement_age IS NOT NULL;

-- Date table
DROP TABLE IF EXISTS analytics.dim_date;

CREATE TABLE analytics.dim_date (
    year INT PRIMARY KEY
);

WITH years AS (
    SELECT CAST(2026 AS INT) as year -- starting date is 2026
    UNION ALL
    SELECT year + 1
    FROM years
    WHERE year < 2086 -- Max date = 2026 + 60
 )

INSERT INTO analytics.dim_date (year)
SELECT DISTINCT year
FROM years
OPTION (MAXRECURSION 0);