# One-time setup: install every package the pipeline uses.
pkgs <- c(
  "here", "dplyr", "tidyr", "readr", "readxl", "stringr", "purrr", "janitor",
  "data.table", "haven", "zoo", "ggplot2", "scales",
  "fixest", "did", "didimputation",
  # maps (12_fig_fpa_map.R)
  "usmap", "sf"
)
to_install <- setdiff(pkgs, rownames(installed.packages()))
if (length(to_install)) install.packages(to_install)

# Optional: wild cluster bootstrap for 14_robustness.R (not on CRAN)
# install.packages("fwildclusterboot", repos = c("https://s3alfisc.r-universe.dev", "https://cloud.r-project.org"))
