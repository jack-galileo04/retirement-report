-- Adding in primary keys for each table

ALTER TABLE analytics.fact_retirement_simulations
ADD CONSTRAINT pk_fact_simulation
PRIMARY KEY (sim_id, sex_key, starting_age, retirement_age, risk_profile_key);

ALTER TABLE analytics.fact_simulation_investment_path
ADD CONSTRAINT pk_sim_path
PRIMARY KEY (sim_id, risk_profile_key, year);
