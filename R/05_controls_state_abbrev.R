source(here::here("R", "00_config.R"))
library(dplyr)
library(readr)

in_dir  <- DIR_CONTROLS
out_file <- file.path(in_dir, "medicaid_expansion_quarterly_2006_2023.csv")

years <- 2006:2023
file <- file.path(in_dir, "medicaid_expansion_quarterly_2006_2023.csv")
df <- read_csv(file)

df <- df %>%
  mutate(state = case_when(
    statefull == "District of Columbia" ~ "DC",
    TRUE ~ state.abb[match(statefull, state.name)]
  ))

write_csv(df, out_file)

