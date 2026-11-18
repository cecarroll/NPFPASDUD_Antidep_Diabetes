source(here::here("R", "00_config.R"))
library(readr)
library(dplyr)
library(Hmisc)
library(purrr)

in_dir  <- DIR_RAW_EXTERNAL
out_dir <- DIR_CONTROLS
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# ----------------------------
# helpers
# ----------------------------
wmedian <- function(x, w) {
  ok <- !is.na(x) & !is.na(w)
  if (!any(ok)) return(NA_real_)
  as.numeric(Hmisc::wtd.quantile(x[ok], weights = w[ok], probs = 0.5, normwt = FALSE))
}

# ---------- process one CSV into state-year NUMERATORS (+ median_income) ----------
process_one_file_to_nums <- function(path) {
  
  df <- read_csv(
    path,
    show_col_types = FALSE,
    progress = TRUE,
    col_types = cols_only(
      YEAR      = col_integer(),
      STATEFIP  = col_integer(),
      COUNTYFIP = col_integer(),
      METRO     = col_integer(),
      PERWT     = col_double(),
      SEX       = col_integer(),
      AGE       = col_integer(),
      RACE      = col_integer(),
      HISPAN    = col_integer(),
      HISPAND   = col_integer(),
      EDUCD     = col_integer(),
      INCTOT    = col_double()
    )
  ) %>%
    mutate(
      # missing codes -> NA (stay numeric)
      SEX     = na_if(SEX, 9),
      AGE     = na_if(AGE, 999),
      HISPAN  = na_if(HISPAN, 9),
      HISPAND = na_if(HISPAND, 900),
      EDUCD   = na_if(EDUCD, 999),
      INCTOT  = na_if(INCTOT, 9999999),
      
      # indicators (TRUE/FALSE)
      female   = (SEX == 2),
      
      hisp_any = (HISPAN %in% 1:4),
      hisp_mex = (HISPAN == 1),
      hisp_pr  = (HISPAN == 2),
      hisp_cub = (HISPAN == 3),
      hisp_oth = (HISPAN == 4),
      
      race_white = (RACE == 1),
      race_black = (RACE == 2),
      race_aian  = (RACE == 3),
      race_other = (RACE %in% c(4,5,6,7,8,9)),
      
      metro_indet      = (METRO == 0),
      metro_non        = (METRO == 1),
      metro_central    = (METRO == 2),
      metro_noncentral = (METRO == 3),
      metro_mixed      = (METRO == 4),
      
      edu_lt_hs   = (EDUCD <= 61),
      edu_hs_grad = (EDUCD %in% c(62,63,64)),
      edu_assoc   = (EDUCD %in% c(80,81,82,83)),
      edu_ba      = (EDUCD == 101),
      edu_grad    = (EDUCD %in% c(114,115,116)),
      hs_or_more  = (EDUCD >= 62),
      ba_or_more  = (EDUCD %in% c(101,110,111,112,113,114,115,116))
    )
  
  # NOTE:
  # - all num_* columns are "append-safe" (can be summed across chunks/files)
  # - median_income is NOT append-safe; we will only compute it on the FINAL per-year microdata
  #   (but since your IPUMS split should be non-overlapping, we can compute it here per file,
  #    then recompute it cleanly at the year level during finalize so it stays correct.)
  
  nums <- df %>%
    group_by(STATEFIP, YEAR) %>%
    summarise(
      pop = sum(PERWT, na.rm = TRUE),
      
      # numerators for means
      num_age    = sum(PERWT * AGE, na.rm = TRUE),
      num_income = sum(PERWT * INCTOT, na.rm = TRUE),
      
      # totals you said you want
      tot_income = sum(PERWT * INCTOT, na.rm = TRUE),
      
      # median (weighted) for this chunk
      median_income_chunk = wmedian(INCTOT, PERWT),
      
      # numerators for shares (indicator * weight)
      num_female = sum(PERWT * as.numeric(female), na.rm = TRUE),
      
      num_hisp_any = sum(PERWT * as.numeric(hisp_any), na.rm = TRUE),
      num_hisp_mex = sum(PERWT * as.numeric(hisp_mex), na.rm = TRUE),
      num_hisp_pr  = sum(PERWT * as.numeric(hisp_pr),  na.rm = TRUE),
      num_hisp_cub = sum(PERWT * as.numeric(hisp_cub), na.rm = TRUE),
      num_hisp_oth = sum(PERWT * as.numeric(hisp_oth), na.rm = TRUE),
      
      num_white = sum(PERWT * as.numeric(race_white), na.rm = TRUE),
      num_black = sum(PERWT * as.numeric(race_black), na.rm = TRUE),
      num_aian  = sum(PERWT * as.numeric(race_aian),  na.rm = TRUE),
      num_other = sum(PERWT * as.numeric(race_other), na.rm = TRUE),
      
      num_metro_indet      = sum(PERWT * as.numeric(metro_indet), na.rm = TRUE),
      num_metro_non        = sum(PERWT * as.numeric(metro_non), na.rm = TRUE),
      num_metro_central    = sum(PERWT * as.numeric(metro_central), na.rm = TRUE),
      num_metro_noncentral = sum(PERWT * as.numeric(metro_noncentral), na.rm = TRUE),
      num_metro_mixed      = sum(PERWT * as.numeric(metro_mixed), na.rm = TRUE),
      
      num_edu_lt_hs   = sum(PERWT * as.numeric(edu_lt_hs), na.rm = TRUE),
      num_edu_hs_grad = sum(PERWT * as.numeric(edu_hs_grad), na.rm = TRUE),
      num_edu_assoc   = sum(PERWT * as.numeric(edu_assoc), na.rm = TRUE),
      num_edu_ba      = sum(PERWT * as.numeric(edu_ba), na.rm = TRUE),
      num_edu_grad    = sum(PERWT * as.numeric(edu_grad), na.rm = TRUE),
      num_hs_or_more  = sum(PERWT * as.numeric(hs_or_more), na.rm = TRUE),
      num_ba_or_more  = sum(PERWT * as.numeric(ba_or_more), na.rm = TRUE),
      
      .groups = "drop"
    )
  
  rm(df); gc()
  nums
}

# ---------- turn numerators into final metrics ----------
# Strategy:
# - sum all numeric columns across chunks
# - for median, DO NOT sum; instead recompute a stable value:
#     if a state-year appears in multiple chunks, keep the chunk-median from the chunk with
#     the largest pop (best approximation without re-reading microdata)
#   If your inputs are non-overlapping by construction, there will only be one chunk anyway.
finalize_metrics <- function(nums_summed, med_chunks = NULL) {
  
  out <- nums_summed %>%
    mutate(
      mean_age    = num_age / pop,
      mean_income = num_income / pop,
      
      share_female   = num_female / pop,
      
      share_hisp_any = num_hisp_any / pop,
      share_hisp_mex = num_hisp_mex / pop,
      share_hisp_pr  = num_hisp_pr  / pop,
      share_hisp_cub = num_hisp_cub / pop,
      share_hisp_oth = num_hisp_oth / pop,
      
      share_white = num_white / pop,
      share_black = num_black / pop,
      share_aian  = num_aian  / pop,
      share_other = num_other / pop,
      
      share_metro_indet      = num_metro_indet / pop,
      share_metro_non        = num_metro_non / pop,
      share_metro_central    = num_metro_central / pop,
      share_metro_noncentral = num_metro_noncentral / pop,
      share_metro_mixed      = num_metro_mixed / pop,
      
      share_edu_lt_hs   = num_edu_lt_hs / pop,
      share_edu_hs_grad = num_edu_hs_grad / pop,
      share_edu_assoc   = num_edu_assoc / pop,
      share_edu_ba      = num_edu_ba / pop,
      share_edu_grad    = num_edu_grad / pop,
      share_hs_or_more  = num_hs_or_more / pop,
      share_ba_or_more  = num_ba_or_more / pop
    ) %>%
    select(STATEFIP, YEAR, pop, tot_income, starts_with("mean_"), starts_with("share_"))
  
  # attach median_income if provided
  if (!is.null(med_chunks)) {
    out <- out %>%
      left_join(med_chunks %>% select(STATEFIP, YEAR, median_income), by = c("STATEFIP", "YEAR"))
  }
  
  out
}

# ---------- main: loop files, append per-year numerators, and per-year median chunks ----------
files <- file.path(in_dir, sprintf("usa_%05d.csv", 6:9))
files <- files[file.exists(files)]

for (f in files) {
  message("Processing: ", f)
  nums_part <- process_one_file_to_nums(f)
  
  for (yr in sort(unique(nums_part$YEAR))) {
    
    # --- write/append numerators (append-safe numeric stuff) ---
    out_num_path <- file.path(out_dir, paste0("censusmetrics", yr, "_nums.csv"))
    chunk_nums <- nums_part %>%
      filter(YEAR == yr) %>%
      select(-median_income_chunk)  # do NOT sum medians
    
    if (!file.exists(out_num_path)) {
      write_csv(chunk_nums, out_num_path)
    } else {
      existing <- read_csv(out_num_path, show_col_types = FALSE)
      combined <- bind_rows(existing, chunk_nums) %>%
        group_by(STATEFIP, YEAR) %>%
        summarise(across(where(is.numeric), ~ sum(.x, na.rm = TRUE)), .groups = "drop")
      write_csv(combined, out_num_path)
      rm(existing, combined); gc()
    }
    
    # --- write/append median chunks separately (NOT summed) ---
    out_med_path <- file.path(out_dir, paste0("censusmetrics", yr, "_medchunks.csv"))
    chunk_med <- nums_part %>%
      filter(YEAR == yr) %>%
      transmute(
        STATEFIP,
        YEAR,
        pop_chunk = pop,
        median_income_chunk
      )
    
    if (!file.exists(out_med_path)) {
      write_csv(chunk_med, out_med_path)
    } else {
      existing_med <- read_csv(out_med_path, show_col_types = FALSE)
      combined_med <- bind_rows(existing_med, chunk_med)
      write_csv(combined_med, out_med_path)
      rm(existing_med, combined_med); gc()
    }
    
    rm(chunk_nums, chunk_med); gc()
  }
  
  rm(nums_part); gc()
}

# finalize: create censusmetricsYEAR.csv from each *_nums.csv + pick a stable median per state-year
num_files <- list.files(out_dir, pattern = "^censusmetrics\\d{4}_nums\\.csv$", full.names = TRUE)

for (p in num_files) {
  nums <- read_csv(p, show_col_types = FALSE)
  
  yr <- unique(nums$YEAR)
  if (length(yr) != 1) stop(paste0("Expected one YEAR per nums file, got: ", paste(yr, collapse = ",")))
  yr <- yr[1]
  
  # pick median per state-year: chunk with largest pop_chunk
  med_path <- file.path(out_dir, paste0("censusmetrics", yr, "_medchunks.csv"))
  med_chunks <- NULL
  if (file.exists(med_path)) {
    med_chunks <- read_csv(med_path, show_col_types = FALSE) %>%
      group_by(STATEFIP, YEAR) %>%
      arrange(desc(pop_chunk)) %>%
      summarise(median_income = first(median_income_chunk), .groups = "drop")
  }
  
  final <- finalize_metrics(nums_summed = nums, med_chunks = med_chunks)
  
  out_final_path <- file.path(out_dir, paste0("censusmetrics", yr, ".csv"))
  write_csv(final, out_final_path)
  
  rm(nums, med_chunks, final); gc()
}



#merge census metrics
end_merge_out_file <- file.path(out_dir, "censusmetrics_2006_2023.csv")

years <- 2006:2023
files <- file.path(out_dir, paste0("censusmetrics", years, ".csv"))

# keep only files that actually exist (in case a year is missing)
files <- files[file.exists(files)]

all_metrics <- map_dfr(files, ~ read_csv(.x, show_col_types = FALSE)) %>%
  arrange(STATEFIP, YEAR)

write_csv(all_metrics, end_merge_out_file)

