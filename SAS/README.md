# SAS 9 build

An independent rebuild of the SDUD data in SAS 9.4, used to cross-check the R pipeline. Run the files in numeric order.

| File | Step |
|---|---|
| `01_import_sdud.sas` | `PROC IMPORT` each yearly CMS SDUD CSV into a SAS library |
| `02_clean.sas` | per-year type conversion of utilization-type, suppression, and NDC fields |
| `03_stack_years.sas` | stack the cleaned years into `data.combined` |
| `04_import_fpa_laws.sas` | import the FPA law coding (`NPFPASet`) |
| `05_merge_fpa_stacked.sas` | merge FPA status onto the stacked file by state-year |
| `06_split_by_drug.sas` | product-name regex (`PRXMATCH`) → one dataset per diabetes drug, by class library |
| `07_merge_fpa_by_drug.sas` | attach FPA status to each drug dataset |
| `07b_merge_fpa_by_drug_macro.sas` | the same step as a reusable macro (loops over datasets) |
| `08_summary_stats.sas` | `PROC MEANS` descriptive tables by drug |
| `09_event_study_did.sas` | macro-driven event-study DiD by event time, run over the drug list |

**Paths:** each file opens with `LIBNAME` statements pointing at the original Ball State workstation (`C:\Users\CECARROLL2\...`). Edit those to your own directories before running.
