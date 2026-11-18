libname data  'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS';
libname summary  'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\datasets';
libname Biguiani 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\Biguianides';
libname Sulfonyl 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\Sulfonylureas';
libname TZDs    'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\TZDs';
libname InsulinA 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\InsulinAnalogs';
libname GLP1Agon 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\GLP1Agonists';
libname DPP4Inhi 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\DPP4Inhibitors';
libname SGLT2Inh 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\SGLT2Inhibitors';

/*===========================================================
Event-study DiD (dynamic effects by event_time) that plugs into
YOUR existing %did_list(lib=..., list=...) calls.

Assumptions:
- Each dataset already contains:
    * event_time  (0 in first treated year, negative before, positive after)
- You want TWFE event study: state FE + year FE
- Baseline (omitted) period is event_time = -1  (e_m1 omitted)

Usage stays the same:
  %did_list(lib=Biguiani, list=&biguiani_list);
  %did_list(lib=Sulfonyl, list=&sulfonyl_list);
  ...
===========================================================*/
/*-------------------------
USER SETTINGS
-------------------------*/
%let yvar = Number_of_Prescriptions;
%let L    = 5;
%let F    = 5;
%let F1   = %eval(&F + 1);   /* <-- critical fix for ARRAY dimension */

/*===========================================================
One-dataset event-study runner (compatible with %did_list)
===========================================================*/
%macro did_one(lib=, ds=, statevar=state, yearvar=year, etvar=event_time);

    proc sort data=&lib..&ds out=_es_sorted;
        by &statevar &yearvar;
    run;

    data _es_dummies;
        set _es_sorted;

        /* Bin tails */
        if not missing(&etvar) then do;
            if &etvar <= -&L then et = -&L;
            else if &etvar >=  &F then et =  &F;
            else et = &etvar;
        end;
        else et = .;

        /* Dummies: -1..-L and 0..F */
        array lead[&L]  e_m1-e_m&L;
        array lag[&F1]  e_0-e_&F;   /* <-- use &F1 instead of &F+1 */

        do i=1 to dim(lead); lead[i]=0; end;
        do i=1 to dim(lag);  lag[i]=0;  end;

        if not missing(et) then do;
            if et < 0 then do;
                k = -et;
                if 1 <= k <= &L then lead[k] = 1;
            end;
            else do;
                k = et;
                if 0 <= k <= &F then lag[k+1] = 1;  /* k=0 -> lag[1] = e_0 */
            end;
        end;

        drop i k et;
    run;

    title "Event-study DiD: &lib..&ds (Outcome=&yvar, baseline event_time=-1)";
    proc glm data=_es_dummies;
        class &statevar &yearvar;

        model &yvar =
            /* Leads (omit e_m1 baseline) */
            %if &L >= 2 %then %do;
                %do j=2 %to &L;
                    e_m&j
                %end;
            %end;

            /* Lags incl. treatment year */
            %do j=0 %to &F;
                e_&j
            %end;

            &statevar &yearvar
        ;
    run;
    quit;
    title;

%mend did_one;

/* Your list runner stays the same */
%macro did_list(lib=, list=);
    %local i d;
    %let i = 1;
    %do %while(%scan(&list,&i) ne );
        %let d = %scan(&list,&i);
        %did_one(lib=&lib, ds=&d);
        %let i = %eval(&i + 1);
    %end;
%mend did_list;


/* Biguanides */
%let biguiani_list =
    metformin_fp
    metformin_xr_fp
    glucophage_fp
    fortamet_fp
    glumetza_fp
;

/* Sulfonylureas */
%let sulfonyl_list =
    glipizide_fp
    glipizide_xl_fp
    glimepiride_fp
    glyburide_fp
    glucotrol_fp
    amaryl_fp
    diabeta_fp
    glynase_fp
;

/* TZDs */
%let tzds_list =
    pioglitazone_fp
    rosiglitazone_fp
    actos_fp
    avandia_fp
;

/* DPP-4 Inhibitors */
%let dpp4_list =
    sitagliptin_fp
    saxagliptin_fp
    linagliptin_fp
    alogliptin_fp
    januvia_fp
    onglyza_fp
    tradjenta_fp
    nesina_fp
;

/* SGLT2 Inhibitors */
%let sglt2_list =
    canagliflozin_fp
    dapagliflozin_fp
    empagliflozin_fp
    ertugliflozin_fp
    bexagliflozin_fp
    invokana_fp
    farxiga_fp
    jardiance_fp
    steglatro_fp
    brenzavvy_fp
;

/* GLP-1 / related agonists */
%let glp1_list =
    liraglutide_fp
    dulaglutide_fp
    semaglutide_fp
    tirzepatide_fp
    victoza_fp
    trulicity_fp
    ozempic_fp
    rybelsus_fp
    mounjaro_fp
;

/* Insulin analogs & human insulins */
%let insulina_list =
    humalog_fp
    novolog_fp
    opidra_fp  /* check name: Apidra vs Opidra; fix if needed */
    lantus_fp
    basaglar_fp
    levemir_fp
    tresiba_fp
    humulin_n_fp
    humulin_r_fp
    novolin_n_fp
    novolin_r_fp
    insulin_lispro_fp
    insulin_aspart_fp
    insulin_glulisine_fp
    insulin_glargine_fp
    insulin_detemir_fp
    insulin_degludec_fp
    nph_insulin_fp
    regular_insulin_fp
;


/* Biguanides */
%did_list(lib=Biguiani, list=&biguiani_list);

/* Sulfonylureas */
%did_list(lib=Sulfonyl, list=&sulfonyl_list);

/* TZDs */
%did_list(lib=TZDs, list=&tzds_list);

/* DPP-4 inhibitors */
%did_list(lib=DPP4Inhi, list=&dpp4_list);

/* SGLT2 inhibitors */
%did_list(lib=SGLT2Inh, list=&sglt2_list);

/* GLP-1 agonists / duals */
%did_list(lib=GLP1Agon, list=&glp1_list);

/* Insulin analogs / human insulins */
%did_list(lib=InsulinA, list=&insulina_list);
