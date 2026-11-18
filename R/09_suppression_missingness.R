source(here::here("R", "00_config.R"))

library(dplyr)
library(ggplot2)
library(scales)
library(readr)
library(zoo)
library(stringr)
library(purrr)

in_dir <- paste0(DIR_FILTERED, "/")
out_dir <- paste0(DIR_FIGS, "/")

drug_files <- c(
  "SDUD_sulfonylureas_glipizide.csv",
  "SDUD_sulfonylureas_glyburide.csv",
  "SDUD_sulfonylureas_glimepiride.csv",
  "SDUD_sulfonylureas_tolbutamide.csv",
  "SDUD_sulfonylureas_tolazamide.csv",
  "SDUD_sulfonylureas_chlorpropamide.csv",
  "SDUD_tzds_pioglitazone.csv",
  "SDUD_tzds_rosiglitazone.csv",
  "SDUD_dpp4_inhibitors_linagliptin.csv",
  "SDUD_dpp4_inhibitors_saxagliptin.csv",
  "SDUD_dpp4_inhibitors_alogliptin.csv",
  "SDUD_glp1_incretins_semaglutide.csv",
  "SDUD_dpp4_inhibitors_sitagliptin.csv",
  "SDUD_glp1_incretins_semaglutide.csv",
  "SDUD_glp1_incretins_liraglutide.csv",
  "SDUD_glp1_incretins_dulaglutide.csv",
  "SDUD_glp1_incretins_exenatide.csv",
  "SDUD_glp1_incretins_lixisenatide.csv",
  "SDUD_glp1_incretins_tirzepatide.csv",
  "SDUD_sglt2_inhibitors_empagliflozin.csv",
  "SDUD_sglt2_inhibitors_dapagliflozin.csv",
  "SDUD_sglt2_inhibitors_ertugliflozin.csv",
  "SDUD_sglt2_inhibitors_canagliflozin.csv",
  "SDUD_meglitinides_repaglinide.csv",
  "SDUD_meglitinides_nateglinide.csv",
  "SDUD_alpha_glucosidase_acarbose.csv",
  "SDUD_alpha_glucosidase_miglitol.csv",
  "SDUD_amylin_analogs_pramlintide.csv",
  "SDUD_insulins_insulin_aspart.csv",
  "SDUD_insulins_insulin_lispro.csv",
  "SDUD_insulins_insulin_glulisine.csv",
  "SDUD_insulins_insulin_regular.csv",
  "SDUD_insulins_insulin_nph.csv",
  "SDUD_insulins_insulin_detemir.csv",
  "SDUD_insulins_insulin_glargine.csv",
  "SDUD_insulins_insulin_degludec.csv"
)

# If your filenames differ, just edit the strings above.
# (The names on the left become your drug_class labels.)

# -----------------------------
# 2) READ SPEC (your col_types)
# -----------------------------
col_spec <- cols(
  utilization_type                 = col_integer(),
  state                            = col_character(),
  ndc                              = col_character(),
  labeler_code                     = col_character(),
  product_code                     = col_character(),
  package_size                     = col_character(),
  year                             = col_integer(),
  quarter                          = col_integer(),
  suppression_used                 = col_integer(),
  product_name                     = col_character(),
  units_reimbursed                 = col_double(),
  number_of_prescriptions          = col_double(),
  statefip                         = col_double(),
  medicaid_expansion               = col_integer(),
  prop_bmi34                       = col_double(),
  prop_bmi4                        = col_double(),
  unemployment_rate                = col_double(),
  population                       = col_double(),
  afdc_tanf_benefit_for_4_person_family = col_double(),
  fs_snap_benefit_for_4_person_family   = col_double(),
  poverty_rate                     = col_double(),
  governor_is_democrat_1_yes       = col_character(),
  federal_minimum_wage             = col_double(),
  state_minimum_wage               = col_double(),
  medicaid_beneficiaries           = col_double(),
  cpi                              = col_double(),
  mean_age                         = col_double(),
  share_female                     = col_double(),
  share_black                      = col_double(),
  share_metro_indet                = col_double(),
  share_metro_non                  = col_double(),
  share_metro_central              = col_double(),
  share_metro_noncentral           = col_double(),
  share_metro_mixed                = col_double(),
  share_ba_or_more                 = col_double(),
  avg_inc_adj                      = col_double(),
  med_inc_adj                      = col_double(),
  tot_inc_adj                      = col_double(),
  yearquarter                      = col_character(),
  treat                            = col_integer(),
  event_time                       = col_double(),
  total_amount_reimbursed_adj      = col_double(),
  medicaid_amount_reimbursed_adj   = col_double(),
  non_medicaid_amount_reimbursed_adj = col_double()
)

# -----------------------------
# 3) HELPERS
# -----------------------------
const_or_na_num <- function(x) {
  if (dplyr::n_distinct(x, na.rm = TRUE) <= 1) dplyr::first(x) else NA_real_
}
const_or_na_int <- function(x) {
  if (dplyr::n_distinct(x, na.rm = TRUE) <= 1) as.integer(dplyr::first(x)) else NA_integer_
}


#keepgoing=TRUE
prep_panel <- function(df) {
  df <- df %>% 
    mutate(
      time_q = year * 4 + (quarter - 1),
      yq     = zoo::as.yearqtr(paste(year, quarter), format = "%Y %q")
    ) %>%
    filter(!is.na(treat))
    
    
    
    df <- df %>%   # use dfdid if it's still at the raw (multiple rows per state-quarter)
      group_by(statefip, yearquarter, state) %>%
      summarise(
        statefip = statefip,
        state = state,
        yq =yq,
        n = n(),
        n_na = sum(is.na(number_of_prescriptions)),
        n_nonfinite = sum(!is.na(number_of_prescriptions) & !is.finite(number_of_prescriptions)),
        n_ok = sum(!is.na(number_of_prescriptions) & is.finite(number_of_prescriptions)),
        .groups = "drop"
      ) %>% distinct()
    
    #path <- file.path(out_dir, "NAs in Scrips.csv")
    #write_csv(tab_bad, path)
    #keepgoing<<- FALSE
}

#filename <- "SDUD_biguanides_metformin.csv"

read_process_one <- function(filename) {
  path <- file.path(in_dir, filename)
  
  # derive class label from filename (edit this if you want different labels)
  class_name <- filename |>
    str_replace("^SDUD_", "") |>
    str_replace("\\.csv$", "")
  
  df <- read_csv(
    path,
    na = c("", "NA", "N/A"),
    show_col_types = FALSE,
    col_types = col_spec
  ) %>% janitor::clean_names()
  
  df %>%
    prep_panel() 
 
}




# -----------------------------
# 4) RUN ALL CLASSES
# -----------------------------
drug_panels <- map(drug_files, read_process_one)

# A) one combined long panel with a drug_class column
df_all_classes <- bind_rows(drug_panels)





tab_bad <- df_all_classes %>%   # use dfdid if it's still at the raw (multiple rows per state-quarter)
  group_by( yq,state) %>%
  summarise(
    statefip = statefip,
    state = state,
    n = n(),
    n_na = sum(n_na),
    .groups = "drop"
  ) %>% distinct()



p<-ggplot(tab_bad, aes(x = yq, y = n_na)) +
  geom_line(linewidth = 1,na.rm = TRUE) +
  geom_point(na.rm = TRUE) +
  scale_y_continuous(labels = comma) +
  labs( x = "yq", y = "NaCount")

p
ggsave(paste0(out_dir, "NAs_across_quarters.png"), plot = p, width = 8, height = 5)      # best for papers
