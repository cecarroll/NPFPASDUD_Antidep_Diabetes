source(here::here("R", "00_config.R"))
library(readr)
library(readxl)
library(dplyr)
library(stringr)
library(janitor)


controls_dir <- DIR_CONTROLS

clean_names <- function(df) {
  names(df) <- names(df) |>
    tolower() |>
    gsub("[^a-z0-9]+", "_", x = _) |>
    gsub("^_|_$", "", x = _)
  df
}

as_state_abbr <- function(x) {
  x <- str_squish(as.character(x))
  out <- ifelse(nchar(x) == 2, toupper(x), NA_character_)
  nm <- c(state.name, "District of Columbia")
  ab <- c(state.abb,  "DC")
  idx <- match(toupper(x), toupper(nm))
  out[is.na(out)] <- ab[idx[is.na(out)]]
  out
}

# lookup: STATEFIP -> state abbr
state_lu <- read_excel(file.path(controls_dir, "STATEFIPS.xlsx")) |>
  clean_names() |>
  transmute(
    statefip = as.integer(statefip),
    state    = as_state_abbr(state)
  ) |>
  filter(!is.na(statefip), !is.na(state)) |>
  distinct(statefip, state)

# quarterly medicaid expansion file (base)
med_q <- read_csv(file.path(controls_dir, "medicaid_expansion_quarterly_2006_2023.csv"),
                  show_col_types = FALSE) |>
  clean_names()

# normalize keys
med_q <- med_q |>
  mutate(
    year  = as.integer(year),
    # accept quarter / qtr / q; pick whichever exists
    quarter = case_when(
      "quarter" %in% names(med_q) ~ as.integer(quarter),
      TRUE ~ NA_integer_
    )
  )

if (any(is.na(med_q$quarter))) {
  # if quarter is like "Q1" etc, try to parse
  med_q <- med_q |>
    mutate(
      quarter = ifelse(
        is.na(quarter),
        as.integer(str_extract(toupper(as.character(coalesce(quarter, qtr, q))), "[1-4]")),
        quarter
      )
    )
}

if (!("medicaid_expansion" %in% names(med_q))) {
  stop("Column 'medicaid_expansion_treat' not found in medicaid_expansion_quarterly_2006_2023.csv")
}

statefip <- read_excel(file.path(controls_dir, "statefips.xlsx")) |> clean_names()
med_q <- full_join(statefip,med_q, by = "state")

#med_q <- med_q |>
  #select(-statefip.y, -fullstate.y, -statefull, -fullstate.x) |>
  #rename("statefip" = "statefip.x")

# FINAL: your clean quarterly panel (what you asked for)
treat_panel <- med_q |>
  transmute(
    
    state    = state,                     # abbreviation
    year     = as.integer(year),
    quarter  = as.integer(quarter),
    medicaid_expansion    = as.integer(medicaid_expansion != 0)  # force 0/1
  ) |>
  filter( !is.na(state), !is.na(year), !is.na(quarter)) |>
  arrange( year, quarter)

write_csv(treat_panel, file.path(controls_dir, "treat_quarterly.csv"))


deflator <- read_csv(file.path(controls_dir, "deflator.csv"), show_col_types = FALSE) |> clean_names()
census <- read_csv(file.path(controls_dir, "censusmetrics_2006_2023.csv"), show_col_types= FALSE) |>clean_names()

deflatedcensustotal <- inner_join(deflator,census,by = "year")



deflatedcensustotal <- deflatedcensustotal %>% mutate(avg_inc_adj = deflator * mean_income)
deflatedcensustotal <- deflatedcensustotal %>% mutate(med_inc_adj = deflator * median_income)
deflatedcensustotal <- deflatedcensustotal %>% mutate(tot_inc_adj = deflator * tot_income)


write_csv(deflatedcensustotal, file.path(controls_dir, "deflatedcensustotal.csv") )

obesity <- read_csv(file.path(controls_dir, "llcp_2011_2023_prop_bmi34_by_year_state.csv"), show_col_types = FALSE) |> clean_names()
unrate <- read_csv(file.path(controls_dir, "unrate.csv"), show_col_types = FALSE) |> clean_names()
uk_metrics <- read_excel(file.path(controls_dir, "uk_metrics.xlsx")) |> clean_names()
census_defl <- read_csv(file.path(controls_dir, "deflatedcensustotal.csv"), show_col_types = FALSE) |> clean_names()
statefips <- read_excel(file.path(controls_dir, "statefips.xlsx")) |> clean_names()
NPSet <- read_csv(file.path(controls_dir, "NPFPASet_Final.csv"), show_col_types = FALSE) |> clean_names()

obesity <- obesity |> mutate(statefip = as.integer(statefip), year = as.integer(year))
unrate <- unrate |> mutate(statefip = as.integer(statefip), year = as.integer(year))
uk_metrics <- uk_metrics |> mutate(statefip = as.integer(statefip), year = as.integer(year))
census_defl <- census_defl |> mutate(statefip = as.integer(statefip), year = as.integer(year))

treat_panel <- full_join(statefips, treat_panel, by = c("state"))

massive <- treat_panel|>
  inner_join(obesity, by= c("statefip", "year")) |>
  inner_join(unrate,      by = c("statefip", "year" )) |>
  inner_join(uk_metrics,  by = c("statefip", "year"), suffix = c("", "_uk")) |>
  inner_join(census_defl, by = c("statefip", "year"), suffix = c("", "_census")) |>
  inner_join(NPSet, by = c("state", "year", "quarter")) |>
  arrange(statefip, year, quarter)

write_csv(massive, file.path(controls_dir, "controls_final_quarterly.csv"))

