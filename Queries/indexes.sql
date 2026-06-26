-- Indexes

CREATE INDEX idx_sim
ON analytics.fact_retirement_simulation (sex_key, starting_age, retirement_age, risk_profile_key);

CREATE INDEX idx_path
ON analytics.fact_simulation_path (risk_profile_key, year);

CREATE INDEX idx_mortality
ON analytics.fact_mortality (sex_key, start_age, year);