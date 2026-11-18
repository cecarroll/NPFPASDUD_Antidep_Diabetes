libname NPData "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject"; run;
libname SDUDSAS "C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS"; run; 

proc import datafile="C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\NPFPASet.xlsx"
    out=SDUDSAS.NPFPASET
    dbms=xlsx
    replace;
    sheet="Sheet1";
    getnames=yes;
run;
