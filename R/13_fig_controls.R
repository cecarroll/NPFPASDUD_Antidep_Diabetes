source(here::here("R", "00_config.R"))
library(dplyr)
library(ggplot2)
library(scales)
library(readr)
library(stringr)
library(purrr)
library(readxl)
library(janitor)
library(zoo)

indir <- paste0(DIR_CONTROLS, "/")
filename<- "controls_final_quarterly.csv"
file <- file.path(paste0(indir, filename))

df <- read_csv(file) 

df <- df %>% clean_names()

df <- df %>%
  mutate(time_q = year*4 + quarter-1)%>%
  mutate(
    yq = zoo::as.yearqtr(paste(year, quarter), format = "%Y %q"))%>% 
  dplyr::filter(!is.na(treat))

df <- df %>%
  group_by(state) %>%
  mutate(first_treat_time_q = ifelse(any(treat == 1), min(time_q[treat == 1]), 0)) %>%
  mutate(first_treat_yq = as.yearqtr(ifelse(any(treat == 1), min(yq[treat == 1]), 0))) %>%
  mutate(ever_treat = ifelse(any(treat==1), 1, 0))%>%
  ungroup()
#tried to impute values: got crazy Se's
#df <- df%>%mutate(number_of_prescriptions = ifelse(suppression_used == 1, 4, number_of_prescriptions))
#genning first_treat_year for staggering did

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



ggplot(data = df, aes(x = yq, y = medicaid_beneficiaries, color = factor(state))) +
  geom_line(linewidth = 1,na.rm = TRUE) +
  geom_point(na.rm = TRUE) +
  scale_y_continuous(labels = comma) +
  labs(color = "state", x = "Quarter", y = "Medicaid Benificiaries")

