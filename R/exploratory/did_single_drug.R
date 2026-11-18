source(here::here("R", "00_config.R"))
# install.packages(c(
#   "tidyverse", "lubridate", "scales", "patchwork",
#   "fixest", "did",
#   "sandwich", "lmtest", "clubSandwich",
#   "broom", "modelsummary"
# ))


library(dplyr)
library(ggplot2)
library(scales)
library(readr)
library(zoo)
library(stringr)


in_dir <- paste0(DIR_FILTERED, "/")
out_dir <- paste0(DIR_FIGS, "/")
df <- read_csv(
  file.path(in_dir, "SDUD_biguanides_metformin.csv"),
  na = c("", "NA", "N/A"),
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
    treat                           = readr::col_integer(),
    event_time                       = readr::col_double(),
    total_amount_reimbursed_adj      = readr::col_double(),
    medicaid_amount_reimbursed_adj   = readr::col_double(),
    non_medicaid_amount_reimbursed_adj = readr::col_double()
  ))
#controls <- ~ prop_bmi4 + avg_inc_adj + share_black + share_ba_or_more + share_metro_non
#################################################################################################
#Prepare the Panel for DiD
#This code sums by state-quarter whatever is in the files in the number_of_prescriptions column.
#This code also constructs columns on a quarter, state, and state_quarter level such as time_q, ever_treat, first_treat_time_q, and treat_now
############################################################################

#constructing the time var yq by combining year and quarter
#getting rid of na's because in the full join of controls, it collected junk
df <- df %>%
  mutate(time_q = year*4 + quarter-1)%>%
  mutate(
    yq = zoo::as.yearqtr(paste(year, quarter), format = "%Y %q"))%>% 
    dplyr::filter(!is.na(treat))


if(FALSE){
tab_bad <- df %>%   # use dfdid if it's still at the raw (multiple rows per state-quarter)
  group_by(statefip, yq, state) %>%
  summarise(
    state = state,
    time_q =time_q,
    n = n(),
    n_na = sum(is.na(number_of_prescriptions)),
    n_nonfinite = sum(!is.na(number_of_prescriptions) & !is.finite(number_of_prescriptions)),
    n_ok = sum(!is.na(number_of_prescriptions) & is.finite(number_of_prescriptions)),
    .groups = "drop"
  ) %>% distinct()

ggplot(tab_bad, aes(x = yq, y = n_na, color = factor(statefip))) +
  geom_line(linewidth = 1,na.rm = TRUE) +
  geom_point(na.rm = TRUE) +
  scale_y_continuous(labels = comma) +
  labs(color = "state", x = "yq", y = "NaCount")
}
#tried to impute values: got crazy Se's
#df <- df%>%mutate(number_of_prescriptions = ifelse(suppression_used == 1, 4, number_of_prescriptions))
#genning first_treat_year for staggering did
df <- df %>%
  group_by(state) %>%
  mutate(first_treat_time_q = ifelse(any(treat == 1), min(time_q[treat == 1]), 0)) %>%
  mutate(first_treat_yq = as.yearqtr(ifelse(any(treat == 1), min(yq[treat == 1]), 0))) %>%
  mutate(ever_treat = ifelse(any(treat==1), 1, 0))%>%
  ungroup()
df <- df %>%group_by(state) %>%
  mutate(
    time_q = as.integer(time_q),
    first_treat_time_q = as.integer(first_treat_time_q),
    first_treat_time_q = ifelse(is.na(first_treat_time_q), 0L, first_treat_time_q))%>%
  ungroup()
#checking
dfdid <- df %>%group_by(state) %>%
  mutate(
    treat_now = as.integer(treat),
    treat=as.integer(ever_treat),
    time_q = as.integer(time_q)
    
    ) %>% #filter(time_q >= 2082)%>%
#%>% filter(year != 2010)%>%
  #filter(time_q == 8082)
ungroup()


  #checking2
dfdid <- filter(dfdid, time_q<8083)


#######################################################################################################
##########################################################
#This Code groups by different things for state 
#grouping by the time and treatment var (but not state)
df_year <- df %>%
  group_by(yq, treat) %>%
  summarise(rx = sum(number_of_prescriptions, na.rm = TRUE), .groups = "drop")

#plot the treated and untreated quarter-year segments
ggplot(df_year, aes(x = yq, y = rx, color = factor(treat))) +
  geom_line(linewidth = 1,na.rm = TRUE) +
  geom_point(na.rm = TRUE) +
  scale_y_continuous(labels = comma) +
  labs(color = "Treated", x = "Year", y = "Prescription count")

#plot the states ever treated 

df_state <- df %>%
  group_by(yq, ever_treat) %>%
  summarise(rx = sum(number_of_prescriptions, na.rm = TRUE), .groups = "drop")
ggplot(df_state, aes(x = yq, y = rx, color = factor(ever_treat))) +
  geom_line(linewidth = 1,na.rm = TRUE) +
  geom_point(na.rm = TRUE) +
  scale_y_continuous(labels = comma) +
  labs(color = "Treated", x = "Year", y = "Prescription count")


#group by the variables we need
#state, yq, and sum #scrips 
dfdid1 <- dfdid %>%
  group_by(yq, statefip) %>%
  summarise(
    number_of_prescriptions = sum(number_of_prescriptions, na.rm = TRUE),
    treat_now = dplyr::if_else(dplyr::n_distinct(treat_now, na.rm=TRUE) <= 1,
                           dplyr::first(treat_now), NA_real_),
    treat = dplyr::if_else(dplyr::n_distinct(treat, na.rm=TRUE) <= 1,
                           dplyr::first(treat), NA_real_),
    ever_treat = dplyr::if_else(dplyr::n_distinct(ever_treat, na.rm=TRUE) <= 1,
                            dplyr::first(ever_treat), NA_real_),
    prop_bmi4 = dplyr::if_else(dplyr::n_distinct(prop_bmi4, na.rm=TRUE) <= 1,
                              dplyr::first(prop_bmi4), NA_real_),
    poverty_rate = dplyr::if_else(dplyr::n_distinct(poverty_rate, na.rm=TRUE) <= 1,
                              dplyr::first(poverty_rate), NA_real_),
    share_black = dplyr::if_else(dplyr::n_distinct(share_black, na.rm=TRUE) <= 1,
                              dplyr::first(share_black), NA_real_),
    share_ba_or_more = dplyr::if_else(dplyr::n_distinct(share_ba_or_more, na.rm=TRUE) <= 1,
                              dplyr::first(share_ba_or_more), NA_real_),
    share_metro_non = dplyr::if_else(dplyr::n_distinct(share_metro_non, na.rm=TRUE) <= 1,
                              dplyr::first(share_metro_non), NA_real_),
    first_treat_time_q = dplyr::if_else(dplyr::n_distinct(first_treat_time_q, na.rm=TRUE) <= 1,
                                         dplyr::first(first_treat_time_q), NA_real_),
    time_q = dplyr::if_else(dplyr::n_distinct(time_q, na.rm=TRUE) <= 1,
                                    dplyr::first(time_q), NA_real_),
    medicaid_beneficiaries=dplyr::if_else(dplyr::n_distinct(medicaid_beneficiaries, na.rm=TRUE) <= 1,
                                          dplyr::first(medicaid_beneficiaries), NA_real_),
    avg_inc_adj = dplyr::if_else(dplyr::n_distinct(avg_inc_adj, na.rm=TRUE) <= 1,
                                 dplyr::first(avg_inc_adj), NA_real_),
    mean_age = dplyr::if_else(dplyr::n_distinct(mean_age, na.rm=TRUE) <= 1,
                                 dplyr::first(mean_age), NA_real_),
    share_female = dplyr::if_else(dplyr::n_distinct(share_female, na.rm=TRUE) <= 1,
                                 dplyr::first(share_female), NA_real_),
    medicaid_expansion = dplyr::if_else(dplyr::n_distinct(medicaid_expansion, na.rm=TRUE) <= 1,
                                        dplyr::first(medicaid_expansion), NA_real_),
    unemployment_rate = dplyr::if_else(dplyr::n_distinct(unemployment_rate, na.rm=TRUE) <= 1,
                                      dplyr::first(unemployment_rate), NA_real_),
    event_time = dplyr::if_else(dplyr::n_distinct(event_time, na.rm=TRUE) <= 1,
                                dplyr::first(event_time), NA_real_),
    .groups = "drop"
  )
if(FALSE){
## TEMP :: Join the NACounts to my NA'S
dfdid1 <- dfdid1 %>%
  left_join(tab_bad, by = c("statefip", "yq"))

}
library(fixest)
library(did)

#w medicaid bene
controls <- c("prop_bmi4", "avg_inc_adj", "share_black", "share_metro_non", "medicaid_beneficiaries", "mean_age", "share_female", "medicaid_expansion", "unemployment_rate")
#wo medicaid bene
#controls <- c("prop_bmi4", "avg_inc_adj", "share_black", "share_metro_central", "mean_age", "share_female", "medicaid_expansion")

fml <- as.formula(paste0(
  "number_of_prescriptions ~ ever_treat*treat_now + ", paste(controls, collapse = " + "),
  " | statefip + time_q"
))

#fml <- as.formula("number_of_prescriptions ~ ever_treat*treat | statefip + time_q")

#run feols
m <- feols(fml, data = dfdid1, cluster = "statefip")
#show_table
etable(m)

#reassign controls

xform <- reformulate(controls)

#run the DiD
library(did)
#check key Ns 
check <- dfdid1 %>%
  summarise(
    N_total = n(),
    N_complete = sum(complete.cases(across(all_of(c("number_of_prescriptions","time_q","statefip","first_treat_time_q", controls))))),
    treated_total = sum(first_treat_time_q > 0, na.rm=TRUE),
    treated_complete = sum(first_treat_time_q > 0 & complete.cases(across(all_of(c("number_of_prescriptions","time_q","statefip","first_treat_time_q", controls)))), na.rm=TRUE),
    never_total = sum(first_treat_time_q == 0, na.rm=TRUE),
    never_complete = sum(first_treat_time_q == 0 & complete.cases(across(all_of(c("number_of_prescriptions","time_q","statefip","first_treat_time_q", controls)))), na.rm=TRUE)
  )
head(check)

#check that all treatment periods are in the time var
bad_g <- dfdid1 %>%
  filter(first_treat_time_q > 0) %>%
  anti_join(distinct(dfdid1, time_q), by = c("first_treat_time_q" = "time_q")) %>%
  distinct(first_treat_time_q)

bad_g
#make sure of no NA?
dfdid1 %>% count(statefip, time_q) %>% filter(n > 1)
library(dplyr)

dfdid1 %>%
  summarise(
    n_states = n_distinct(statefip),
    n_periods = n_distinct(time_q),
    n_never = n_distinct(statefip[first_treat_time_q == 0]),
    n_treated = n_distinct(statefip[first_treat_time_q > 0]),
    t_min = min(time_q),
    t_max = max(time_q)
  )
cohort_pre <- dfdid1%>%
  distinct(statefip, first_treat_time_q) %>%
  filter(first_treat_time_q > 0) %>%
  mutate(has_pre = first_treat_time_q > min(dfdid1$time_q))

table(cohort_pre$has_pre)


# 

sum(is.na(dfdid1$prop_bmi4))
sum(is.na(dfdid1$avg_inc_adj))
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
sum(!is.finite(dfdid1$avg_inc_adj))
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

table(is.na(dfdid1$first_treat_time_q))
table(dfdid1$first_treat_time_q == 0, useNA = "ifany")

any(duplicated(dfdid1[c("statefip", "time_q")]))
# If TRUE, see them:
dfdid1[duplicated(dfdid1[c("statefip","time_q")]) | duplicated(dfdid1[c("statefip","time_q")], fromLast=TRUE),
       c("statefip","time_q")]

t0 <- min(dfdid1$time_q)


# how many pre-n quarters do we have ? if too few, use the did labelled 1b 
dfdid1 %>%
  distinct(statefip, first_treat_time_q) %>%
  filter(first_treat_time_q > 0) %>%
  mutate(n_pre_quarters = first_treat_time_q - t0) %>%
  count(n_pre_quarters) %>%
  arrange(n_pre_quarters)

#
#



# A) Does treat vary within state?
dfdid1 %>%
  group_by(statefip) %>%
  summarise(k = n_distinct(treat), .groups="drop") %>%
  count(k)

# B) Does treat vary across states within each time?
dfdid1 %>%
  group_by(time_q) %>%
  summarise(k = n_distinct(treat), .groups="drop") %>%
  count(k)

# C) Is treat identical to some other regressor?
with(dfdid1, table(treat, tab_bad, useNA="ifany"))
with(dfdid1, table(treat, medicaid_expansion, useNA="ifany"))

# 1 a Run the DiD : DiDn't
att <- att_gt(
  yname  = "number_of_prescriptions",
  tname  = "time_q",
  idname = "statefip",
  gname  = "first_treat_time_q",
  xformla =# ~prop_bmi4 + avg_inc_adj + share_black + share_metro_non +
  #  medicaid_beneficiaries+  medicaid_expansion + mean_age + share_female 
  ,
  data   = dfdid1,
  panel  = TRUE,
  control_group = "nevertreated",
  allow_unbalanced_panel = TRUE,
  est_method = "reg"
)
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

ggsave(paste0(out_dir, "DIDNoControls.png"), plot = p, width = 8, height = 5) 
# 1 b \\library(fixest)


# residualize outcome on controls + FE
res_mod <- feols(
  number_of_prescriptions ~ prop_bmi4 + avg_inc_adj + share_black + share_metro_non +
    medicaid_beneficiaries + medicaid_expansion + mean_age + share_female + unemployment_rate
  | statefip + time_q,
  data = dfdid1
)

dfdid1$resid_y <- resid(res_mod)

# run did on residualized outcome
att <- att_gt(
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
es <- aggte(att, type = "dynamic")
p <- ggdid(es)
#plot the did 
p +
  labs(
    title = "Event study: NP FPA → Metformin prescriptions",
    subtitle = "Callaway–Sant’Anna DiD (notyettreated controls)",
    x = "Event time (quarters relative to adoption)",
    y = "ATT on prescriptions (residualized)"
  )
ggsave(paste0(out_dir, "DIDResidualizedControls.png"), plot = p, width = 8, height = 5) 


#sun-abraham did which makes small cohorts such as ours less of a problem: DiDn't work even more
library(fixest)

#controls <- ~ prop_bmi4 + avg_inc_adj + share_black + share_metro_central + medicaid_beneficiaries + mean_age + share_female + medicaid_expansion
library(dplyr)
#temporary until i do this to the original npfpa
dfdid1 <- dfdid1 %>%
  mutate(
    
    event_time_b = case_when(
      is.na(event_time) ~ NA_integer_,
      event_time <= -8  ~ -8L,
      event_time >=  8  ~  8L,
      TRUE              ~ as.integer(event_time)
    ),
    ever_treat = as.integer(first_treat_time_q > 0),
    # event_time only matters when ever_treat==1
    event_time = ifelse(ever_treat == 1, as.integer(time_q - first_treat_time_q), 9999L)
  )

library(fixest)



m_es <- feols(
  number_of_prescriptions ~ i(event_time_b, ever_treat, ref = -1) + prop_bmi4 + avg_inc_adj + share_black + share_metro_non + medicaid_beneficiaries + mean_age + share_female + medicaid_expansion+n_na
  | statefip + time_q,
  cluster = "statefip",
  data = dfdid1
)

iplot(m_es, ref.line = 0)



#Grouping by drug category within state,quarter b/c metformin was on a downtrend a lot of the time anyway



