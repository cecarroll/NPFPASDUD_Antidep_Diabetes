source(here::here("R", "00_config.R"))
library(readr)
library(readxl)
library(dplyr)
library(stringr)
library(janitor)
library(purrr)

controls_dir <- DIR_CONTROLS
NP_dir <- DIR_SDUD_CLEAN
out_dir <- DIR_SDUD_MERGED
controls <- read_csv(file.path(DIR_CONTROLS, "controls_final_quarterly.csv"), )
years <- 2006:2023
walk(years, function(y) {
  
  in_file  <- file.path(NP_dir,  paste0("SDUD", y, "clean.csv"))
  out_file <- file.path(out_dir, paste0("NPStudy", y, "final.csv"))
  #in_file  <- file.path(NP_dir,  paste0("SDUD", 2012, "clean.csv"))
  df <- read_csv(
    in_file,
    show_col_types = FALSE,
    col_types = cols(
      "Utilization Type"              = col_character(),
      "State"                         = col_character(),
      "NDC"                           = col_character(),
      "Labeler Code"                 = col_character(),
      "Product Code"                  = col_character(),
      "Package Size"                  = col_double(),
      "Year"                          = col_integer(),
      "Quarter"                       = col_integer(),
      "Suppression Used"              = col_character(),
      "Product Name"                  = col_character(),
      "Units Reimbursed"            = col_double(),
      "Number of Prescriptions"       = col_double(),
      "Total Amount Reimbursed"       = col_double(),
      "Medicaid Amount Reimbursed"    = col_double(),
      "Non Medicaid Amount Reimbursed"= col_double()
    )
  )
  df <- df |> full_join(controls, by = c("State"= "state", "Year" = "year", "Quarter" = "quarter"))
  df <- df |> mutate(`Total Amount Reimbursed Adj` = deflator * `Total Amount Reimbursed`) |> 
      mutate(`Medicaid Amount Reimbursed Adj` = deflator * `Medicaid Amount Reimbursed`)|> 
      mutate(`Non Medicaid Amount Reimbursed Adj` = deflator * `Non Medicaid Amount Reimbursed`) |>
      select(-fullstate, -wt_total, -wt_bmi34, -wt_bmi4, -labor_force, -employed, -unemployed,
                 -state_uk, -unemployment_rate_uk, -pop, -deflator, -tot_income, -mean_income,
                 -median_income, -share_hisp_any, -share_hisp_mex, -share_hisp_pr, -share_hisp_cub,
                 -share_hisp_oth, -share_white, -share_aian, -share_other, -share_edu_lt_hs,
                 -share_edu_hs_grad, -share_edu_assoc, -share_edu_ba, -share_edu_grad,
                 -share_hs_or_more, -`Total Amount Reimbursed`, -`Medicaid Amount Reimbursed`,  -`Non Medicaid Amount Reimbursed`)
  df<- df%>% clean_names()
  
  
  #out_file <- file.path(out_dir, paste0("NPStudy2012final.csv"))
  write_csv(df, out_file)
  gc()
  rm(df)
  
})


  