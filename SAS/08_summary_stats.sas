libname summary 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\datasets';
libname Biguanid 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\Biguanide';
libname Sulfonyl 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\Sulfonylureas';
libname TZDs 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\TZDs';
libname InsulinA 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\InsulinAnalogs';
libname GLP1Agon 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS\GLP1Agonists';


/* ===========================
   BIGUANIDE
   =========================== */

proc means data=Biguanid.metformin_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.metformin_by_year;
run;

proc means data=Biguanid.metformin_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.metformin_by_state;
run;


/* ===========================
   SULFONYLUREAS
   =========================== */

proc means data=Sulfonyl.glipizide_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.glipizide_by_year;
run;

proc means data=Sulfonyl.glipizide_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.glipizide_by_state;
run;


proc means data=Sulfonyl.glimepiride_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.glimepiride_by_year;
run;

proc means data=Sulfonyl.glimepiride_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.glimepiride_by_state;
run;


proc means data=Sulfonyl.glyburide_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.glyburide_by_year;
run;

proc means data=Sulfonyl.glyburide_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.glyburide_by_state;
run;


/* ===========================
   TZDs
   =========================== */

proc means data=TZDs.pioglitazone_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.pioglitazone_by_year;
run;

proc means data=TZDs.pioglitazone_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.pioglitazone_by_state;
run;


proc means data=TZDs.rosiglitazone_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.rosiglitazone_by_year;
run;

proc means data=TZDs.rosiglitazone_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.rosiglitazone_by_state;
run;


/* ===========================
   INSULIN & ANALOGS
   =========================== */

proc means data=InsulinA.insulin_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.insulin_by_year;
run;

proc means data=InsulinA.insulin_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.insulin_by_state;
run;


proc means data=InsulinA.lantus_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.lantus_by_year;
run;

proc means data=InsulinA.lantus_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.lantus_by_state;
run;


proc means data=InsulinA.levemir_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.levemir_by_year;
run;

proc means data=InsulinA.levemir_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.levemir_by_state;
run;


proc means data=InsulinA.humalog_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.humalog_by_year;
run;

proc means data=InsulinA.humalog_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.humalog_by_state;
run;


proc means data=InsulinA.novolog_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.novolog_by_year;
run;

proc means data=InsulinA.novolog_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.novolog_by_state;
run;


proc means data=InsulinA.toujeo_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.toujeo_by_year;
run;

proc means data=InsulinA.toujeo_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.toujeo_by_state;
run;


proc means data=InsulinA.afrezza_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.afrezza_by_year;
run;

proc means data=InsulinA.afrezza_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.afrezza_by_state;
run;


/* ===========================
   GLP-1 AGONISTS
   =========================== */

proc means data=GLP1Agon.semaglutide_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.semaglutide_by_year;
run;

proc means data=GLP1Agon.semaglutide_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.semaglutide_by_state;
run;


proc means data=GLP1Agon.ozempic_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.ozempic_by_year;
run;

proc means data=GLP1Agon.ozempic_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.ozempic_by_state;
run;


proc means data=GLP1Agon.wegovy_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.wegovy_by_year;
run;

proc means data=GLP1Agon.wegovy_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.wegovy_by_state;
run;


proc means data=GLP1Agon.rybelsus_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.rybelsus_by_year;
run;

proc means data=GLP1Agon.rybelsus_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.rybelsus_by_state;
run;


proc means data=GLP1Agon.tirzepatide_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.tirzepatide_by_year;
run;

proc means data=GLP1Agon.tirzepatide_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.tirzepatide_by_state;
run;


proc means data=GLP1Agon.mounjaro_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.mounjaro_by_year;
run;

proc means data=GLP1Agon.mounjaro_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.mounjaro_by_state;
run;


proc means data=GLP1Agon.zepbound_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.zepbound_by_year;
run;

proc means data=GLP1Agon.zepbound_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.zepbound_by_state;
run;


proc means data=GLP1Agon.dulaglutide_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.dulaglutide_by_year;
run;

proc means data=GLP1Agon.dulaglutide_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.dulaglutide_by_state;
run;


proc means data=GLP1Agon.trulicity_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.trulicity_by_year;
run;

proc means data=GLP1Agon.trulicity_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.trulicity_by_state;
run;


proc means data=GLP1Agon.liraglutide_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.liraglutide_by_year;
run;

proc means data=GLP1Agon.liraglutide_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.liraglutide_by_state;
run;


proc means data=GLP1Agon.victoza_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.victoza_by_year;
run;

proc means data=GLP1Agon.victoza_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.victoza_by_state;
run;


proc means data=GLP1Agon.saxenda_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.saxenda_by_year;
run;

proc means data=GLP1Agon.saxenda_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.saxenda_by_state;
run;


proc means data=GLP1Agon.exenatide_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.exenatide_by_year;
run;

proc means data=GLP1Agon.exenatide_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.exenatide_by_state;
run;


proc means data=GLP1Agon.byetta_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.byetta_by_year;
run;

proc means data=GLP1Agon.byetta_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.byetta_by_state;
run;


proc means data=GLP1Agon.bydureon_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.bydureon_by_year;
run;

proc means data=GLP1Agon.bydureon_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.bydureon_by_state;
run;


proc means data=GLP1Agon.lixisenatide_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.lixisenatide_by_year;
run;

proc means data=GLP1Agon.lixisenatide_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.lixisenatide_by_state;
run;


proc means data=GLP1Agon.adlyxin_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.adlyxin_by_year;
run;

proc means data=GLP1Agon.adlyxin_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.adlyxin_by_state;
run;


proc means data=GLP1Agon.soliqua_subset nway n mean std min max;
    class Year;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.soliqua_by_year;
run;

proc means data=GLP1Agon.soliqua_subset nway n mean std min max;
    class State;
    var Units_Reimbursed Number_of_Prescriptions Total_Amount_Reimbursed;
    output out=summary.soliqua_by_state;
run;
