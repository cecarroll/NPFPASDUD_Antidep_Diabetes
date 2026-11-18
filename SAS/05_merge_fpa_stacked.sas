libname SDUDSAS "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS";
    
run;


proc sort data=SDUDSAS.combined; 
    by State Year; 
run;

proc sort data=SDUDSAS.npfpaset; 
    by State Year; 
run;

data SDUDSAS.NPCombined;
    merge SDUDSAS.combined (in=a)
          SDUDSAS.npfpaset (in=b);
    by State Year;
run;

proc contents data = SDUDSAS.NPCombined;
run;

