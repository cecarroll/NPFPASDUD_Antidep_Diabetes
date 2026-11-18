source(here::here("R", "00_config.R"))


# install.packages(c("haven", "dplyr", "stringr", "purrr", "readxl", "readr"))
library(haven)
library(dplyr)
library(stringr)
library(purrr)
library(readxl)
library(readr)
library(data.table)


#Prep your packages and directory 
# (path handled by 00_config.R)

# ============================================
# Filter SDUD year-files into one CSV per drug
# - Outer loop: drugs
# - Inner loop: years
# - For each drug:
#     read each year -> dfyear
#     keep rows where "Product Name" matches ANY pattern
#     append into df_filtered
#     rm(dfyear) to free memory
#   then write df_filtered as SDUD<drugtoken>.csv
# ============================================


# Each element is a vector:
#   1st entry = file token (used in output filename)
#   remaining entries = match terms (brand/generic/etc.)


# ---- years + directories ----

years  <- 2010:2023
in_dir  <- DIR_SDUD_MERGED
out_dir <- DIR_FILTERED
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

drug_lists <- list(
  #Biguanides
  c("biguanides", "metformin", "metformin", "glucophage", "glumetza", "fortamet", "riomet"),
  
  # Sulfonylureas
  c("sulfonylureas", "glipizide", "glipizide", "glucotrol"),
  c("sulfonylureas", "glyburide", "glyburide", "micronase", "diabeta", "glynase"),
  c("sulfonylureas", "glimepiride", "glimepiride", "amaryl"),
  c("sulfonylureas", "tolbutamide", "tolbutamide"),
  c("sulfonylureas", "tolazamide", "tolazamide"),
  c("sulfonylureas", "chlorpropamide", "chlorpropamide"),
  
  # TZDs
  c("tzds", "pioglitazone", "pioglitazone", "actos"),
  c("tzds", "rosiglitazone", "rosiglitazone", "avandia"),
  
  # DPP-4 inhibitors
  c("dpp4_inhibitors", "sitagliptin", "sitagliptin", "januvia"),
  c("dpp4_inhibitors", "linagliptin", "linagliptin", "tradjenta"),
  c("dpp4_inhibitors", "saxagliptin", "saxagliptin", "onglyza"),
  c("dpp4_inhibitors", "alogliptin", "alogliptin", "nesina"),
  
  # GLP-1 / incretins
  c("glp1_incretins", "semaglutide", "semaglutide", "ozempic", "wegovy", "rybelsus"),
  c("glp1_incretins", "liraglutide", "liraglutide", "victoza", "saxenda"),
  c("glp1_incretins", "dulaglutide", "dulaglutide", "trulicity"),
  c("glp1_incretins", "exenatide", "exenatide", "byetta", "bydureon"),
  c("glp1_incretins", "lixisenatide", "lixisenatide", "adlyxin"),
  c("glp1_incretins", "tirzepatide", "tirzepatide", "mounjaro", "zepbound"),
  
  # SGLT2 inhibitors
  c("sglt2_inhibitors", "empagliflozin", "empagliflozin", "jardiance"),
  c("sglt2_inhibitors", "dapagliflozin", "dapagliflozin", "farxiga"),
  c("sglt2_inhibitors", "canagliflozin", "canagliflozin", "invokana"),
  c("sglt2_inhibitors", "ertugliflozin", "ertugliflozin", "steglatro"),
  
  # Meglitinides
  c("meglitinides", "repaglinide", "repaglinide", "prandin"),
  c("meglitinides", "nateglinide", "nateglinide", "starlix"),
  
  # Alpha-glucosidase inhibitors
  c("alpha_glucosidase", "acarbose", "acarbose", "precose"),
  c("alpha_glucosidase", "miglitol", "miglitol", "glyset"),
  
  # Amylin analog
  c("amylin_analogs", "pramlintide", "pramlintide", "symlin"),
  
  # Insulins (group by family)
  c("insulins", "insulin_aspart", "aspart", "novolog", "fiasp"),
  c("insulins", "insulin_lispro", "lispro", "humalog", "admelog", "lyumjev"),
  c("insulins", "insulin_glulisine", "glulisine", "apidra"),
  c("insulins", "insulin_regular", "regular", "humulin r", "novolin r"),
  c("insulins", "insulin_nph", "nph", "humulin n", "novolin n"),
  c("insulins", "insulin_detemir", "detemir", "levemir"),
  c("insulins", "insulin_glargine", "glargine", "lantus", "basaglar", "toujeo", "semglee", "rezvoglar"),
  c("insulins", "insulin_degludec", "degludec", "tresiba"),
  
  # Combo diabetes products (they’ll match on brand AND component strings)
  c("combo_diabetes", "janumet", "janumet", "sitagliptin", "metformin"),
  c("combo_diabetes", "jentadueto", "jentadueto", "linagliptin", "metformin"),
  c("combo_diabetes", "kombiglyze", "kombiglyze", "saxagliptin", "metformin"),
  c("combo_diabetes", "kazano", "kazano", "alogliptin", "metformin"),
  c("combo_diabetes", "synjardy", "synjardy", "empagliflozin", "metformin"),
  c("combo_diabetes", "xigduo", "xigduo", "dapagliflozin", "metformin"),
  c("combo_diabetes", "invokamet", "invokamet", "canagliflozin", "metformin"),
  #drug_lists <- list(
  c("combo_diabetes", "segromet", "segromet", "ertugliflozin", "metformin"),
  
  c("combo_diabetes", "actoplus", "actoplus", "pioglitazone", "metformin"),
  c("combo_diabetes", "avandamet", "avandamet", "rosiglitazone", "metformin"),
  c("combo_diabetes", "xultophy", "xultophy", "degludec", "liraglutide"),
  c("combo_diabetes", "soliqua", "soliqua", "glargine", "lixisenatide"),
  c("combo_diabetes", "glyxambi", "glyxambi", "empagliflozin", "linagliptin"),
  c("combo_diabetes", "qtern", "qtern", "dapagliflozin", "saxagliptin"),
  c("combo_diabetes", "steglujan", "steglujan", "ertugliflozin", "sitagliptin"),
  
  # =========================
  # Mental health medications
  # =========================
  
  # SSRIs
  c("ssris", "sertraline", "sertraline", "zoloft"),
  c("ssris", "fluoxetine", "fluoxetine", "prozac", "sarafem"),
  c("ssris", "citalopram", "citalopram", "celexa"),
  c("ssris", "escitalopram", "escitalopram", "lexapro"),
  c("ssris", "paroxetine", "paroxetine", "paxil", "pexeva"),
  c("ssris", "fluvoxamine", "fluvoxamine", "luvox"),
  
  # SNRIs
  c("snris", "venlafaxine", "venlafaxine", "effexor"),
  c("snris", "desvenlafaxine", "desvenlafaxine", "pristiq"),
  c("snris", "duloxetine", "duloxetine", "cymbalta"),
  c("snris", "levomilnacipran", "levomilnacipran", "fetzima"),
  
  # TCAs
  c("tcas", "amitriptyline", "amitriptyline", "elavil"),
  c("tcas", "nortriptyline", "nortriptyline", "pamelor"),
  c("tcas", "imipramine", "imipramine", "tofranil"),
  c("tcas", "desipramine", "desipramine", "norpramin"),
  c("tcas", "clomipramine", "clomipramine", "anafranil"),
  c("tcas", "doxepin", "doxepin", "sinequan", "silenor"),
  
  # MAOIs
  c("maois", "phenelzine", "phenelzine", "nardil"),
  c("maois", "tranylcypromine", "tranylcypromine", "parnate"),
  c("maois", "isocarboxazid", "isocarboxazid", "marplan"),
  c("maois", "selegiline", "selegiline", "emsam"),
  
  # Other antidepressants
  c("other_antidepressants", "bupropion", "bupropion", "wellbutrin", "aplenzin", "forfivo"),
  c("other_antidepressants", "mirtazapine", "mirtazapine", "remeron"),
  c("other_antidepressants", "trazodone", "trazodone", "desyrel"),
  c("other_antidepressants", "nefazodone", "nefazodone", "serzone"),
  c("other_antidepressants", "vortioxetine", "vortioxetine", "trintellix", "brintellix"),
  c("other_antidepressants", "vilazodone", "vilazodone", "viibryd"),
  c("other_antidepressants", "esketamine", "esketamine", "spravato"),
  
  # Benzodiazepines
  c("benzodiazepines", "alprazolam", "alprazolam", "xanax"),
  c("benzodiazepines", "lorazepam", "lorazepam", "ativan"),
  c("benzodiazepines", "clonazepam", "clonazepam", "klonopin"),
  c("benzodiazepines", "diazepam", "diazepam", "valium"),
  c("benzodiazepines", "temazepam", "temazepam", "restoril"),
  c("benzodiazepines", "chlordiazepoxide", "chlordiazepoxide", "librium"),
  c("benzodiazepines", "oxazepam", "oxazepam"),
  c("benzodiazepines", "clorazepate", "clorazepate"),
  
  # Other anxiolytics
  c("anxiolytics_other", "buspirone", "buspirone", "buspar"),
  c("anxiolytics_other", "hydroxyzine", "hydroxyzine", "atarax", "vistaril"),
  c("anxiolytics_other", "propranolol_anxiety", "propranolol", "inderal"),
  
  # Atypical antipsychotics
  c("atypical_antipsychotics", "aripiprazole", "aripiprazole", "abilify"),
  c("atypical_antipsychotics", "quetiapine", "quetiapine", "seroquel"),
  c("atypical_antipsychotics", "olanzapine", "olanzapine", "zyprexa"),
  c("atypical_antipsychotics", "risperidone", "risperidone", "risperdal"),
  c("atypical_antipsychotics", "paliperidone", "paliperidone", "invega"),
  c("atypical_antipsychotics", "ziprasidone", "ziprasidone", "geodon"),
  c("atypical_antipsychotics", "clozapine", "clozapine", "clozaril"),
  c("atypical_antipsychotics", "lurasidone", "lurasidone", "latuda"),
  c("atypical_antipsychotics", "asenapine", "asenapine", "saphris"),
  c("atypical_antipsychotics", "iloperidone", "iloperidone", "fanapt"),
  c("atypical_antipsychotics", "brexpiprazole", "brexpiprazole", "rexulti"),
  c("atypical_antipsychotics", "cariprazine", "cariprazine", "vraylar"),
  c("atypical_antipsychotics", "lumateperone", "lumateperone", "caplyta"),
  
  # Typical antipsychotics
  c("typical_antipsychotics", "haloperidol", "haloperidol", "haldol"),
  c("typical_antipsychotics", "chlorpromazine", "chlorpromazine", "thorazine"),
  c("typical_antipsychotics", "fluphenazine", "fluphenazine"),
  c("typical_antipsychotics", "perphenazine", "perphenazine"),
  c("typical_antipsychotics", "thioridazine", "thioridazine"),
  c("typical_antipsychotics", "thiothixene", "thiothixene"),
  c("typical_antipsychotics", "trifluoperazine", "trifluoperazine"),
  
  # Mood stabilizers
  c("mood_stabilizers", "lithium", "lithium", "lithobid", "eskalith"),
  c("mood_stabilizers", "valproate", "valproate", "valproic", "divalproex", "depakote"),
  c("mood_stabilizers", "carbamazepine", "carbamazepine", "tegretol"),
  c("mood_stabilizers", "lamotrigine", "lamotrigine", "lamictal"),
  
  # ADHD stimulants
  c("adhd_stimulants", "amphetamine_mixed", "amphetamine", "adderall"),
  c("adhd_stimulants", "dextroamphetamine", "dextroamphetamine", "dexedrine"),
  c("adhd_stimulants", "lisdexamfetamine", "lisdexamfetamine", "vyvanse"),
  c("adhd_stimulants", "methylphenidate", "methylphenidate", "ritalin", "concerta", "metadate", "daytrana", "quillichew", "quillivant"),
  c("adhd_stimulants", "dexmethylphenidate", "dexmethylphenidate", "focalin"),
  
  # ADHD non-stimulants
  c("adhd_nonstimulants", "atomoxetine", "atomoxetine", "strattera"),
  c("adhd_nonstimulants", "guanfacine", "guanfacine", "intuniv"),
  c("adhd_nonstimulants", "clonidine", "clonidine", "kapvay"),
  
  # Sleep agents
  c("sleep_agents", "zolpidem", "zolpidem", "ambien", "edluar"),
  c("sleep_agents", "eszopiclone", "eszopiclone", "lunesta"),
  c("sleep_agents", "zaleplon", "zaleplon", "sonata"),
  c("sleep_agents", "suvorexant", "suvorexant", "belsomra"),
  c("sleep_agents", "lemborexant", "lemborexant", "dayvigo"),
  c("sleep_agents", "ramelteon", "ramelteon", "rozerem")

)



walk(drug_lists, function(drug_vec) {
  group_token <- drug_vec[1]
  drug_token  <- drug_vec[2]
  
  patterns <- drug_vec[-1]  # keep drug token + match strings, drop group label only
  
  print(patterns)
  patterns <- paste(patterns, collapse = "|")
  print(patterns)
  
  total_hits  <- 0L
  first <- TRUE
  walk(years, function(y) {
    
    in_file <- file.path(in_dir, paste0("NPStudy", y, "final.csv"))
    
    dfyear <- read_csv(
      in_file,
      show_col_types = FALSE,
      col_types = readr::cols(
        utilization_type                 = readr::col_integer(),
        state                            = readr::col_character(),
        ndc                              = readr::col_character(),
        labeler_code                     = readr::col_character(),
        product_code                     = readr::col_character(),
        package_size                     = readr::col_character(),
        year                             = readr::col_integer(),
        quarter                          = readr::col_integer(),
        suppression_used                 = readr::col_integer(),
        product_name                     = readr::col_character(),
        units_reimbursed                 = readr::col_double(),
        number_of_prescriptions          = readr::col_double(),
        statefip                         = readr::col_double(),
        medicaid_expansion               = readr::col_integer(),
        prop_bmi34                       = readr::col_double(),
        prop_bmi4                        = readr::col_double(),
        unemployment_rate                = readr::col_double(),
        population                       = readr::col_double(),
        afdc_tanf_benefit_for_4_person_family = readr::col_double(),
        fs_snap_benefit_for_4_person_family   = readr::col_double(),
        poverty_rate                     = readr::col_double(),
        governor_is_democrat_1_yes       = readr::col_character(),
        federal_minimum_wage             = readr::col_double(),
        state_minimum_wage               = readr::col_double(),
        medicaid_beneficiaries           = readr::col_double(),
        cpi                              = readr::col_double(),
        mean_age                         = readr::col_double(),
        share_female                     = readr::col_double(),
        share_black                      = readr::col_double(),
        share_metro_indet                = readr::col_double(),
        share_metro_non                  = readr::col_double(),
        share_metro_central              = readr::col_double(),
        share_metro_noncentral           = readr::col_double(),
        share_metro_mixed                = readr::col_double(),
        share_ba_or_more                 = readr::col_double(),
        avg_inc_adj                      = readr::col_double(),
        med_inc_adj                      = readr::col_double(),
        tot_inc_adj                      = readr::col_double(),
        yearquarter                      = readr::col_character(),
        treat                            = readr::col_integer(),
        event_time                       = readr::col_double(),
        total_amount_reimbursed_adj      = readr::col_double(),
        medicaid_amount_reimbursed_adj   = readr::col_double(),
        non_medicaid_amount_reimbursed_adj = readr::col_double()
      )
    ) 
    print(dim(dfyear))
    m <- stringr::str_detect(dfyear[["product_name"]],
                             stringr::regex(patterns, ignore_case = TRUE))
    
    dfyear_f <- dfyear[m %in% TRUE, ]         # keeps TRUE, drops FALSE/NA
    hits <- sum(m, na.rm = TRUE)
    total_hits <<- total_hits + hits
    
    out_file <- file.path(out_dir, paste0("SDUD_", group_token, "_", drug_token, ".csv"))
    fwrite(dfyear_f, out_file, append = !first, col.names = first)
    first <<- FALSE
    
    #check for problems in the table from inside the loop
    #print(problems(dfyear))
    print(dim(dfyear_f))
    
    rm(dfyear)
    rm(dfyear_f)
    
    gc(FALSE)
    
    cat("Drug:", drug_token, "| Year:", y, "| hits:", hits, "\n")
  })
  
  
  
  
  
  cat("Drug:", drug_token,
      "| TOTAL hits across years:", total_hits, "\n")
  
  
  
  gc(FALSE)
})

if(FALSE){
dftypes<-data.frame(
name   = names(dfyear),
typeof = sapply(dfyear, typeof),
class  = sapply(dfyear, function(x) paste(class(x), collapse = ", ")),
row.names = NULL
)
print(dftypes)
}

