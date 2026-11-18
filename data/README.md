# data/

Put the input files here. Nothing in this folder except these READMEs is committed (see `.gitignore`).

```
data/
  raw/
    sdud/          CMS State Drug Utilization Data, one CSV per year:
                   StateDrugUtilizationData2006.csv ... StateDrugUtilizationData2023.csv
    external/      IPUMS ACS extracts (usa_000NN.csv), BLS LAUS county files
                   (laucntyYY.xlsx), BRFSS LLCP annual files
  controls/        NPFPASet_Final.csv (FPA law coding), STATEFIPS.xlsx / statefips.xlsx,
                   medicaid_expansion_quarterly_2006_2023.csv, uk_metrics.xlsx (UKCPR),
                   deflator.csv; built controls are also written here
  intermediate/    written by the pipeline (cleaned SDUD, merged files, drug-class files)
  analysis/        estimation panels for R/14_robustness.R:
                   panel_diabetes.csv, panel_antidepressants.csv
```

See the main README for where to download each source.
