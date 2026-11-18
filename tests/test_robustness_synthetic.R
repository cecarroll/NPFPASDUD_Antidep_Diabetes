# Checks the estimators in R/14_robustness.R on a simulated staggered-adoption
# panel with a known, homogeneous treatment effect. Run from the repo root:
#   Rscript tests/test_robustness_synthetic.R
source(here::here("R", "00_config.R"))
source(here::here("R", "14_robustness.R"))

set.seed(1)
TRUE_ATT <- 10
states <- c(setdiff(state.abb, "HI")[1:38], "HI")   # 39 unique states, like the paper
q      <- (2009 * 4):(2019 * 4 + 3)                      # 2009Q1-2019Q4, 44 quarters
cohort <- c(sample(q[c(3, 7, 15, 20, 30, 40)], 17, replace = TRUE), rep(0, 22))
names(cohort) <- states
cohort["HI"] <- q[3]                                     # HI treated 2009Q3

d <- expand.grid(state = states, time_q = q, stringsAsFactors = FALSE)
d$year    <- d$time_q %/% 4
d$quarter <- d$time_q %% 4 + 1
d$g       <- unname(cohort[d$state])
d$g_fullq <- ifelse(d$g > 0, d$g + 1, 0)
a_i <- setNames(rnorm(length(states), 100, 20), states)
b_t <- setNames(cumsum(rnorm(length(q), 0.5, 1)), q)
D   <- as.integer(d$g > 0 & d$time_q >= d$g)
d$y         <- a_i[d$state] + b_t[as.character(d$time_q)] + TRUE_ATT * D + rnorm(nrow(d), 0, 5)
d$y_suppimp <- d$y + rnorm(nrow(d), 0, 0.5)

res <- run_all_specs(d, "synthetic", B_main = 99, B_rob = 49, B_wild = 199)
print(res$table, digits = 3)
print(res$diagnostics, digits = 3)

tab <- res$table
stopifnot(
  abs(tab$est[tab$spec == "BJS imputation, primary"] - TRUE_ATT) < 1.5,
  abs(tab$est[tab$spec == "Two-way fixed effects"]   - TRUE_ATT) < 1.5,
  abs(tab$est[tab$spec == "Gardner two-stage"] - tab$est[tab$spec == "BJS imputation, primary"]) < 1e-6,
  all(is.finite(tab$se)), all(tab$se > 0),
  res$diagnostics$value[res$diagnostics$stat == "Joint pre-trend test p (8 leads)"] > 0.01,
  nrow(res$event_study) > 10
)

# Cross-check the hand-rolled BJS against the didimputation package
if (requireNamespace("didimputation", quietly = TRUE)) {
  d$sid <- as.integer(factor(d$state))
  pk <- didimputation::did_imputation(data = d, yname = "y", gname = "g",
                                      tname = "time_q", idname = "sid")
  cat("didimputation package ATT:", pk$estimate, " | ours:", bjs_att(d), "\n")
  stopifnot(abs(pk$estimate - bjs_att(d)) < 1e-6)
}
cat("\nAll robustness-estimator checks passed.\n")
