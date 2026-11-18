libname data  'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS';
libname summary  'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\datasets';
libname Biguiani 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\Biguianides';
libname Sulfonyl 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\Sulfonylureas';
libname TZDs    'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\TZDs';
libname InsulinA 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\InsulinAnalogs';
libname GLP1Agon 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\GLP1Agonists';
libname DPP4Inhi 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\GLP1Agonists';
libname SGLT2Inh 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\GLP1Agonists';
libname GLP1Agon 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\GLP1Agonists';

proc sort data=Biguiani.metformin_xr; by state year; run;
data Biguiani.metformin_xr_fp;
    merge Biguiani.metformin_xr (in=a)
          data.npfpaset         (in=b);
    by state year;
    if a;
run;

proc sort data=Biguiani.metformin; by state year; run;
data Biguiani.metformin_fp;
    merge Biguiani.metformin (in=a)
          data.npfpaset       (in=b);
    by state year;
    if a;
run;

proc sort data=Biguiani.glucophage; by state year; run;
data Biguiani.glucophage_fp;
    merge Biguiani.glucophage (in=a)
          data.npfpaset       (in=b);
    by state year;
    if a;
run;

proc sort data=Biguiani.fortamet; by state year; run;
data Biguiani.fortamet_fp;
    merge Biguiani.fortamet (in=a)
          data.npfpaset     (in=b);
    by state year;
    if a;
run;

proc sort data=Biguiani.glumetza; by state year; run;
data Biguiani.glumetza_fp;
    merge Biguiani.glumetza (in=a)
          data.npfpaset     (in=b);
    by state year;
    if a;
run;


proc sort data=Sulfonyl.glipizide; by state year; run;
data Sulfonyl.glipizide_fp;
    merge Sulfonyl.glipizide (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=Sulfonyl.glipizide_xl; by state year; run;
data Sulfonyl.glipizide_xl_fp;
    merge Sulfonyl.glipizide_xl (in=a)
          data.npfpaset         (in=b);
    by state year;
    if a;
run;

proc sort data=Sulfonyl.glimepiride; by state year; run;
data Sulfonyl.glimepiride_fp;
    merge Sulfonyl.glimepiride (in=a)
          data.npfpaset        (in=b);
    by state year;
    if a;
run;

proc sort data=Sulfonyl.glyburide; by state year; run;
data Sulfonyl.glyburide_fp;
    merge Sulfonyl.glyburide (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=Sulfonyl.glucotrol; by state year; run;
data Sulfonyl.glucotrol_fp;
    merge Sulfonyl.glucotrol (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=Sulfonyl.amaryl; by state year; run;
data Sulfonyl.amaryl_fp;
    merge Sulfonyl.amaryl (in=a)
          data.npfpaset   (in=b);
    by state year;
    if a;
run;

proc sort data=Sulfonyl.diabeta; by state year; run;
data Sulfonyl.diabeta_fp;
    merge Sulfonyl.diabeta (in=a)
          data.npfpaset    (in=b);
    by state year;
    if a;
run;

proc sort data=Sulfonyl.glynase; by state year; run;
data Sulfonyl.glynase_fp;
    merge Sulfonyl.glynase (in=a)
          data.npfpaset    (in=b);
    by state year;
    if a;
run;


proc sort data=TZDs.pioglitazone; by state year; run;
data TZDs.pioglitazone_fp;
    merge TZDs.pioglitazone (in=a)
          data.npfpaset     (in=b);
    by state year;
    if a;
run;

proc sort data=TZDs.rosiglitazone; by state year; run;
data TZDs.rosiglitazone_fp;
    merge TZDs.rosiglitazone (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=TZDs.actos; by state year; run;
data TZDs.actos_fp;
    merge TZDs.actos (in=a)
          data.npfpaset (in=b);
    by state year;
    if a;
run;

proc sort data=TZDs.avandia; by state year; run;
data TZDs.avandia_fp;
    merge TZDs.avandia (in=a)
          data.npfpaset (in=b);
    by state year;
    if a;
run;

proc sort data=DPP4Inhi.sitagliptin; by state year; run;
data DPP4Inhi.sitagliptin_fp;
    merge DPP4Inhi.sitagliptin (in=a)
          data.npfpaset        (in=b);
    by state year;
    if a;
run;

proc sort data=DPP4Inhi.saxagliptin; by state year; run;
data DPP4Inhi.saxagliptin_fp;
    merge DPP4Inhi.saxagliptin (in=a)
          data.npfpaset        (in=b);
    by state year;
    if a;
run;

proc sort data=DPP4Inhi.linagliptin; by state year; run;
data DPP4Inhi.linagliptin_fp;
    merge DPP4Inhi.linagliptin (in=a)
          data.npfpaset        (in=b);
    by state year;
    if a;
run;

proc sort data=DPP4Inhi.alogliptin; by state year; run;
data DPP4Inhi.alogliptin_fp;
    merge DPP4Inhi.alogliptin (in=a)
          data.npfpaset       (in=b);
    by state year;
    if a;
run;

proc sort data=DPP4Inhi.januvia; by state year; run;
data DPP4Inhi.januvia_fp;
    merge DPP4Inhi.januvia (in=a)
          data.npfpaset    (in=b);
    by state year;
    if a;
run;

proc sort data=DPP4Inhi.onglyza; by state year; run;
data DPP4Inhi.onglyza_fp;
    merge DPP4Inhi.onglyza (in=a)
          data.npfpaset    (in=b);
    by state year;
    if a;
run;

proc sort data=DPP4Inhi.tradjenta; by state year; run;
data DPP4Inhi.tradjenta_fp;
    merge DPP4Inhi.tradjenta (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=DPP4Inhi.nesina; by state year; run;
data DPP4Inhi.nesina_fp;
    merge DPP4Inhi.nesina (in=a)
          data.npfpaset   (in=b);
    by state year;
    if a;
run;


proc sort data=SGLT2Inh.canagliflozin; by state year; run;
data SGLT2Inh.canagliflozin_fp;
    merge SGLT2Inh.canagliflozin (in=a)
          data.npfpaset          (in=b);
    by state year;
    if a;
run;

proc sort data=SGLT2Inh.dapagliflozin; by state year; run;
data SGLT2Inh.dapagliflozin_fp;
    merge SGLT2Inh.dapagliflozin (in=a)
          data.npfpaset          (in=b);
    by state year;
    if a;
run;

proc sort data=SGLT2Inh.empagliflozin; by state year; run;
data SGLT2Inh.empagliflozin_fp;
    merge SGLT2Inh.empagliflozin (in=a)
          data.npfpaset          (in=b);
    by state year;
    if a;
run;

proc sort data=SGLT2Inh.ertugliflozin; by state year; run;
data SGLT2Inh.ertugliflozin_fp;
    merge SGLT2Inh.ertugliflozin (in=a)
          data.npfpaset          (in=b);
    by state year;
    if a;
run;

proc sort data=SGLT2Inh.bexagliflozin; by state year; run;
data SGLT2Inh.bexagliflozin_fp;
    merge SGLT2Inh.bexagliflozin (in=a)
          data.npfpaset          (in=b);
    by state year;
    if a;
run;

proc sort data=SGLT2Inh.invokana; by state year; run;
data SGLT2Inh.invokana_fp;
    merge SGLT2Inh.invokana (in=a)
          data.npfpaset     (in=b);
    by state year;
    if a;
run;

proc sort data=SGLT2Inh.farxiga; by state year; run;
data SGLT2Inh.farxiga_fp;
    merge SGLT2Inh.farxiga (in=a)
          data.npfpaset    (in=b);
    by state year;
    if a;
run;

proc sort data=SGLT2Inh.jardiance; by state year; run;
data SGLT2Inh.jardiance_fp;
    merge SGLT2Inh.jardiance (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=SGLT2Inh.steglatro; by state year; run;
data SGLT2Inh.steglatro_fp;
    merge SGLT2Inh.steglatro (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=SGLT2Inh.brenzavvy; by state year; run;
data SGLT2Inh.brenzavvy_fp;
    merge SGLT2Inh.brenzavvy (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;


proc sort data=GLP1Agon.liraglutide; by state year; run;
data GLP1Agon.liraglutide_fp;
    merge GLP1Agon.liraglutide (in=a)
          data.npfpaset        (in=b);
    by state year;
    if a;
run;

proc sort data=GLP1Agon.dulaglutide; by state year; run;
data GLP1Agon.dulaglutide_fp;
    merge GLP1Agon.dulaglutide (in=a)
          data.npfpaset        (in=b);
    by state year;
    if a;
run;

proc sort data=GLP1Agon.semaglutide; by state year; run;
data GLP1Agon.semaglutide_fp;
    merge GLP1Agon.semaglutide (in=a)
          data.npfpaset        (in=b);
    by state year;
    if a;
run;

proc sort data=GLP1Agon.tirzepatide; by state year; run;
data GLP1Agon.tirzepatide_fp;
    merge GLP1Agon.tirzepatide (in=a)
          data.npfpaset        (in=b);
    by state year;
    if a;
run;

proc sort data=GLP1Agon.victoza; by state year; run;
data GLP1Agon.victoza_fp;
    merge GLP1Agon.victoza (in=a)
          data.npfpaset    (in=b);
    by state year;
    if a;
run;

proc sort data=GLP1Agon.trulicity; by state year; run;
data GLP1Agon.trulicity_fp;
    merge GLP1Agon.trulicity (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=GLP1Agon.ozempic; by state year; run;
data GLP1Agon.ozempic_fp;
    merge GLP1Agon.ozempic (in=a)
          data.npfpaset    (in=b);
    by state year;
    if a;
run;

proc sort data=GLP1Agon.rybelsus; by state year; run;
data GLP1Agon.rybelsus_fp;
    merge GLP1Agon.rybelsus (in=a)
          data.npfpaset     (in=b);
    by state year;
    if a;
run;

proc sort data=GLP1Agon.mounjaro; by state year; run;
data GLP1Agon.mounjaro_fp;
    merge GLP1Agon.mounjaro (in=a)
          data.npfpaset     (in=b);
    by state year;
    if a;
run;


proc sort data=InsulinA.humalog; by state year; run;
data InsulinA.humalog_fp;
    merge InsulinA.humalog (in=a)
          data.npfpaset    (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.novolog; by state year; run;
data InsulinA.novolog_fp;
    merge InsulinA.novolog (in=a)
          data.npfpaset    (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.apidra; by state year; run;
data InsulinA.apidra_fp;
    merge InsulinA.apidra (in=a)
          data.npfpaset   (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.lantus; by state year; run;
data InsulinA.lantus_fp;
    merge InsulinA.lantus (in=a)
          data.npfpaset   (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.basaglar; by state year; run;
data InsulinA.basaglar_fp;
    merge InsulinA.basaglar (in=a)
          data.npfpaset     (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.levemir; by state year; run;
data InsulinA.levemir_fp;
    merge InsulinA.levemir (in=a)
          data.npfpaset    (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.tresiba; by state year; run;
data InsulinA.tresiba_fp;
    merge InsulinA.tresiba (in=a)
          data.npfpaset    (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.humulin_n; by state year; run;
data InsulinA.humulin_n_fp;
    merge InsulinA.humulin_n (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.humulin_r; by state year; run;
data InsulinA.humulin_r_fp;
    merge InsulinA.humulin_r (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.novolin_n; by state year; run;
data InsulinA.novolin_n_fp;
    merge InsulinA.novolin_n (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.novolin_r; by state year; run;
data InsulinA.novolin_r_fp;
    merge InsulinA.novolin_r (in=a)
          data.npfpaset      (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.insulin_lispro; by state year; run;
data InsulinA.insulin_lispro_fp;
    merge InsulinA.insulin_lispro (in=a)
          data.npfpaset           (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.insulin_aspart; by state year; run;
data InsulinA.insulin_aspart_fp;
    merge InsulinA.insulin_aspart (in=a)
          data.npfpaset           (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.insulin_glulisine; by state year; run;
data InsulinA.insulin_glulisine_fp;
    merge InsulinA.insulin_glulisine (in=a)
          data.npfpaset              (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.insulin_glargine; by state year; run;
data InsulinA.insulin_glargine_fp;
    merge InsulinA.insulin_glargine (in=a)
          data.npfpaset             (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.insulin_detemir; by state year; run;
data InsulinA.insulin_detemir_fp;
    merge InsulinA.insulin_detemir (in=a)
          data.npfpaset            (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.insulin_degludec; by state year; run;
data InsulinA.insulin_degludec_fp;
    merge InsulinA.insulin_degludec (in=a)
          data.npfpaset             (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.nph_insulin; by state year; run;
data InsulinA.nph_insulin_fp;
    merge InsulinA.nph_insulin (in=a)
          data.npfpaset        (in=b);
    by state year;
    if a;
run;

proc sort data=InsulinA.regular_insulin; by state year; run;
data InsulinA.regular_insulin_fp;
    merge InsulinA.regular_insulin (in=a)
          data.npfpaset            (in=b);
    by state year;
    if a;
run;
