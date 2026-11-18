source(here::here("R", "00_config.R"))
# n_na (suppressed-cell counts per state-quarter) is built in 09; run it first if needed
if (!exists("tab_bad")) source(here::here("R", "09_suppression_missingness.R"))
out_dir <- paste0(DIR_FIGS, "/")

library(purrr)
library(dplyr)
library(ggplot2)
library(scales)
library(readr)
library(zoo)
library(stringr)
library(did)
library(fixest)

in_dir <- paste0(DIR_FILTERED, "/")

drug_files <- c(
  "SDUD_biguanides_metformin.csv",
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

prep_panel <- function(df, time_q_max = 8082, drop_year_2010 = FALSE) {
  df %>%
    mutate(
      time_q = year * 4 + (quarter - 1),
      yq     = zoo::as.yearqtr(paste(year, quarter), format = "%Y %q")
    ) %>%
    filter(!is.na(treat)) %>%
    { if (drop_year_2010) filter(., year != 2010) else . } %>%
    filter(time_q <= time_q_max) %>%
    group_by(statefip) %>%
    mutate(
      treat_now = as.integer(treat),                          # time-varying D_it
      ever_treat = as.integer(any(treat_now == 1, na.rm=TRUE)),
      first_treat_time_q = ifelse(ever_treat == 1,
                                  min(time_q[treat_now == 1], na.rm = TRUE),
                                  0L),
      first_treat_time_q = as.integer(first_treat_time_q),
      # event time: NA for never-treated (keeps life simpler)
      event_time = ifelse(first_treat_time_q == 0L, NA_integer_,
                          as.integer(time_q - first_treat_time_q))
    ) %>%
    ungroup() %>%
    mutate(
      time_q = as.integer(time_q),
      statefip = as.integer(statefip)
    )
}

collapse_state_q <- function(df) {
  
  # columns you want to "carry forward" (must be constant within state-quarter)
  keep_num <- c(
    "prop_bmi4","poverty_rate","share_black","share_ba_or_more",
    "share_metro_non","medicaid_beneficiaries","avg_inc_adj",
    "mean_age","share_female","medicaid_expansion"
  )
  
  keep_int <- c("treat_now","ever_treat","first_treat_time_q","time_q","event_time")
  
  df %>%
    group_by(yq, statefip) %>%
    summarise(
      number_of_prescriptions = sum(number_of_prescriptions, na.rm = TRUE),
      
      across(all_of(keep_int), const_or_na_int),
      across(all_of(keep_num), const_or_na_num),
      
      .groups = "drop"
    )
}

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
  )
  
  df %>%
    prep_panel(time_q_max = 8082, drop_year_2010 = FALSE) %>%
    collapse_state_q()
}





# -----------------------------
# 4) RUN ALL CLASSES
# -----------------------------
drug_panels <- map(drug_files, read_process_one)

# if you want the list named by class:
names(drug_panels) <- drug_files |>
  str_replace("^SDUD_", "") |>
  str_replace("\\.csv$", "")

# A) one combined long panel with a drug_class column
df_all_classes <- bind_rows(drug_panels)

# B) or keep as a named list: drug_panels$biguanides, drug_panels$tzds, etc.


df_total <- bind_rows(drug_panels) %>%
  group_by(statefip, yq) %>%
  summarise(
    number_of_prescriptions = sum(number_of_prescriptions, na.rm = TRUE),
    treat_now = first(na.omit(treat_now)),
    first_treat_time_q = first(na.omit(first_treat_time_q)),
    prop_bmi4= first(na.omit(prop_bmi4)),
    poverty_rate= first(na.omit(poverty_rate)),
    share_black= first(na.omit(share_black)),
    share_ba_or_more= first(na.omit(share_ba_or_more)),
    medicaid_beneficiaries= first(na.omit(medicaid_beneficiaries)),
    share_metro_non= first(na.omit(share_metro_non)),
    avg_inc_adj= first(na.omit(avg_inc_adj)),
    mean_age= first(na.omit(mean_age)),
    share_female= first(na.omit(share_female)),
    medicaid_expansion= first(na.omit(medicaid_expansion)),
    treat_now= first(na.omit(treat_now)),
    ever_treat= first(na.omit(ever_treat)),
    time_q= first(na.omit(time_q)),
    #event_time= first(na.omit(event_time)),
    
    .groups = "drop"
  )


##TEMP: Will replace when na's enter controls maybe
df_total <- df_total %>%
  left_join(tab_bad, by = c("statefip", "yq"))

att <- att_gt(
  yname  = "number_of_prescriptions",
  tname  = "time_q",
  idname = "statefip",
  gname  = "first_treat_time_q",
  xformla = ~prop_bmi4 + avg_inc_adj + share_black + share_metro_non +
  medicaid_beneficiaries + mean_age + share_female + medicaid_expansion +n_na
  ,
  data   = df_total,
  panel  = TRUE,
  control_group = "notyettreated",
  allow_unbalanced_panel = TRUE
)

#plot the did 
es <- aggte(att, type = "dynamic")
p <- ggdid(es)
#plot the did 
p +
  labs(
    title = "Event study: NP FPA → Metformin prescriptions",
    subtitle = "Callaway–Sant’Anna DiD (nevertreated controls)",
    x = "Event time (quarters relative to adoption)",
    y = "ATT on prescriptions"
  )

ggsave(paste0(out_dir, "DIDTotalWControls.png"), plot = p, width = 8, height = 5) 












library(fixest)
#sun-abraham did which makes small cohorts such as ours less of a problem: DiDn't work even more
m_es <- feols(
  number_of_prescriptions ~ sunab(first_treat_time_q, time_q, ref.p = -1) +
    prop_bmi4 + avg_inc_adj + share_black + share_metro_non +
    medicaid_beneficiaries + mean_age + share_female + medicaid_expansion +n_na
  | statefip + time_q,
  cluster = "statefip",
  data = df_total
)
out_dir <- paste0(DIR_FIGS, "/")
out_file <- file.path(out_dir, "feolsTotalWControlsWNas.png")

png(out_file, width = 8, height = 5, units = "in", res = 300)
fixest::iplot(m_es)        # draws to the png device
dev.off()


# -----------------------------
# 5) OPTIONAL: WRITE OUTPUTS
# -----------------------------
out_dir <- DIR_PANEL
walk2(names(drug_panels), drug_panels, ~ write_csv(.y, file.path(out_dir, paste0("STATEQ_", .x, ".csv"))))
write_csv(df_all_classes, file.path(out_dir, "STATEQ_ALL_Diabetes.csv"))
