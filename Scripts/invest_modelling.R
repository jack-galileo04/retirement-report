## ----include=FALSE, warning = FALSE-----------------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

library(tidyverse)
library(here)
library(forecast)

cpi_data <- readxl::read_excel(here("Data/Raw Data/cpi_data.xlsx")) |> 
  janitor::clean_names() |> 
  select(year, annual) |> 
  arrange(year) |> 
  mutate(annual = log(annual) - log(lag(annual)),
         monthly = (1+annual)^(1/12) - 1) |> 
  filter(!is.na(annual)) |> 
  mutate(year = as_date(paste0(year, "-01-01"))) |> 
  arrange(year) |> 
  rename(date = year)

super <- read.csv(here("Data/Raw Data/AustralianSuper Rates.csv")) |> 
  janitor::clean_names() |> 
  mutate(across(2:18, ~ parse_number(.x) / 100)) |> 
  slice(1:(n()-2)) |> 
  select(financial_year, balanced, high_growth, conservative_balanced)

sd(super[23:39,3])

period_years = 70


## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Cpi Modelling

pacf(cpi_data$annual)
acf(cpi_data$annual)

cpi_fit <- arima(cpi_data$annual, order = c(1,0,0))

cpi_annual_forecast <- matrix(data = NA, nrow = 5000, ncol = period_years)

for(i in 1:5000){
    
  cpi_annual_forecast[i,] <- ifelse(
    as.matrix(simulate(cpi_fit, nsim  = period_years)) < 0,
    0,
    as.matrix(simulate(cpi_fit, nsim  = period_years)))
}


## ---------------------------------------------------------------------------------------------------------------------------------------------------
# Super Modelling
# Including 2009 GFC to induce more volatility. 
super <- super |> 
  mutate(across(2:4, ~log(.x + 1)))

super_means <- sapply(super[23:39,-1], function(x) mean(x))
super_sds <- sapply(super[23:39,-1], function(x) sd(x))

super_forecast <- list(
  balanced = matrix(data = NA, nrow = 5000, ncol = period_years),
  growth = matrix(data = NA, nrow = 5000, ncol = period_years),
  conservative = matrix(data = NA, nrow = 5000, ncol = period_years)
)

super_forecast_calc <- list(
  balanced = matrix(data = NA, nrow = 5000, ncol = period_years),
  growth = matrix(data = NA, nrow = 5000, ncol = period_years),
  conservative = matrix(data = NA, nrow = 5000, ncol = period_years)
)

for(i in 1:5000){
  
  error <- rnorm(period_years, 0, 1)  
  
  for(j in 1:3){

    log_return <- super_means[[j]] + super_sds[[j]] * error
    nominal_return <- exp(log_return) - 1
    super_forecast_calc[[j]][i,] <- nominal_return / (1+cpi_annual_forecast[i,]) + 1
    
    super_forecast[[j]][i,] <- cumprod(super_forecast_calc[[j]][i,])
  }
  
}

write.csv(super_forecast, file = here("Data/Processed Data/super_forecast.csv"))
write.csv(super_forecast_calc, file = here("Data/Processed Data/super_forecast_calc.csv"))


## ---------------------------------------------------------------------------------------------------------------------------------------------------
knitr::purl("invest_modelling.Rmd", )

