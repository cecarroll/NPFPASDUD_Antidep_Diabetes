source(here::here("R", "00_config.R"))

library(dplyr)
library(stringr)
library(purrr)
library(readr)
library(readxl)
# (path handled by 00_config.R)
years  <- 6:23
in_dir <- DIR_RAW_EXTERNAL
out_dir <- DIR_CONTROLS
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

clean_num <- function(x) {
  if (is.numeric(x)) return(x)
  readr::parse_number(as.character(x))
}

state_ur_all <- NULL

walk(years, function(y) {
  
  yy <- sprintf("%02d", y)
  in_file <- file.path(in_dir, paste0("laucnty", yy, ".xlsx"))
  
  df <- read_excel(in_file, skip = 1) %>%
    rename_with(~ str_squish(.x))  # remove weird whitespace in names
  
  # ---- build state-year unemployment from this df ----
  state_ur_y <- df %>%
    mutate(
      # force these to numeric; header rows become NA
      `State FIPS Code` = suppressWarnings(as.integer(clean_num(`State FIPS Code`))),
      Year             = suppressWarnings(as.integer(clean_num(Year))),
      
      # numeric columns (works whether they came in numeric or character)
      `Labor Force` = clean_num(`Labor Force`),
      Employed      = clean_num(Employed),
      Unemployed    = clean_num(Unemployed)
    ) %>%
    # drop the accidental header row(s) and any junk rows
    filter(!is.na(`State FIPS Code`), !is.na(Year)) %>%
    mutate(
      `State FIPS Code` = sprintf("%02d", `State FIPS Code`)
    ) %>%
    group_by(`State FIPS Code`, Year) %>%
    summarise(
      labor_force = sum(`Labor Force`, na.rm = TRUE),
      employed    = sum(Employed, na.rm = TRUE),
      unemployed  = sum(Unemployed, na.rm = TRUE),
      unemployment_rate = 100 * unemployed / (employed + unemployed),
      .groups = "drop"
    )
  
  state_ur_all <<- bind_rows(state_ur_all, state_ur_y)
  
  rm(df, state_ur_y)
  gc(FALSE)
  
  cat("File:", basename(in_file), "| rows so far:", nrow(state_ur_all), "\n")
})

state_ur_all <- state_ur_all %>%
  arrange(`State FIPS Code`, Year) %>%
  distinct(`State FIPS Code`, Year, .keep_all = TRUE)

state_ur_all

out_file <- file.path(out_dir, "unrate.csv")
write_csv(state_ur_all, out_file)

