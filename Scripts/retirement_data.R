## ---------------------------------------------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

library(tidyverse)
library(here)

super_forecast_calc <- read.csv(here("Data/Processed Data/super_forecast_calc.csv")) |> 
  select(-1)
super_forecast_calc = 1 / super_forecast_calc

mort_sims <- read.csv(here("Data/Processed Data/simulations.csv")) |> 
  select(-1) |> 
  mutate(invest_start_date = 2026 + retirement_age - starting_age) |> 
  select(sim_id, sex, starting_age, retirement_age, invest_start_date, death_year)

start_year <- 2026
period_years <- 70

balanced <- super_forecast_calc[,1:(period_years)]
growth <- super_forecast_calc[,(period_years+1):(2*period_years)]
conservative <- super_forecast_calc[,(2*period_years + 1):ncol(super_forecast_calc)]

pa_invests <- list(balanced, growth, conservative)


## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Calculating annuity and terminal scale factors for each simulation

balanced_terminal <- numeric(nrow(mort_sims))
growth_terminal <- numeric(nrow(mort_sims))
conservative_terminal <- numeric(nrow(mort_sims))

balanced_annuity <- numeric(nrow(mort_sims))
growth_annuity <- numeric(nrow(mort_sims))
conservative_annuity <- numeric(nrow(mort_sims))

pb <- txtProgressBar(min = 0, max = nrow(mort_sims), style = 3)

for(i in 1:nrow(mort_sims)){

  start_year_index <- (mort_sims[i,5] - 2026) + 1 # Grabs matrix index based on retirement year
  end_year_index <- (mort_sims[i,6] - 2026) + 1 # Grabs matrix index based on death year
  sim_id <- mort_sims[i,1] # Gets the relevant simulation
  
  balanced_annuity[i] <- sum(cumprod(pa_invests[[1]][sim_id,start_year_index:end_year_index] )) # Sums cumulative discount values to get annuity factor
  balanced_terminal[i] <- prod(pa_invests[[1]][sim_id,end_year_index]) # Selects last cumulative discount value for terminal estate factor

  growth_annuity[i] <- sum(cumprod(pa_invests[[2]][sim_id,start_year_index:end_year_index] ))
  growth_terminal[i] <- prod(pa_invests[[2]][sim_id,end_year_index])
  
  conservative_annuity[i] <- sum(cumprod(pa_invests[[3]][sim_id,start_year_index:end_year_index] ))
  conservative_terminal[i] <- prod(pa_invests[[3]][sim_id,end_year_index])
  
  setTxtProgressBar(pb, i)
}


## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Combining calculations into one data frame, and wrangling into a tidy structure for Power BI reporting.

combined_simulations <- mort_sims |> 
  bind_cols(balanced_annuity = balanced_annuity,
            balanced_terminal = balanced_terminal,
            growth_annuity = growth_annuity,
            growth_terminal = growth_terminal,
            conservative_annuity = conservative_annuity,
            conservative_terminal = conservative_terminal) |> 
  pivot_longer(cols = 7:12,
               names_to = c("risk_profile", "type"),
               names_sep = "_",
               values_to = "value") |> 
  pivot_wider(names_from = type,
              values_from = value) |> 
  unnest(annuity, terminal)


## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Creating tables for Power BI reporting.

dim_sex <- data.frame(sex_key = c(1,2), sex = c("Male", "Female"))
dim_risk_profile <- data.frame(risk_profile_key = c(1,2,3), risk_profile = c("Balanced", "Growth", "Conservative"))

retirement_simulations <- combined_simulations |> 
  mutate(
    sex_key = case_when(
      sex == "male" ~ 1,
      sex == "female" ~ 2),
    risk_profile_key = case_when(
      risk_profile == "balanced" ~ 1,
      risk_profile == "growth" ~ 2,
      risk_profile == "conservative" ~ 3)
    ) |> 
  select(sim_id, sex_key, starting_age, retirement_age, invest_start_date, death_year, risk_profile_key, annuity, terminal)

write.csv(retirement_simulations, here("Data/Processed Data/retirement_simulations.csv"))
write.csv(dim_sex, here("Data/Processed Data/dim_sex.csv"))
write.csv(dim_risk_profile, here("Data/Processed Data/dim_risk_profile.csv"))


## ---------------------------------------------------------------------------------------------------------------------------------------------------
knitr::purl("retirement_data.Rmd", here("Scripts/mortality_modelling.R"))

