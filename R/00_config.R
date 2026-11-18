# =============================================================================
# 00_config.R -- project paths and packages
#
# Every script in R/ sources this file first. All paths are relative to the
# repository root (found with here::here()), so the pipeline runs on any
# machine once the raw data are placed in data/raw/ (see README).
# =============================================================================

suppressPackageStartupMessages({
  library(here)
})

# ---- Directory layout --------------------------------------------------------
DIR_RAW_SDUD     <- here("data", "raw", "sdud")       # CMS StateDrugUtilizationData<YYYY>.csv
DIR_RAW_EXTERNAL <- here("data", "raw", "external")   # IPUMS ACS extracts, BLS LAUS, BRFSS LLCP files
DIR_CONTROLS     <- here("data", "controls")          # built state-quarter controls + FPA law coding
DIR_SDUD_CLEAN   <- here("data", "intermediate", "sdud_clean")
DIR_SDUD_MERGED  <- here("data", "intermediate", "sdud_with_controls")
DIR_FILTERED     <- here("data", "intermediate", "drug_classes")
DIR_PANEL        <- here("data", "analysis")          # state-quarter estimation panels
DIR_FIGS         <- here("output", "figures")
DIR_TABLES       <- here("output", "tables")
DIR_LOGS         <- here("output", "logs")

for (d in c(DIR_CONTROLS, DIR_SDUD_CLEAN, DIR_SDUD_MERGED, DIR_FILTERED,
            DIR_PANEL, DIR_FIGS, DIR_TABLES, DIR_LOGS)) {
  dir.create(d, recursive = TRUE, showWarnings = FALSE)
}

# ---- Sample window used in the manuscript ------------------------------------
YEARS_SDUD <- 2009:2019

# ---- Package check -------------------------------------------------------------
# Install once with: source(here::here("R", "install_packages.R"))
required_packages <- c(
  "dplyr", "tidyr", "readr", "readxl", "stringr", "purrr", "janitor",
  "data.table", "haven", "zoo", "ggplot2", "scales",
  "fixest", "did", "didimputation"
)
missing <- required_packages[!vapply(required_packages, requireNamespace,
                                     logical(1), quietly = TRUE)]
if (length(missing)) {
  stop("Missing packages: ", paste(missing, collapse = ", "),
       "\nRun source(here::here('R', 'install_packages.R')) first.")
}
