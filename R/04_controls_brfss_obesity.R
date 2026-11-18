source(here::here("R", "00_config.R"))
# ============================================================
# LLCP ASCII extractor: state, bmi4cat, finalwt (2006-2023)
# ============================================================

# If you don't have data.table yet:
# install.packages("data.table")

library(data.table)

library(dplyr)

root    <- DIR_RAW_EXTERNAL
out_dir <- file.path(root, "llcp_extract_out")
dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

chunk_n <- 500000L  # lines per chunk

# ---- positions (1-based) ----
pos_tbl <- data.frame(
  year = 2006:2023,
  bmi_start = c(1224,1224,1263,1457,1487,1537,1648,2196,2251,1992,1996,2049,1999,2002,2001,2004,2002,2086),
  bmi_width = rep(1L, 18),
  state_start = rep(1L, 18),
  state_width = rep(2L, 18),
  wt_start = c(845,845,799,993,1030,1475,1449,1953,2007,1746,1747,1798,1750,1751,1751,1751,1751,1749),
  wt_width = rep(10L, 18),
  stringsAsFactors = FALSE
)

# ---- find the .asc for a given year ----
find_asc <- function(root, year) {
  yr <- as.character(year)
  folder <- file.path(root, paste0("LLCP", yr, "ASC"))
  if (dir.exists(folder)) {
    hits <- list.files(folder, pattern = "\\.asc$", full.names = TRUE, ignore.case = TRUE)
    if (length(hits) > 0) return(hits[1])
  }
  # fallback: search anywhere for LLCPYYYY*.asc
  hits <- list.files(root, pattern = paste0("LLCP", yr, ".*\\.asc$"),
                     full.names = TRUE, recursive = TRUE, ignore.case = TRUE)
  if (length(hits) > 0) return(hits[1])
  NA_character_
}

# ---- fixed-width extractor ----
get_field <- function(lines, start, width) {
  end <- start + width - 1L
  x <- substr(lines, start, end)
  x <- trimws(x)
  x[x == ""] <- NA_character_
  x
}

# ---- process one year, write CSV ----
process_year <- function(year, file_path, row) {
  out_file <- file.path(out_dir, sprintf("llcp_%d_state_bmi_finalwt.csv", year))
  if (file.exists(out_file)) file.remove(out_file)
  
  con <- file(file_path, open = "rb")
  on.exit(close(con), add = TRUE)
  
  first <- TRUE
  
  repeat {
    lines <- readLines(con, n = chunk_n, warn = FALSE, encoding = "bytes", skipNul = TRUE)
    if (length(lines) == 0) break
    
    dt <- data.table(
      year    = year,
      state   = get_field(lines, row$state_start, row$state_width),
      bmi4cat = suppressWarnings(as.integer(get_field(lines, row$bmi_start, row$bmi_width))),
      finalwt = suppressWarnings(as.numeric(get_field(lines, row$wt_start, row$wt_width)))
    )
    
    if (first) {
      fwrite(dt, out_file)
      first <- FALSE
    } else {
      fwrite(dt, out_file, append = TRUE, col.names = FALSE)
    }
    
    rm(dt, lines)
    gc()
  }
  
  message("Wrote: ", out_file)
  out_file
}

# ---- run all years ----
out_files <- character(0)

for (i in 1:nrow(pos_tbl)) {
  yr <- pos_tbl$year[i]
  f  <- find_asc(root, yr)
  
  if (is.na(f) || !file.exists(f)) {
    message("Year ", yr, ": no .asc found, skipping")
    next
  }
  
  message("Year ", yr, ": ", f)
  out_files <- c(out_files, process_year(yr, f, pos_tbl[i, ]))
}

message("DONE. Output folder: ", out_dir)

 
 all_dt <- rbindlist(lapply(out_files, fread), use.names = TRUE, fill = TRUE)
 all_dt <- rename(all_dt, statefip = state)
 fwrite(all_dt, file.path(out_dir, "llcp_2011_2023_state_bmi_finalwt_all.csv"))

 
 
 in_file <- file.path(DIR_RAW_EXTERNAL, "llcp_extract_out", "llcp_2011_2023_state_bmi_finalwt_all.csv")
 
 # Read bmi4cat + finalwt as character so we can detect 9/99/999... reliably
 dt <- fread(
   in_file,
   colClasses = list(character = c("statefip", "bmi4cat", "finalwt"))
 )
 
 is_all9 <- function(x) grepl("^9+$", x)
 
 # Drop rows where bmi4cat or finalwt are "all 9s" missing codes (or blank)
 dt <- dt[!is.na(bmi4cat) & bmi4cat != "" & !is_all9(bmi4cat) &
            !is.na(finalwt) & finalwt != "" & !is_all9(finalwt)]
 
 # Convert to numeric after cleaning
 dt[, bmi4cat := as.integer(bmi4cat)]
 dt[, finalwt := as.numeric(finalwt)]
 
 # Keep state as 2-digit FIPS
 dt[, statefip := sprintf("%02d", as.integer(statefip))]
 
 # Weighted proportion of bmi4cat in {3,4} by year-state
 out <- dt[!is.na(bmi4cat) & !is.na(finalwt),
           .(
             wt_total   = sum(finalwt),
             wt_bmi34   = sum(finalwt[bmi4cat %in% c(3L, 4L)]),
             prop_bmi34 = sum(finalwt[bmi4cat %in% c(3L, 4L)]) / sum(finalwt),
             wt_bmi4   = sum(finalwt[bmi4cat %in% c(4L)]),
             prop_bmi4 = sum(finalwt[bmi4cat %in% c(4L)]) / sum(finalwt)
           ),
           by = .(year, statefip)]
 
 setorder(out, year, statefip)
 
 out_file <- file.path(DIR_CONTROLS, "llcp_2011_2023_prop_bmi34_by_year_state.csv")
 fwrite(out, out_file)
 out[1:20]
 