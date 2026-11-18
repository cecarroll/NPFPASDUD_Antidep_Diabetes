# =============================================================================
# 14_robustness.R -- full specification set for Carroll & Mitchell (2026)
#
# Reproduces, in R, every row of manuscript Table 2 plus the checks the
# draft lists as pending ("final specification set"):
#
#   Table 2 rows
#     1. BJS imputation estimator, primary              (state-block bootstrap)
#     2. Two-way fixed effects                          (static TWFE)
#     3. Gardner two-stage                              (did2s logic)
#     4. BJS, log outcome
#     5. BJS, excluding Hawaii                          (earliest adopter, 2 pre-quarters)
#     6. BJS, suppression-imputed outcome
#     7. BJS, first-full-quarter treatment timing
#     8. BJS, 2011 Q1 onward, cohorts treated after 2010 (MCO reporting ramp)
#     9. Joint pre-trend test, 8 leads                  (Wald, untreated obs, state-clustered)
#   Pending in the draft
#    10. Callaway-Sant'Anna group-time ATT              (not-yet-treated controls)
#    11. Wild cluster bootstrap p-value (TWFE)          (39 clusters)
#    12. Cohort-specific ATTs                           (Appendix Fig. A2)
#    13. Event-study coefficients                       (Figs. 1-2)
#
# INPUT: one state-quarter panel per drug class (CSV), with columns
#   state         two-letter postal code
#   time_q        integer quarter index: year*4 + (quarter-1)
#   year, quarter
#   y             scripts per 1,000 under-65 Medicaid enrollees (main outcome)
#   y_suppimp     same, with suppressed SDUD cells imputed      (row 6)
#   g             first treated quarter (time_q of the quarter containing the
#                 FPA effective date); 0 for never/post-2019 adopters
#   g_fullq       first FULL quarter under FPA; 0 if never      (row 7)
# Pre-2009 FPA states must already be dropped (no always-treated units).
#
# Set PANEL_FILES below, or call run_all_specs() on any data frame with the
# schema above. tests/test_robustness_synthetic.R checks every estimator
# against a simulated panel with a known effect.
# =============================================================================

if (!exists("DIR_TABLES")) source(here::here("R", "00_config.R"))

suppressPackageStartupMessages({
  library(dplyr)
  library(fixest)
})

# ---- Settings ----------------------------------------------------------------
B_MAIN      <- 999   # bootstrap reps, primary rows (matches manuscript)
B_ROBUST    <- 499   # bootstrap reps, robustness rows
B_WILD      <- 9999  # wild cluster bootstrap reps
N_LEADS     <- 8     # leads in the joint pre-trend test
EVENT_WIN   <- -8:12 # event-study window (quarters relative to adoption)
SEED        <- 20261118

PANEL_FILES <- c(
  diabetes        = file.path(DIR_PANEL, "panel_diabetes.csv"),
  antidepressants = file.path(DIR_PANEL, "panel_antidepressants.csv")
)

# =============================================================================
# Estimators
# =============================================================================

# BJS imputation estimator (Borusyak, Jaravel & Spiess 2024).
# Fit unit + time FE on untreated observations only (never-treated and
# not-yet-treated), impute Y(0) for treated observations, average the gaps.
# Returns the ATT and, optionally, the per-observation effects.
bjs_att <- function(d, yvar = "y", gvar = "g", keep_tau = FALSE) {
  d <- d |>
    mutate(.y = .data[[yvar]], .g = .data[[gvar]],
           .D = as.integer(.g > 0 & time_q >= .g))
  untreated <- d[d$.D == 0, ]
  fit <- feols(.y ~ 1 | state + time_q, data = untreated, warn = FALSE, notes = FALSE)
  treated <- d[d$.D == 1, ]
  treated$.y0  <- predict(fit, newdata = treated)
  treated$.tau <- treated$.y - treated$.y0
  att <- mean(treated$.tau, na.rm = TRUE)
  if (keep_tau) list(att = att, tau = treated) else att
}

# State-block bootstrap: resample states with replacement (each draw gets a
# fresh id so duplicated states are distinct units), re-estimate.
block_bootstrap_se <- function(d, est_fun, B, seed = SEED) {
  set.seed(seed)
  states <- unique(d$state)
  by_state <- split(d, d$state)
  draws <- vapply(seq_len(B), function(b) {
    pick <- sample(states, length(states), replace = TRUE)
    db <- bind_rows(lapply(seq_along(pick), function(k) {
      x <- by_state[[pick[k]]]; x$state <- paste0(pick[k], "_", k); x
    }))
    out <- tryCatch(est_fun(db), error = function(e) NA_real_)
    out
  }, numeric(1))
  sd(draws, na.rm = TRUE)
}

# Static TWFE: y ~ D | state + quarter, state-clustered.
twfe <- function(d, yvar = "y", gvar = "g") {
  d$.D <- as.integer(d[[gvar]] > 0 & d$time_q >= d[[gvar]])
  feols(as.formula(paste(yvar, "~ .D | state + time_q")), data = d,
        cluster = ~state, notes = FALSE)
}

# Gardner (2022) two-stage DiD: stage 1 = BJS first stage; stage 2 regresses
# the residualized outcome on D. Point estimate equals BJS's ATT under equal
# weights; SE from the state-block bootstrap (both stages re-estimated).
gardner_att <- function(d, yvar = "y", gvar = "g") {
  d <- d |> mutate(.y = .data[[yvar]], .D = as.integer(.data[[gvar]] > 0 & time_q >= .data[[gvar]]))
  fs <- feols(.y ~ 1 | state + time_q, data = d[d$.D == 0, ], warn = FALSE, notes = FALSE)
  d$.ytil <- d$.y - predict(fs, newdata = d)
  unname(coef(feols(.ytil ~ .D - 1, data = d, notes = FALSE))[".D"])
}

# Joint pre-trend test (BJS 2024, Test 1): on untreated observations only,
# regress y on unit + time FE plus lead dummies for the N_LEADS quarters before
# adoption; Wald test that all leads are zero, state-clustered.
pretrend_test <- function(d, yvar = "y", gvar = "g", n_leads = N_LEADS) {
  d <- d |> mutate(.D = as.integer(.data[[gvar]] > 0 & time_q >= .data[[gvar]]),
                   .rel = ifelse(.data[[gvar]] > 0, time_q - .data[[gvar]], NA_integer_))
  u <- d[d$.D == 0, ]
  lead_names <- character(0)
  for (k in seq_len(n_leads)) {
    nm <- paste0("lead", k)
    u[[nm]] <- as.integer(!is.na(u$.rel) & u$.rel == -k)
    lead_names <- c(lead_names, nm)
  }
  fml <- as.formula(paste(yvar, "~", paste(lead_names, collapse = " + "), "| state + time_q"))
  m <- feols(fml, data = u, cluster = ~state, notes = FALSE)
  w <- wald(m, keep = "^lead", print = FALSE)
  list(model = m, stat = unname(w$stat), p = unname(w$p))
}

# Event study by relative quarter using the imputation residuals: average tau
# within each post-adoption horizon; leads come from pretrend_test().
event_study <- function(d, yvar = "y", gvar = "g", B = B_ROBUST) {
  est <- function(dd) {
    r <- bjs_att(dd, yvar, gvar, keep_tau = TRUE)$tau
    r$h <- r$time_q - r$.g
    r |> filter(h %in% EVENT_WIN) |> group_by(h) |> summarise(tau = mean(.tau), .groups = "drop")
  }
  point <- est(d)
  set.seed(SEED)
  states <- unique(d$state); by_state <- split(d, d$state)
  boot <- lapply(seq_len(B), function(b) {
    pick <- sample(states, length(states), replace = TRUE)
    db <- bind_rows(lapply(seq_along(pick), function(k) {
      x <- by_state[[pick[k]]]; x$state <- paste0(pick[k], "_", k); x }))
    tryCatch(est(db), error = function(e) NULL)
  })
  se <- bind_rows(boot) |> group_by(h) |> summarise(se = sd(tau, na.rm = TRUE), .groups = "drop")
  leads <- pretrend_test(d, yvar, gvar)$model
  lead_df <- data.frame(h = -as.integer(sub("lead", "", names(coef(leads)))),
                        tau = unname(coef(leads)), se = unname(se(leads)))
  bind_rows(lead_df, left_join(point, se, by = "h")) |> arrange(h)
}

# Callaway & Sant'Anna (2021), not-yet-treated comparison group.
cs_att <- function(d, yvar = "y", gvar = "g") {
  if (!requireNamespace("did", quietly = TRUE)) return(NULL)
  d$.id <- as.integer(factor(d$state))
  gt <- did::att_gt(yname = yvar, tname = "time_q", idname = ".id", gname = gvar,
                    data = as.data.frame(d), control_group = "notyettreated",
                    clustervars = ".id", bstrap = TRUE, biters = B_ROBUST,
                    allow_unbalanced_panel = TRUE, print_details = FALSE)
  simple  <- did::aggte(gt, type = "simple",  na.rm = TRUE)
  dynamic <- did::aggte(gt, type = "dynamic", na.rm = TRUE, min_e = -8, max_e = 12)
  list(att = simple$overall.att, se = simple$overall.se, dynamic = dynamic)
}

# Wild cluster restricted (WCR) bootstrap p-value for the TWFE coefficient,
# Rademacher weights at the state level (Cameron, Gelbach & Miller 2008).
# Implemented directly so it needs no non-CRAN package.
wild_cluster_p <- function(d, yvar = "y", gvar = "g", B = B_WILD, seed = SEED) {
  d$.D <- as.integer(d[[gvar]] > 0 & d$time_q >= d[[gvar]])
  full <- feols(as.formula(paste(yvar, "~ .D | state + time_q")), data = d,
                cluster = ~state, notes = FALSE)
  t_obs <- unname(tstat(full)[".D"])
  restricted <- feols(as.formula(paste(yvar, "~ 1 | state + time_q")), data = d, notes = FALSE)
  yhat_r <- fitted(restricted); u_r <- resid(restricted)
  cl <- as.integer(factor(d$state)); G <- max(cl)
  set.seed(seed)
  t_boot <- vapply(seq_len(B), function(b) {
    w <- sample(c(-1, 1), G, replace = TRUE)[cl]
    d$.ystar <- yhat_r + w * u_r
    m <- feols(.ystar ~ .D | state + time_q, data = d, cluster = ~state, notes = FALSE)
    unname(tstat(m)[".D"])
  }, numeric(1))
  mean(abs(t_boot) >= abs(t_obs))
}

# Cohort-specific ATTs (Appendix Fig. A2): BJS residuals averaged by cohort.
cohort_atts <- function(d, yvar = "y", gvar = "g") {
  bjs_att(d, yvar, gvar, keep_tau = TRUE)$tau |>
    group_by(state, cohort = .g) |>
    summarise(att = mean(.tau), n_post = n(), .groups = "drop") |>
    arrange(cohort)
}

# =============================================================================
# Driver
# =============================================================================

run_all_specs <- function(d, label, B_main = B_MAIN, B_rob = B_ROBUST, B_wild = B_WILD) {
  message("== ", label, " ==")
  row <- function(spec, est, se) data.frame(class = label, spec = spec, est = est, se = se)
  bs  <- function(dd, f, B) block_bootstrap_se(dd, f, B)

  late <- d |> filter(time_q >= 2011 * 4, g == 0 | g >= 2011 * 4)
  noHI <- d |> filter(state != "HI")
  logd <- d |> filter(y > 0) |> mutate(y = log(y))

  t2 <- twfe(d)
  out <- bind_rows(
    row("BJS imputation, primary",           bjs_att(d),               bs(d,    bjs_att, B_main)),
    row("Two-way fixed effects",             unname(coef(t2)[".D"]),    unname(se(t2)[".D"])),
    row("Gardner two-stage",                 gardner_att(d),           bs(d,    gardner_att, B_rob)),
    row("BJS, log outcome",                  bjs_att(logd),            bs(logd, bjs_att, B_rob)),
    row("BJS, excluding Hawaii",             bjs_att(noHI),            bs(noHI, bjs_att, B_rob)),
    row("BJS, suppression-imputed outcome",  bjs_att(d, "y_suppimp"),  bs(d, function(x) bjs_att(x, "y_suppimp"), B_rob)),
    row("BJS, first-full-quarter timing",    bjs_att(d, gvar = "g_fullq"), bs(d, function(x) bjs_att(x, gvar = "g_fullq"), B_rob)),
    row("BJS, 2011 Q1 onward, later cohorts", bjs_att(late),            bs(late, bjs_att, B_rob))
  )

  pt      <- pretrend_test(d)
  pt_late <- pretrend_test(late)
  cs      <- cs_att(d)
  wild_p  <- wild_cluster_p(d, B = B_wild)

  diag <- data.frame(
    class = label,
    stat = c("Joint pre-trend test p (8 leads)", "Pre-trend p, 2011+ later cohorts",
             "Control mean (untreated obs)", "Wild cluster bootstrap p (TWFE)",
             "Callaway-Sant'Anna ATT", "Callaway-Sant'Anna SE", "States", "Quarters"),
    value = c(pt$p, pt_late$p,
              mean(d$y[!(d$g > 0 & d$time_q >= d$g)], na.rm = TRUE), wild_p,
              if (is.null(cs)) NA else cs$att, if (is.null(cs)) NA else cs$se,
              length(unique(d$state)), length(unique(d$time_q)))
  )

  list(table = out, diagnostics = diag,
       event_study = event_study(d, B = B_rob) |> mutate(class = label),
       cohorts = cohort_atts(d) |> mutate(class = label),
       cs = cs)
}

plot_event_study <- function(es, label) {
  ggplot2::ggplot(es, ggplot2::aes(h, tau)) +
    ggplot2::geom_hline(yintercept = 0, linewidth = 0.3) +
    ggplot2::geom_vline(xintercept = -0.5, linetype = "dashed", linewidth = 0.3) +
    ggplot2::geom_pointrange(ggplot2::aes(ymin = tau - 1.96 * se, ymax = tau + 1.96 * se), size = 0.25) +
    ggplot2::labs(x = "Quarters relative to FPA adoption",
                  y = "Scripts per 1,000 enrollees",
                  title = paste("Event study:", label),
                  subtitle = "BJS imputation estimates, 95% CI (state-block bootstrap)") +
    ggplot2::theme_minimal(base_size = 11)
}

if (sys.nframe() == 0L || identical(environment(), globalenv())) {
  if (all(file.exists(PANEL_FILES))) {
    res <- lapply(names(PANEL_FILES), function(k) run_all_specs(read.csv(PANEL_FILES[[k]]), k))
    write.csv(bind_rows(lapply(res, `[[`, "table")),       file.path(DIR_TABLES, "table2_robustness.csv"),  row.names = FALSE)
    write.csv(bind_rows(lapply(res, `[[`, "diagnostics")), file.path(DIR_TABLES, "table2_diagnostics.csv"), row.names = FALSE)
    write.csv(bind_rows(lapply(res, `[[`, "cohorts")),     file.path(DIR_TABLES, "cohort_atts.csv"),        row.names = FALSE)
    for (r in res) {
      lab <- unique(r$event_study$class)
      ggplot2::ggsave(file.path(DIR_FIGS, paste0("event_study_", lab, ".png")),
                      plot_event_study(r$event_study, lab), width = 7, height = 4.5, dpi = 300)
    }
    message("Wrote output/tables/table2_*.csv and output/figures/event_study_*.png")
  } else {
    message("Estimation panels not found in data/analysis/ -- see README (Data).")
  }
}
