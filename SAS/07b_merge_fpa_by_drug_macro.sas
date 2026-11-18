

/*----------------------------------------------------------*/
/*  Libnames (your existing ones)                          */
/*----------------------------------------------------------*/

libname data      "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS";
libname SDUDSAS   "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS";
libname summary   "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\datasets";
libname Biguiani  "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\Biguianides";
libname Sulfonyl  "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\Sulfonylureas";
libname TZDs      "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\TZDs";
libname InsulinA  "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\InsulinAnalogs";
libname GLP1Agon  "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\GLP1Agonists";
libname DPP4Inhi  "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\DPP4Inhibitors";
libname SGLT2Inh  "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\SGLT2Inhibitors";

/*----------------------------------------------------------*/
/*  Sort npfpaset once by State Year                       */
/*----------------------------------------------------------*/

proc sort data=SDUDSAS.npfpaset;
    by State Year;
run;

/*----------------------------------------------------------*/
/* Macro to merge drug dataset with npfpaset and overwrite  */
/* in same location, naming the new dataset NP<name>.       */
/* Example: metformin -> NPmetformin                        */
/----------------------------------------------------------*/

%macro merge_np(lib=, ds=);

    /* Sort the source dataset */
    proc sort data=&lib..&ds;
        by State Year;
    run;

    /* Merge and overwrite into NP<dsname> */
    data &lib..NP&ds;
        merge &lib..&ds (in=a)
              SDUDSAS.npfpaset (in=b);
        by State Year;
        if a;  /* keep all drug rows, attach NP information when available */
    run;

    /* Optional: see structure */
    proc contents data=&lib..NP&ds;
    run;

%mend merge_np;


%merge_np(lib=Biguiani, ds=metformin);
%merge_np(lib=Biguiani, ds=metformin_xr);
%merge_np(lib=Biguiani, ds=glucophage);
%merge_np(lib=Biguiani, ds=fortamet);
%merge_np(lib=Biguiani, ds=glumetza);
%merge_np(lib=Sulfonyl, ds=glipizide);
%merge_np(lib=Sulfonyl, ds=glipizide_xl);
%merge_np(lib=Sulfonyl, ds=glimepiride);
%merge_np(lib=Sulfonyl, ds=glyburide);
%merge_np(lib=Sulfonyl, ds=glucotrol);
%merge_np(lib=Sulfonyl, ds=amaryl);
%merge_np(lib=Sulfonyl, ds=diabeta);
%merge_np(lib=Sulfonyl, ds=glynase);
%merge_np(lib=TZDs, ds=pioglitazone);
%merge_np(lib=TZDs, ds=rosiglitazone);
%merge_np(lib=TZDs, ds=actos);
%merge_np(lib=TZDs, ds=avandia);
%merge_np(lib=DPP4Inhi, ds=sitagliptin);
%merge_np(lib=DPP4Inhi, ds=saxagliptin);
%merge_np(lib=DPP4Inhi, ds=linagliptin);
%merge_np(lib=DPP4Inhi, ds=alogliptin);
%merge_np(lib=DPP4Inhi, ds=januvia);
%merge_np(lib=DPP4Inhi, ds=onglyza);
%merge_np(lib=DPP4Inhi, ds=tradjenta);
%merge_np(lib=DPP4Inhi, ds=nesina);
%merge_np(lib=SGLT2Inh, ds=canagliflozin);
%merge_np(lib=SGLT2Inh, ds=dapagliflozin);
%merge_np(lib=SGLT2Inh, ds=empagliflozin);
%merge_np(lib=SGLT2Inh, ds=ertugliflozin);
%merge_np(lib=SGLT2Inh, ds=bexagliflozin);
%merge_np(lib=SGLT2Inh, ds=invokana);
%merge_np(lib=SGLT2Inh, ds=farxiga);
%merge_np(lib=SGLT2Inh, ds=jardiance);
%merge_np(lib=SGLT2Inh, ds=steglatro);
%merge_np(lib=SGLT2Inh, ds=brenzavvy);
%merge_np(lib=GLP1Agon, ds=liraglutide);
%merge_np(lib=GLP1Agon, ds=dulaglutide);
%merge_np(lib=GLP1Agon, ds=semaglutide);
%merge_np(lib=GLP1Agon, ds=tirzepatide);
%merge_np(lib=GLP1Agon, ds=victoza);
%merge_np(lib=GLP1Agon, ds=trulicity);
%merge_np(lib=GLP1Agon, ds=ozempic);
%merge_np(lib=GLP1Agon, ds=rybelsus);
%merge_np(lib=GLP1Agon, ds=mounjaro);
%merge_np(lib=InsulinA, ds=humalog);
%merge_np(lib=InsulinA, ds=novolog);
%merge_np(lib=InsulinA, ds=apidra);
%merge_np(lib=InsulinA, ds=lantus);
%merge_np(lib=InsulinA, ds=basaglar);
%merge_np(lib=InsulinA, ds=levemir);
%merge_np(lib=InsulinA, ds=tresiba);
%merge_np(lib=InsulinA, ds=humulin_n);
%merge_np(lib=InsulinA, ds=humulin_r);
%merge_np(lib=InsulinA, ds=novolin_n);
%merge_np(lib=InsulinA, ds=novolin_r);
%merge_np(lib=InsulinA, ds=insulin_lispro);
%merge_np(lib=InsulinA, ds=insulin_aspart);
%merge_np(lib=InsulinA, ds=insulin_glulisine);
%merge_np(lib=InsulinA, ds=insulin_glargine);
%merge_np(lib=InsulinA, ds=insulin_detemir);
%merge_np(lib=InsulinA, ds=insulin_degludec);
%merge_np(lib=InsulinA, ds=nph_insulin);
%merge_np(lib=InsulinA, ds=regular_insulin);
