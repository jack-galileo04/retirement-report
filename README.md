# Personalised Retirement Savings Report

This project aims to provide an interactive report that visualises the viability of users' retirement "nest egg" in Australia. It uses stochastic economic and demographic modelling in R to provide personalisation and scenario/distributional analysis in Power BI.

---

## 🔍 Overview
This project constructs an analytical report, employing:
- Data Visualisation
- Data Analysis
- Data Wrangling
- Data Modelling
- Mortality Modelling
- Economic Modelling

The goal is to answer questions like:
- How much do I need to retire comfortably?
- How much can I withdraw/draw down each year?
- What changes make the biggest impact?
- What is the chance my savings deplete?
- What will my terminal estate look like?

---

## ⚠️ Disclaimer:
This project is not financial advice. Does not account for taxes, fees, or distinct policy changes.

File sizes were too big to commit to this repository. simulations.csv, retirement_simulations.csv, and the .pbix file were too large. Hence, the data was trimmed, and the Power BI report file was removed.

---

## ⚙️ How It Works

At a high-level, the Power BI report:
1. Takes in financial and demographic inputs (gender, current age, investment portfolio)
2. Allows the user to personalise their desired terminal estate, expected yearly expenses, and retirement age
3. Applies growth assumptions (investment returns, CPI, and mortality rates)
4. Simulates accumulations
5. Outputs projected retirement savings and insights: [Retirement Report](https://app.powerbi.com/view?r=eyJrIjoiNDgyMGQ5YzEtNWI4Mi00ZDhlLThiMGMtOWJkMzZlYTc3NzAyIiwidCI6IjNhYTEyYWIxLWQyNGEtNGI0Yy04YjI0LTk5ZWI3ODE2YzJjZSJ9&pageName=fd5649d8ab8b02bfb164)

---

## 🧠 Modelling Approach (R)

- The three different investment portfolios (conservative, balanced, growth) were modelled using a multivariate normal distribution on annualised log returns.
- Annualised CPI was modelled using basic white noise, as other time series methods that handle the slight non-stationarity were at risk of overfitting to the small dataset size.
- Mortality rates were modelled using Australian Life Tables and average projected growth rates.
- Mortality forecasts were wrangled into a tidy dataframe with all combinations of the demographic inputs.
- The results were combined using 5000 iterations of Monte Carlo simulations on the financial and demographic data.
- The output of the simulations was 5000 iterations per input combination, with an accompanying lifetime, terminal discount factor, and per annum annuity factor for expenses.

---

## 🧠 Assumptions and limitations

- Returns and CPI errors are assumed to be normally distributed
- Inflation is modelled independently of investment returns
- Expected expenses are to remain consistent
- Assumes Australia-wide mortality rates apply to the user

---

## 📂 Project Structure
.

├── Data/

│   ├── Raw Data/             # Raw data from sources

│   └── Processed Data/         # Transformed and output data

├── Scripts/                 # Scripts used for the project

├── .gitignore

├── Retirement Report.pbix                 # Not in repository due to file size.

└── README.md

---

## 📌 Future Improvements:
- Incorporate accumulation tax above 2M in super.
- Incorporate more demographic data (state-based mortality, etc)

---

## 🙌 Acknowledgements
Data is sourced from the Australian Government Actuaries (mortality), Rate Inflation (cpi), and AustralianSuper (investment).

https://aga.gov.au/publications/life-tables

https://www.rateinflation.com/consumer-price-index/australia-historical-cpi/

https://www.australiansuper.com/why-choose-us/our-performance?superType=Super&display=table
