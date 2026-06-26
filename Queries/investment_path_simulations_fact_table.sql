-- Investment Path fact table
DROP TABLE IF EXISTS analytics.fact_simulation_investment_path;

CREATE TABLE analytics.fact_simulation_investment_path (
    sim_id INT,
    risk_profile_key INT,
    year INT,
    cumulative_return FLOAT,
);

INSERT INTO analytics.fact_simulation_investment_path
SELECT 
    s.sim_id,
    rp.risk_profile_key,
    s.year,
    s.cumulative_return
FROM processed.simulation_path AS s
INNER JOIN analytics.dim_risk_profile AS rp 
    ON s.risk_profile = rp.risk_profile