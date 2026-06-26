
library(tidyverse)
library(here)
library(forecast)
library(MASS)
library(DBI)
library(odbc)

config <- list(
  con = dbConnect(
    odbc::odbc(), 
    Driver = "SQL Server",
    Server = Sys.getenv("DB_SERVER"),
    Database = Sys.getenv("DB_NAME"),
    Trusted_Connection = "Yes"
  ),
  
  sims = 5000,
  start_year = 2026,
  period_years = 60,
  minimum_retirement = 50,
  retirement_window = 21
)





