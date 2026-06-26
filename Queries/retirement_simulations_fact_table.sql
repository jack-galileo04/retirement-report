-- Main Retirement Savings fact table
DROP TABLE IF EXISTS analytics.fact_retirement_simulations;

CREATE TABLE analytics.fact_retirement_simulations (
    sim_id INT,
    sex_key INT,
    starting_age INT,
    retirement_age INT,
    invest_start_year INT,
    death_year INT,
    risk_profile_key INT,
    annuity FLOAT,
    terminal FLOAT,
    horizon INT,
    death_age INT
);


INSERT INTO analytics.fact_retirement_simulations
SELECT 
    s.sim_id,
    sx.sex_key,
    s.starting_age,
    s.retirement_age,
    s.invest_start_date AS invest_start_year,
    s.death_year,
    rp.risk_profile_key,
    s.annuity,
    s.terminal,
    s.death_year - s.invest_start_date AS horizon,
    s.retirement_age + s.death_year - s.invest_start_date AS death_age
FROM processed.retirement_simulations AS s
INNER JOIN analytics.dim_sex AS sx 
    ON s.sex = sx.sex
INNER JOIN analytics.dim_risk_profile AS rp 
    ON s.risk_profile = rp.risk_profile