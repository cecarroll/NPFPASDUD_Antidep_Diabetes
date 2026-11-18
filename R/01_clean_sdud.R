source(here::here("R", "00_config.R"))
# install.packages(c("haven", "dplyr", "stringr", "purrr", "readxl", "readr"))
library(haven)
library(dplyr)
library(stringr)
library(purrr)
library(readxl)
library(readr)


#Prep your packages and directory 
# (path handled by 00_config.R)

# Demo

#df <- read_csv("Original_Excels/StateDrugUtilizationData2006.csv")

#head(df)
#df[2]
#write.csv(df, "NPProject/DIDISDUDR/CSVS/2006.csv", row.names = FALSE)





# --- cleaning function ---
clean_sdud <- function(df) {
  
  df <- df %>%
    mutate(
      `Utilization Type` = case_when(
        str_trim(str_to_upper(`Utilization Type`)) == "MCOU" ~ 1L,
        str_trim(str_to_upper(`Utilization Type`)) == "FFSU" ~ 0L,
        TRUE ~ NA_integer_
      ),
      `Suppression Used` = case_when(
        str_trim(str_to_lower(as.character(`Suppression Used`))) == "false" ~ 0L,
        str_trim(str_to_lower(as.character(`Suppression Used`))) == "true"  ~ 1L,
        TRUE ~ NA_integer_
      ),
      
      # NDC: force 11-digit zero-padded string
      NDC = case_when(
        is.na(NDC) ~ NA_character_,
        TRUE ~ str_pad(str_remove_all(as.character(NDC), "\\D"),
                       width = 11, side = "left", pad = "0")
      )
    )
  
  df
}


# ---- Batch process years (2006–2024) ----
#You can only do <4 at a time
years <- 2006:2023  # memory-heavy: on a 16 GB machine run ~3 years per pass

in_dir  <- paste0(DIR_RAW_SDUD, "/")
out_dir <- DIR_SDUD_CLEAN

walk(years, function(y) {

  in_file  <- file.path(in_dir,  paste0("StateDrugUtilizationData", y, ".csv"))
  out_file <- file.path(out_dir, paste0("SDUD", y, "clean.csv"))
  #in_file  <- file.path(in_dir,  paste0("StateDrugUtilizationData", 2012, ".csv"))
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
  
  #detective code for parsing problems
  #probs <- problems(df)
  #if (nrow(probs) > 0) {
  #  cat("\n--- Parsing problems for year", y, "---\n")
  #  
  #  print(probs, n = Inf)
  #}
  #There are <5 bad observations per year 
  #that couldn't be read in with the types above^^
  
  df <- clean_sdud(df)
  write_csv(df, out_file)
  gc()
  rm(df)
})


