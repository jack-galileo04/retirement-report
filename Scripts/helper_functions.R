library(tidyverse)

# Converts columns representing monthly returns into per annum returns.

convert_mthly_to_pa <- function(df) {
  df |> 
    transmute(
      !!!setNames(
        lapply(seq(1, ncol(df)-1, by = 12), function(start){
          apply(df[, start:(start + 12 - 1)], 1, prod)
        }), 
        seq_len(ncol(df) / 12) + 2025
      )
    )
  
}


# Takes cumulative survival matrix, and death random number, and gives death year for each person/diagonal.

calculate_death_years <- function(cum_surv_df, death_rand) {
  
  cum_surv_df |> 
    rownames_to_column(var = "age") |> 
    pivot_longer(cols = -1,
                 values_to = "cum_surv_pr",
                 names_to = "year") |> # Pivots matrix format into long tidy format
    mutate(age = as.numeric(age),
           year = as_date(year)) |> 
    drop_na(cum_surv_pr) |> # The NAs arise from top right triangle of original matrix (no cumulative survival)
    mutate(starting_age = 2026 - year(year) + age,
           retirement_age = min(year(year)) - year(year) + age) |> # Create starting age as of 2026, retirement age variables (based on list element)
    filter(starting_age >= 50 & starting_age <= 70) |> # Restricts rows to only retirees in scope of report based on 2026 age
    filter(retirement_age >= 50 & retirement_age <= 70) |> # Restricts rows to only retirees in scope of report based on wished retirement age
    group_by(starting_age) |> 
    mutate(is_alive = ifelse(cum_surv_pr > death_rand, 1, 0)) |> # Is alive if cumulative survival is greater than random uniform number
    filter(is_alive == 0) |> # Selects years which each person is dead
    arrange(starting_age, year) |> 
    slice_head(n =1) |> # Filters rows for year of death
    ungroup() |> 
    transmute(starting_age, retirement_age, death_year = year(year))
  
}


# Did not use yet, but will use a function to speed up final annuity and terminal factor calculations.

calculate_invest_returns <- function(mort_sim_row, invest) {
  start <- (mort_sim_row[5] - 2026) * 12 + 1
  end <- (mort_sim_row[6] - 2026) * 12 + 1
  sim <- mort_sim_row[1]
  
  seg <- invest[sim, start:end, drop = TRUE]
  
  terminal <- prod(seg)
  annuity <- sum(cumprod(seg))
}

