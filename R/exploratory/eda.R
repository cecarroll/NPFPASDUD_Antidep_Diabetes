source(here::here("R", "00_config.R"))
############################################################
# Project: NP FPA -> Rx (Descriptives / Graphs / DiD)
# Stata -> R translation using YOUR paths + variables
# Income var standardized to: med_inc_adj (median income)
############################################################

rm(list = ls())
options(stringsAsFactors = FALSE)

# ---- packages ----
# install.packages(c(
#   "tidyverse", "lubridate", "scales", "patchwork",
#   "fixest", "did",
#   "sandwich", "lmtest", "clubSandwich",
#   "broom", "modelsummary",
#   "zoo"
# ), dependencies = TRUE)

library(dplyr)
library(ggplot2)
library(scales)
library(readr)
library(zoo)
library(stringr)
library(fixest)
library(did)

# ---- paths (YOUR directory) ----
in_dir <- paste0(DIR_FILTERED, "/")

# ---- read ----
df <- read_csv(
  file.path(in_dir, "SDUD_biguanides_metformin.csv"),
  na = c("", "NA", "N/A", "NULL", "999"),
  show_col_types = FALSE,
  col_types = readr::cols(
    utilization_type                 = readr::col_integer(),
    state                            = readr::col_character(),
    ndc                              = readr::col_character(),
    labeler_code                     = readr::col_character(),
    product_code                     = readr::col_character(),
    package_size                     = readr::col_character(),
    year                             = readr::col_integer(),
    quarter                          = readr::col_integer(),
    suppression_used                 = readr::col_integer(),
    product_name                     = readr::col_character(),
    units_reimbursed                 = readr::col_double(),
    number_of_prescriptions          = readr::col_double(),
    statefip                         = readr::col_double(),
    medicaid_expansion               = readr::col_integer(),
    prop_bmi34                       = readr::col_double(),
    prop_bmi4                        = readr::col_double(),
    unemployment_rate                = readr::col_double(),
    population                       = readr::col_double(),
    afdc_tanf_benefit_for_4_person_family = readr::col_double(),
    fs_snap_benefit_for_4_person_family   = readr::col_double(),
    poverty_rate                     = readr::col_double(),
    governor_is_democrat_1_yes       = readr::col_character(),
    federal_minimum_wage             = readr::col_double(),
    state_minimum_wage               = readr::col_double(),
    medicaid_beneficiaries           = readr::col_double(),
    cpi                              = readr::col_double(),
    mean_age                         = readr::col_double(),
    share_female                     = readr::col_double(),
    share_black                      = readr::col_double(),
    share_metro_indet                = readr::col_double(),
    share_metro_non                  = readr::col_double(),
    share_metro_central              = readr::col_double(),
    share_metro_noncentral           = readr::col_double(),
    share_metro_mixed                = readr::col_double(),
    share_ba_or_more                 = readr::col_double(),
    avg_inc_adj                      = readr::col_double(),
    med_inc_adj                      = readr::col_double(),
    tot_inc_adj                      = readr::col_double(),
    yearquarter                      = readr::col_character(),
    treat                            = readr::col_integer(),
    event_time                       = readr::col_double(),
    total_amount_reimbursed_adj      = readr::col_double(),
    medicaid_amount_reimbursed_adj   = readr::col_double(),
    non_medicaid_amount_reimbursed_adj = readr::col_double()
  )
)

# ---- standardize median income name if needed ----
if ("median_inc_adj" %in% names(df) && !"med_inc_adj" %in% names(df)) {
  df <- df %>% mutate(med_inc_adj = median_inc_adj)
}
stopifnot("med_inc_adj" %in% names(df))

# ---- log (Stata: log using ...) ----
log_file <- file.path(in_dir, "Medicaid_FPA_R.log")
sink(log_file, split = TRUE)
cat("Log started:", as.character(Sys.time()), "\n\n")

############################################################
# Prepare the Panel for DiD (quarterly)
############################################################

df <- df %>%
  mutate(
    time_q = year * 4 + quarter - 1,
    yq = zoo::as.yearqtr(paste(year, quarter), format = "%Y %q")
  ) %>%
  dplyr::filter(!is.na(treat))

df <- df %>%
  group_by(state) %>%
  mutate(
    first_treat_time_q = ifelse(any(treat == 1, na.rm = TRUE), min(time_q[treat == 1], na.rm = TRUE), 0),
    first_treat_yq     = as.yearqtr(ifelse(any(treat == 1, na.rm = TRUE), min(yq[treat == 1], na.rm = TRUE), 0)),
    ever_treat         = ifelse(any(treat == 1, na.rm = TRUE), 1, 0)
  ) %>%
  ungroup()

df <- df %>%
  group_by(state) %>%
  mutate(
    time_q = as.integer(time_q),
    first_treat_time_q = as.integer(first_treat_time_q),
    first_treat_time_q = ifelse(is.na(first_treat_time_q), 0L, first_treat_time_q)
  ) %>%
  ungroup()

df1 <- df %>%
  group_by(state) %>%
  mutate(
    treat_now = as.integer(treat),
    treat     = as.integer(ever_treat),  # NOTE: this matches your existing code (ever-treated indicator)
    time_q    = as.integer(time_q)
  ) %>%
  ungroup()

# optional trimming you had
df2 <- filter(df1, time_q < 8083)

dfdid<-df2 %>% group_by(state,statefip,time_q)%>%
  select(-ndc, -labeler_code, -product_code,-product_name, -package_size, -suppression_used, -utilization_type) %>%
  mutate(number_of_prescriptions = sum(number_of_prescriptions, na.rm = TRUE),
         non_medicaid_amount_reimbursed_adj = sum(non_medicaid_amount_reimbursed_adj, na.rm = TRUE),
         total_amount_reimbursed_adj = sum(total_amount_reimbursed_adj, na.rm = TRUE),
         medicaid_amount_reimbursed_adj = sum(medicaid_amount_reimbursed_adj, na.rm = TRUE),
         units_reimbursed = sum(units_reimbursed, na.rm = TRUE)
        )%>% distinct() %>%
        ungroup()
        
     
############################################################
# Descriptives / Graphs (Stata section analogue)
############################################################

cat("=== Panel description (xtdes-ish) ===\n")
print(dfdid %>%
        summarise(
          n_states  = n_distinct(statefip),
          n_periods = n_distinct(time_q),
          t_min     = min(time_q, na.rm = TRUE),
          t_max     = max(time_q, na.rm = TRUE),
          n_obs     = n()
        ))
cat("\n")

cat("=== Duplicate check (statefip, time_q) ===\n")
dup_ct <- dfdid %>% count(statefip, time_q) %>% filter(n > 1)
print(dup_ct)
cat("Duplicate rows:", nrow(dup_ct), "\n\n")

cat("=== Summary stats (Stata: sum ...) ===\n")
print(summary(select(dfdid,
                     number_of_prescriptions, med_inc_adj, treat_now, ever_treat, medicaid_expansion
)))
cat("\n")

cat("=== Missingness (Stata: misstable summarize ...) ===\n")
print(dfdid %>%
        summarise(across(
          c(number_of_prescriptions, med_inc_adj, treat_now, ever_treat, medicaid_expansion, share_metro_non),
          ~sum(is.na(.x)),
          .names = "na_{.col}"
        )))
cat("\n")

cat("=== Years where med_inc_adj is missing (Stata: tab year if missing(x)) ===\n")
print(dfdid %>% filter(is.na(med_inc_adj)) %>% count(year, sort = TRUE))
cat("\n")

cat("=== Correlations (Stata: pwcorr ..., sig obs) ===\n")
corr_vars <- dfdid %>%
  #optimally id look at all the correlations but instead of taking time on that and cleaning, which i can do later, I am going to best subsets my controls.
  select(number_of_prescriptions, med_inc_adj, unemployment_rate, poverty_rate, medicaid_beneficiaries)
print(round(cor(corr_vars, use = "pairwise.complete.obs"), 3))
cat("\n")

# ---- binscatter analogue (binned means) ----
binscatter_plot <- function(data, y, x, by, bins = 25, title = NULL) {
  y <- rlang::ensym(y); x <- rlang::ensym(x); by <- rlang::ensym(by)
  data %>%
    filter(!is.na(!!y), !is.na(!!x), !is.na(!!by)) %>%
    mutate(x_bin = cut_number(!!x, n = bins)) %>%
    group_by(!!by, x_bin) %>%
    summarise(
      x_bar = mean(!!x, na.rm = TRUE),
      y_bar = mean(!!y, na.rm = TRUE),
      .groups = "drop"
    ) %>%
    ggplot(aes(x = x_bar, y = y_bar, color = factor(!!by))) +
    geom_point() +
    geom_line() +
    scale_y_continuous(labels = comma) +
    labs(
      title = title %||% paste0("Binscatter: ", rlang::as_string(y), " vs ", rlang::as_string(x)),
      color = rlang::as_string(by),
      x = rlang::as_string(x),
      y = rlang::as_string(y)
    )
}

p_bins <- binscatter_plot(
  dfdid,
  y  = number_of_prescriptions,
  x  = med_inc_adj,
  by = treat_now,
  bins = 25,
  title = "Binscatter: prescriptions vs median income (by current treatment)"
)
print(p_bins)

# ---- logs (Stata: gen ln_medicaid = ln(...)) ----
dfdid <- dfdid %>%
  mutate(ln_rx = ifelse(number_of_prescriptions > 0, log(number_of_prescriptions), NA_real_))

cat("\n=== ln_rx summary (detail-ish) ===\n")
print(summary(dfdid$ln_rx))
cat("\n")

cat("=== Correlations with ln_rx ===\n")
corr_vars_ln <- dfdid %>%
  select(ln_rx, med_inc_adj, unemployment_rate, poverty_rate, medicaid_beneficiaries)
print(round(cor(corr_vars_ln, use = "pairwise.complete.obs"), 3))
cat("\n")

# ---- xtline analogue: spaghetti by state ----
p_xtline <- ggplot(dfdid, aes(x = yq, y = number_of_prescriptions, group = statefip)) +
  geom_line(alpha = 0.25, na.rm = TRUE) +
  scale_y_continuous(labels = comma) +
  labs(title = "Prescriptions over time (by state)", x = "Quarter", y = "Prescription count")
print(p_xtline)

p_xtline0 <- ggplot(dfdid, aes(x = yq, y = number_of_prescriptions, group = statefip, color =factor(statefip))) +
  geom_line(alpha = 0.25, na.rm = TRUE) +
  scale_y_continuous(labels = comma, limits = c(0, NA)) +
  labs(title = "Prescriptions over time (y >= 0)", x = "Quarter", y = "Prescription count")
print(p_xtline0)

p_xtline_log <- ggplot(dfdid, aes(x = yq, y = ln_rx, group = statefip)) +
  geom_line(alpha = 0.25, na.rm = TRUE) +
  labs(title = "Log prescriptions over time (by state)", x = "Quarter", y = "log(prescriptions)")
print(p_xtline_log)

# ---- scatter + qfit + lowess analogue ----
p_trend <- ggplot(dfdid, aes(x = yq, y = number_of_prescriptions)) +
  geom_point(alpha = 0.15, size = 0.8, na.rm = TRUE) +
  geom_smooth(method = "lm", se = FALSE, na.rm = TRUE) +
  geom_smooth(method = "loess", se = FALSE, na.rm = TRUE) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Prescriptions over time (scatter + linear fit + loess)",
    x = "Quarter",
    y = "Prescription count"
  )
print(p_trend)

# ---- treated vs never (Stata: bys year: egen mean_treated/mean_never if fpa_ever==...) ----
df_means <- dfdid %>%
  group_by(yq, ever_treat) %>%
  summarise(mean_rx = mean(number_of_prescriptions, na.rm = TRUE), .groups = "drop")

p_treat_vs_never <- ggplot(df_means, aes(x = yq, y = mean_rx, color = factor(ever_treat))) +
  geom_line(linewidth = 1, na.rm = TRUE) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Mean prescriptions: ever-treated vs never-treated",
    color = "Ever treated",
    x = "Quarter",
    y = "Mean prescription count"
  )
print(p_treat_vs_never)

# ---- scatter prescriptions vs median income ----
p_scatter <- ggplot(dfdid, aes(x = med_inc_adj, y = number_of_prescriptions)) +
  geom_point(alpha = 0.25, size = 0.8, na.rm = TRUE) +
  scale_y_continuous(labels = comma) +
  labs(
    title = "Scatter: prescriptions vs median income (med_inc_adj)",
    x = "Median income (med_inc_adj)",
    y = "Prescription count"
  )
print(p_scatter)

print(p_bins)

############################################################
# Collapse to state-quarter (your dfdid1 step)
############################################################

dfdid1 <- dfdid %>%
  group_by(yq, statefip) %>%
  summarise(
    number_of_prescriptions = sum(number_of_prescriptions, na.rm = TRUE),
    treat_now = if_else(n_distinct(treat_now, na.rm = TRUE) <= 1, first(treat_now), NA_real_),
    treat     = if_else(n_distinct(treat, na.rm = TRUE) <= 1, first(treat), NA_real_),
    ever_treat = if_else(n_distinct(ever_treat, na.rm = TRUE) <= 1, first(ever_treat), NA_real_),
    prop_bmi4  = if_else(n_distinct(prop_bmi4, na.rm = TRUE) <= 1, first(prop_bmi4), NA_real_),
    poverty_rate = if_else(n_distinct(poverty_rate, na.rm = TRUE) <= 1, first(poverty_rate), NA_real_),
    share_black  = if_else(n_distinct(share_black, na.rm = TRUE) <= 1, first(share_black), NA_real_),
    share_ba_or_more = if_else(n_distinct(share_ba_or_more, na.rm = TRUE) <= 1, first(share_ba_or_more), NA_real_),
    share_metro_non  = if_else(n_distinct(share_metro_non, na.rm = TRUE) <= 1, first(share_metro_non), NA_real_),
    first_treat_time_q = if_else(n_distinct(first_treat_time_q, na.rm = TRUE) <= 1, first(first_treat_time_q), NA_real_),
    time_q = if_else(n_distinct(time_q, na.rm = TRUE) <= 1, first(time_q), NA_real_),
    medicaid_beneficiaries = if_else(n_distinct(medicaid_beneficiaries, na.rm = TRUE) <= 1, first(medicaid_beneficiaries), NA_real_),
    
    # swapped here too
    med_inc_adj = if_else(n_distinct(med_inc_adj, na.rm = TRUE) <= 1, first(med_inc_adj), NA_real_),
    
    mean_age = if_else(n_distinct(mean_age, na.rm = TRUE) <= 1, first(mean_age), NA_real_),
    share_female = if_else(n_distinct(share_female, na.rm = TRUE) <= 1, first(share_female), NA_real_),
    medicaid_expansion = if_else(n_distinct(medicaid_expansion, na.rm = TRUE) <= 1, first(medicaid_expansion), NA_real_),
    event_time = if_else(n_distinct(event_time, na.rm = TRUE) <= 1, first(event_time), NA_real_),
    .groups = "drop"
  )

############################################################
# TWFE (fixest) + DiD setup (your original structure)
############################################################

controls <- c(
  "prop_bmi4",
  "med_inc_adj",          # <- swapped from avg_inc_adj
  "share_black",
  "share_metro_non",
  "medicaid_beneficiaries",
  "mean_age",
  "share_female",
  "medicaid_expansion"
)

fml <- as.formula(paste0(
  "number_of_prescriptions ~ ever_treat*treat + ",
  paste(controls, collapse = " + "),
  " | statefip + time_q"
))

m <- feols(fml, data = dfdid, cluster = "statefip")
etable(m)

############################################################
# Diagnostics you had (now swapped to med_inc_adj)
############################################################

check <- dfdid1 %>%
  summarise(
    N_total = n(),
    N_complete = sum(complete.cases(across(all_of(c(
      "number_of_prescriptions","time_q","statefip","first_treat_time_q", controls
    ))))),
    treated_total = sum(first_treat_time_q > 0, na.rm = TRUE),
    treated_complete = sum(
      first_treat_time_q > 0 &
        complete.cases(across(all_of(c(
          "number_of_prescriptions","time_q","statefip","first_treat_time_q", controls
        )))),
      na.rm = TRUE
    ),
    never_total = sum(first_treat_time_q == 0, na.rm = TRUE),
    never_complete = sum(
      first_treat_time_q == 0 &
        complete.cases(across(all_of(c(
          "number_of_prescriptions","time_q","statefip","first_treat_time_q", controls
        )))),
      na.rm = TRUE
    )
  )
print(head(check))

bad_g <- dfdid1 %>%
  filter(first_treat_time_q > 0) %>%
  anti_join(distinct(dfdid1, time_q), by = c("first_treat_time_q" = "time_q")) %>%
  distinct(first_treat_time_q)
print(bad_g)

dfdid1 %>% count(statefip, time_q) %>% filter(n > 1)

dfdid1 %>%
  summarise(
    n_states = n_distinct(statefip),
    n_periods = n_distinct(time_q),
    n_never = n_distinct(statefip[first_treat_time_q == 0]),
    n_treated = n_distinct(statefip[first_treat_time_q > 0]),
    t_min = min(time_q, na.rm = TRUE),
    t_max = max(time_q, na.rm = TRUE)
  ) %>% print()

# NA / finite checks (swapped)
sum(is.na(dfdid1$prop_bmi4))
sum(is.na(dfdid1$med_inc_adj))
sum(is.na(dfdid1$share_black))
sum(is.na(dfdid1$share_metro_non))
sum(is.na(dfdid1$medicaid_beneficiaries))
sum(is.na(dfdid1$medicaid_expansion))
sum(is.na(dfdid1$mean_age))
sum(is.na(dfdid1$share_female))
sum(is.na(dfdid1$number_of_prescriptions))
sum(is.na(dfdid1$time_q))
sum(is.na(dfdid1$statefip))
sum(is.na(dfdid1$first_treat_time_q))

sum(!is.finite(dfdid1$prop_bmi4))
sum(!is.finite(dfdid1$med_inc_adj))
sum(!is.finite(dfdid1$share_black))
sum(!is.finite(dfdid1$share_metro_non))
sum(!is.finite(dfdid1$medicaid_beneficiaries))
sum(!is.finite(dfdid1$medicaid_expansion))
sum(!is.finite(dfdid1$mean_age))
sum(!is.finite(dfdid1$share_female))
sum(!is.finite(dfdid1$number_of_prescriptions))
sum(!is.finite(dfdid1$time_q))
sum(!is.finite(dfdid1$statefip))
sum(!is.finite(dfdid1$first_treat_time_q))

any(duplicated(dfdid1[c("statefip", "time_q")]))
dfdid1[
  duplicated(dfdid1[c("statefip","time_q")]) | duplicated(dfdid1[c("statefip","time_q")], fromLast = TRUE),
  c("statefip","time_q")
]

t0 <- min(dfdid1$time_q, na.rm = TRUE)

dfdid1 %>%
  distinct(statefip, first_treat_time_q) %>%
  filter(first_treat_time_q > 0) %>%
  mutate(n_pre_quarters = first_treat_time_q - t0) %>%
  count(n_pre_quarters) %>%
  arrange(n_pre_quarters) %>%
  print()

############################################################
# Callaway–Sant’Anna DiD
############################################################

# 1a (your blank xformla spot preserved; if you want controls, set xformla = reformulate(controls))
att <- att_gt(
  yname  = "number_of_prescriptions",
  tname  = "time_q",
  idname = "statefip",
  gname  = "first_treat_time_q",
  xformla = ,
  data   = dfdid1,
  panel  = TRUE,
  control_group = "nevertreated",
  allow_unbalanced_panel = TRUE,
  est_method = "reg"
)

es <- aggte(att, type = "dynamic")
ggdid(es)

############################################################
# Residualize outcome on controls + FE, then DiD on residuals
############################################################

res_mod <- feols(
  number_of_prescriptions ~ prop_bmi4 + med_inc_adj + share_black + share_metro_non +
    medicaid_beneficiaries + medicaid_expansion + mean_age + share_female
  | statefip + time_q,
  data = dfdid1
)

dfdid1$resid_y <- resid(res_mod)

att_r <- att_gt(
  yname="resid_y",
  tname="time_q",
  idname="statefip",
  gname="first_treat_time_q",
  xformla=~1,
  data=dfdid1,
  panel=TRUE,
  control_group="notyettreated",
  allow_unbalanced_panel=TRUE,
  est_method="reg"
)
es_r <- aggte(att_r, type = "dynamic")
ggdid(es_r)

############################################################
# Sun & Abraham (fixest) event-study style
############################################################

dfdid1 <- dfdid1 %>%
  mutate(
    event_time_b = case_when(
      is.na(event_time) ~ NA_integer_,
      event_time <= -8  ~ -8L,
      event_time >=  8  ~  8L,
      TRUE              ~ as.integer(event_time)
    ),
    ever_treat = as.integer(first_treat_time_q > 0),
    event_time = ifelse(ever_treat == 1, as.integer(time_q - first_treat_time_q), 9999L)
  )

m_es <- feols(
  number_of_prescriptions ~ i(event_time_b, ever_treat, ref = -1) +
    prop_bmi4 + med_inc_adj + share_black + share_metro_non +
    medicaid_beneficiaries + mean_age + share_female + medicaid_expansion
  | statefip + time_q,
  cluster = "statefip",
  data = dfdid1
)

iplot(m_es, ref.line = 0)

cat("\nLog ended:", as.character(Sys.time()), "\n")
sink()

