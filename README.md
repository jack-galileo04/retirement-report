# Personalised Retirement Savings Report

### Tools: Power BI, Power Query, DAX, R, Tidyverse, Mortality Modelling, Economic Modelling
### Problem: Providing personalised insights for required retirement savings via an interactive Power BI report.

## Overview:
This project constructs an analytical report, employing
- Data Visualisation
- Data Analysis
- Data Wrangling
- Data Modelling
- Mortality Modelling
- Economic Modelling

## Data:
Data is sourced from the Australian Government Actuaries (mortality), Rate Inflation (cpi), AustralianSuper (investment).
https://aga.gov.au/publications/life-tables
https://www.rateinflation.com/consumer-price-index/australia-historical-cpi/
https://www.australiansuper.com/why-choose-us/our-performance?superType=Super&display=table

## Repository Structure:
/ data/ Raw Data/ 'AustralianSuper Rates'.xlsx cpi_data.xlsx lifetable_data.xslx / Processed Data/ dim_risk_profile.csv dim_sex.csv retirement_simulations.csv simulations.csv super_forecast.csv super_forecast_calc.csv     / Scripts/ helper_functions.R invest_modelling.R mortality_modelling.R retirement_data.R

## Disclaimer:
File sizes were to big to commit to this repository. simulations.csv, retirement_simulations.csv, and the .pbix file were too large. Hence, the data was trimmed, and the Power BI report file was removed.

## Products:
- Retirement Report: https://app.powerbi.com/view?r=eyJrIjoiNDgyMGQ5YzEtNWI4Mi00ZDhlLThiMGMtOWJkMzZlYTc3NzAyIiwidCI6IjNhYTEyYWIxLWQyNGEtNGI0Yy04YjI0LTk5ZWI3ODE2YzJjZSJ9&pageName=f4c125951603c0da0ae3

## Future Improvements:
- Include a mortality insights page.
- Improve data quality for investment returns and cpi.
- Incorporate accumulation tax above 2M in super.
- Incorporate more demographic data (state based moretality, etc)
