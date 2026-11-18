# Nurse Practitioner Full Practice Authority and Medicaid Prescription Utilization

Replication code for **Carroll, C. & Mitchell, D. T. (2026). *Nurse Practitioner Full Practice Authority and Medicaid Prescription Utilization: Evidence from Diabetes and Depression Pharmacotherapy, 2009–2019.*** Working paper.

**Question.** When a state lets nurse practitioners prescribe without physician oversight (full practice authority, FPA), do Medicaid fills for chronic-disease medications rise?

**Design.** A staggered difference-in-differences design on a 39-state × 44-quarter panel built from the universe of Medicaid outpatient prescriptions (CMS State Drug Utilization Data). Seventeen states adopted FPA inside the window. The design uses heterogeneity-robust estimators (Borusyak–Jaravel–Spiess imputation, Gardner two-stage, Callaway–Sant'Anna) and pre-trend diagnostics.

**Finding (draft).** Antidepressants show a precise null that survives every robustness check. Diabetes medications show a positive point estimate, but it fails the pre-trend test and is driven by one early-adopting state.

---

## What's in this repository

The project was built twice, in **R** and in **SAS 9**, as an independent cross-check of the data build. There is also an early **Stata** cleaning pass.

```
R/
  00_config.R                     paths (via here::here) + package check
  install_packages.R              one-time package install
  01_clean_sdud.R                 CMS SDUD yearly files -> typed, 11-digit NDC, MCO/FFS flags
  02_controls_census_acs.R        IPUMS ACS microdata -> state-year demographics & income (median + mean)
  03_controls_unemployment.R      BLS LAUS county files -> state unemployment rate
  04_controls_brfss_obesity.R     BRFSS LLCP -> weighted share BMI>=34/40 by state-year
  05_controls_state_abbrev.R      harmonize state identifiers in the Medicaid-expansion file
  06_controls_merge.R             all controls + FPA treatment timing -> state-quarter controls
  07_merge_sdud_controls.R        attach controls to every SDUD record, deflate $ to constant dollars
  08_filter_drug_classes.R        product-name dictionary -> one file per drug (diabetes + mental health)
  09_suppression_missingness.R    count CMS-suppressed cells by state-quarter
  10_did_diabetes.R               exploratory DiD: Callaway-Sant'Anna + Sun-Abraham, diabetes classes
  11_did_antidepressants.R        exploratory DiD: same, antidepressant classes
  12_fig_fpa_map.R                quarterly maps of FPA adoption
  13_fig_controls.R               control-variable trend plots
  14_robustness.R                 manuscript specification set (Table 2 + pending checks)
  exploratory/                    single-drug (metformin) DiD and EDA notebooks-as-scripts
SAS/                              SAS 9 build: import -> merge FPA laws -> clean -> drug sets -> event-study DiD
stata/                            first-pass Stata cleaning of the 1991-2024 SDUD files
tests/test_robustness_synthetic.R checks every estimator in 14_robustness.R against a known effect
```

### `14_robustness.R` — the specification set

| # | Specification | Notes |
|---|---|---|
| 1 | BJS imputation estimator, primary | state-block bootstrap, 999 reps |
| 2 | Two-way fixed effects | benchmark; can be biased under staggered adoption |
| 3 | Gardner two-stage | |
| 4 | BJS, log outcome | |
| 5 | BJS, excluding Hawaii | earliest adopter, only 2 pre-quarters |
| 6 | BJS, suppression-imputed outcome | |
| 7 | BJS, first-full-quarter timing | |
| 8 | BJS, 2011 Q1 onward, later cohorts | removes the Medicaid MCO reporting ramp |
| 9 | Joint pre-trend test (8 leads) | Wald test on untreated obs, state-clustered |
| 10 | Callaway–Sant'Anna ATT | not-yet-treated controls |
| 11 | Wild cluster bootstrap p | Rademacher, WCR; 39 clusters |
| 12 | Cohort-specific ATTs | Appendix Fig. A2 |
| 13 | Event study | Figs. 1–2 |

The imputation estimator is implemented directly in the script so each step is visible. `tests/test_robustness_synthetic.R` confirms it matches the [`didimputation`](https://github.com/kylebutts/didimputation) package exactly and recovers a known effect.

## Running it

```r
source("R/install_packages.R")   # once
source("R/01_clean_sdud.R")      # ...then 02 through 13 in order
source("R/14_robustness.R")      # writes output/tables/ and output/figures/
```

Every script sources `R/00_config.R`, so there are no machine-specific paths. Put the raw files in `data/raw/` and run the scripts in numeric order.

## Data

No data are committed, but the folder structure is: see [`data/README.md`](data/README.md) for exactly where each file goes. Everything used is public:

| Source | Used for | Get it |
|---|---|---|
| CMS State Drug Utilization Data, 2006–2023 | outcome | data.medicaid.gov → State Drug Utilization Data, one CSV per year → `data/raw/sdud/` |
| FPA law coding | treatment timing | state-quarter FPA status → `data/controls/NPFPASet_Final.csv` (the manuscript uses McMichael & Markowitz 2023 effective dates) |
| IPUMS USA (ACS) | demographics, income, Medicaid-coverage denominator | usa.ipums.org extract → `data/raw/external/` |
| BLS LAUS | unemployment | bls.gov/lau county files → `data/raw/external/` |
| CDC BRFSS (LLCP) | obesity prevalence | cdc.gov/brfss annual files → `data/raw/external/` |
| UKCPR National Welfare Data | poverty rate, TANF/SNAP benefits, minimum wage, governor party, Medicaid beneficiaries | ukcpr.org → `data/controls/uk_metrics.xlsx` |
| Medicaid expansion dates | control | `data/controls/medicaid_expansion_quarterly_2006_2023.csv` |

The full SDUD extract is about 50 GB uncompressed, so the R build processes it in yearly chunks.

## Status and provenance

- The manuscript's reported estimates come from the Stata implementation (`did_imputation`, `csdid`) run on the 2009–2019 per-1,000-enrollee panel. `14_robustness.R` is the R implementation of that same specification set. Run on the same panel, it should reproduce Table 2 up to bootstrap noise. Confirming that match is the next step.
- `10_` and `11_` are the earlier exploratory R analysis: raw script counts, 2010–2020, with covariates. They are kept for transparency and are not the paper's specification.
- Known issue to revisit: in `08_filter_drug_classes.R`, the bare match terms `"regular"` and `"nph"` (insulin families) can match unrelated product names. The manuscript's dictionary uses exact product names instead.

## Authors

Cole E. Carroll (Ball State University) · David T. "Mitch" Mitchell (Ball State University)
