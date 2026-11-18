libname data  'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS';
libname summary  'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\datasets';
libname Biguiani 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\Biguianides';
libname Sulfonyl 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\Sulfonylureas';
libname TZDs    'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\TZDs';
libname InsulinA 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\InsulinAnalogs';
libname GLP1Agon 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\GLP1Agonists';
libname DPP4Inhi 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\DPP4Inhibitors';
libname SGLT2Inh 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\SGLT2Inhibitors';

data Biguiani.metformin;
    set data.combined;
    if prxmatch('/(?i).*Metformin.*/', Product_Name);
run;

data Biguiani.metformin_xr;
    set data.combined;
    if prxmatch('/(?i).*Metformin XR.*/', Product_Name);
run;

data Biguiani.glucophage;
    set data.combined;
    if prxmatch('/(?i).*Glucophage.*/', Product_Name);
run;

data Biguiani.fortamet;
    set data.combined;
    if prxmatch('/(?i).*Fortamet.*/', Product_Name);
run;

data Biguiani.glumetza;
    set data.combined;
    if prxmatch('/(?i).*Glumetza.*/', Product_Name);
run;
data Sulfonyl.glipizide;
    set data.combined;
    if prxmatch('/(?i).*Glipizide.*/', Product_Name);
run;

data Sulfonyl.glipizide_xl;
    set data.combined;
    if prxmatch('/(?i).*Glipizide XL.*/', Product_Name);
run;

data Sulfonyl.glimepiride;
    set data.combined;
    if prxmatch('/(?i).*Glimepiride.*/', Product_Name);
run;

data Sulfonyl.glyburide;
    set data.combined;
    if prxmatch('/(?i).*Glyburide.*/', Product_Name);
run;

data Sulfonyl.glucotrol;
    set data.combined;
    if prxmatch('/(?i).*Glucotrol.*/', Product_Name);
run;

data Sulfonyl.amaryl;
    set data.combined;
    if prxmatch('/(?i).*Amaryl.*/', Product_Name);
run;

data Sulfonyl.diabeta;
    set data.combined;
    if prxmatch('/(?i).*Diabeta.*/', Product_Name);
run;

data Sulfonyl.glynase;
    set data.combined;
    if prxmatch('/(?i).*Glynase.*/', Product_Name);
run;
data TZDs.pioglitazone;
    set data.combined;
    if prxmatch('/(?i).*Pioglitazone.*/', Product_Name);
run;

data TZDs.rosiglitazone;
    set data.combined;
    if prxmatch('/(?i).*Rosiglitazone.*/', Product_Name);
run;

data TZDs.actos;
    set data.combined;
    if prxmatch('/(?i).*Actos.*/', Product_Name);
run;

data TZDs.avandia;
    set data.combined;
    if prxmatch('/(?i).*Avandia.*/', Product_Name);
run;
data DPP4Inhi.sitagliptin;
    set data.combined;
    if prxmatch('/(?i).*Sitagliptin.*/', Product_Name);
run;

data DPP4Inhi.saxagliptin;
    set data.combined;
    if prxmatch('/(?i).*Saxagliptin.*/', Product_Name);
run;

data DPP4Inhi.linagliptin;
    set data.combined;
    if prxmatch('/(?i).*Linagliptin.*/', Product_Name);
run;

data DPP4Inhi.alogliptin;
    set data.combined;
    if prxmatch('/(?i).*Alogliptin.*/', Product_Name);
run;

data DPP4Inhi.januvia;
    set data.combined;
    if prxmatch('/(?i).*Januvia.*/', Product_Name);
run;

data DPP4Inhi.onglyza;
    set data.combined;
    if prxmatch('/(?i).*Onglyza.*/', Product_Name);
run;

data DPP4Inhi.tradjenta;
    set data.combined;
    if prxmatch('/(?i).*Tradjenta.*/', Product_Name);
run;

data DPP4Inhi.nesina;
    set data.combined;
    if prxmatch('/(?i).*Nesina.*/', Product_Name);
run;
data SGLT2Inh.canagliflozin;
    set data.combined;
    if prxmatch('/(?i).*Canagliflozin.*/', Product_Name);
run;

data SGLT2Inh.dapagliflozin;
    set data.combined;
    if prxmatch('/(?i).*Dapagliflozin.*/', Product_Name);
run;

data SGLT2Inh.empagliflozin;
    set data.combined;
    if prxmatch('/(?i).*Empagliflozin.*/', Product_Name);
run;

data SGLT2Inh.ertugliflozin;
    set data.combined;
    if prxmatch('/(?i).*Ertugliflozin.*/', Product_Name);
run;

data SGLT2Inh.bexagliflozin;
    set data.combined;
    if prxmatch('/(?i).*Bexagliflozin.*/', Product_Name);
run;

data SGLT2Inh.invokana;
    set data.combined;
    if prxmatch('/(?i).*Invokana.*/', Product_Name);
run;

data SGLT2Inh.farxiga;
    set data.combined;
    if prxmatch('/(?i).*Farxiga.*/', Product_Name);
run;

data SGLT2Inh.jardiance;
    set data.combined;
    if prxmatch('/(?i).*Jardiance.*/', Product_Name);
run;

data SGLT2Inh.steglatro;
    set data.combined;
    if prxmatch('/(?i).*Steglatro.*/', Product_Name);
run;

data SGLT2Inh.brenzavvy;
    set data.combined;
    if prxmatch('/(?i).*Brenzavvy.*/', Product_Name);
run;
data GLP1Agon.liraglutide;
    set data.combined;
    if prxmatch('/(?i).*Liraglutide.*/', Product_Name);
run;

data GLP1Agon.dulaglutide;
    set data.combined;
    if prxmatch('/(?i).*Dulaglutide.*/', Product_Name);
run;

data GLP1Agon.semaglutide;
    set data.combined;
    if prxmatch('/(?i).*Semaglutide.*/', Product_Name);
run;

data GLP1Agon.tirzepatide;
    set data.combined;
    if prxmatch('/(?i).*Tirzepatide.*/', Product_Name);
run;

data GLP1Agon.victoza;
    set data.combined;
    if prxmatch('/(?i).*Victoza.*/', Product_Name);
run;

data GLP1Agon.trulicity;
    set data.combined;
    if prxmatch('/(?i).*Trulicity.*/', Product_Name);
run;

data GLP1Agon.ozempic;
    set data.combined;
    if prxmatch('/(?i).*Ozempic.*/', Product_Name);
run;

data GLP1Agon.rybelsus;
    set data.combined;
    if prxmatch('/(?i).*Rybelsus.*/', Product_Name);
run;

data GLP1Agon.mounjaro;
    set data.combined;
    if prxmatch('/(?i).*Mounjaro.*/', Product_Name);
run;
data InsulinA.humalog;
    set data.combined;
    if prxmatch('/(?i).*Humalog.*/', Product_Name);
run;

data InsulinA.novolog;
    set data.combined;
    if prxmatch('/(?i).*NovoLog.*/', Product_Name);
run;

data InsulinA.apidra;
    set data.combined;
    if prxmatch('/(?i).*Apidra.*/', Product_Name);
run;

data InsulinA.lantus;
    set data.combined;
    if prxmatch('/(?i).*Lantus.*/', Product_Name);
run;

data InsulinA.basaglar;
    set data.combined;
    if prxmatch('/(?i).*Basaglar.*/', Product_Name);
run;

data InsulinA.levemir;
    set data.combined;
    if prxmatch('/(?i).*Levemir.*/', Product_Name);
run;

data InsulinA.tresiba;
    set data.combined;
    if prxmatch('/(?i).*Tresiba.*/', Product_Name);
run;

data InsulinA.humulin_n;
    set data.combined;
    if prxmatch('/(?i).*Humulin N.*/', Product_Name);
run;

data InsulinA.humulin_r;
    set data.combined;
    if prxmatch('/(?i).*Humulin R.*/', Product_Name);
run;

data InsulinA.novolin_n;
    set data.combined;
    if prxmatch('/(?i).*Novolin N.*/', Product_Name);
run;

data InsulinA.novolin_r;
    set data.combined;
    if prxmatch('/(?i).*Novolin R.*/', Product_Name);
run;

data InsulinA.insulin_lispro;
    set data.combined;
    if prxmatch('/(?i).*Insulin lispro.*/', Product_Name);
run;

data InsulinA.insulin_aspart;
    set data.combined;
    if prxmatch('/(?i).*Insulin aspart.*/', Product_Name);
run;

data InsulinA.insulin_glulisine;
    set data.combined;
    if prxmatch('/(?i).*Insulin glulisine.*/', Product_Name);
run;

data InsulinA.insulin_glargine;
    set data.combined;
    if prxmatch('/(?i).*Insulin glargine.*/', Product_Name);
run;

data InsulinA.insulin_detemir;
    set data.combined;
    if prxmatch('/(?i).*Insulin detemir.*/', Product_Name);
run;

data InsulinA.insulin_degludec;
    set data.combined;
    if prxmatch('/(?i).*Insulin degludec.*/', Product_Name);
run;

data InsulinA.nph_insulin;
    set data.combined;
    if prxmatch('/(?i).*NPH insulin.*/', Product_Name);
run;

data InsulinA.regular_insulin;
    set data.combined;
    if prxmatch('/(?i).*Regular insulin.*/', Product_Name);
run;
