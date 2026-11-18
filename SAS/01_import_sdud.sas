libname SDUDDATA 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs'; run;

libname SDUDSAS 'C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\SDUDSAS'; run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData1991.csv'
            out=SDUDSAS.sdud1991
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc contents data = SDUDSAS.sdud1991; run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData1992.csv'
            out=SDUDSAS.sdud1992
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData1993.csv'
            out=SDUDSAS.sdud1993
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData1994.csv'
            out=SDUDSAS.sdud1994
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData1995.csv'
            out=SDUDSAS.sdud1995
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData1996.csv'
            out=SDUDSAS.sdud1996
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData1997.csv'
            out=SDUDSAS.sdud1997
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData1998.csv'
            out=SDUDSAS.sdud1998
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData1999.csv'
            out=SDUDSAS.sdud1999
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2000.csv'
            out=SDUDSAS.sdud2000
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2001.csv'
            out=SDUDSAS.sdud2001
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2002.csv'
            out=SDUDSAS.sdud2002
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2003.csv'
            out=SDUDSAS.sdud2003
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2004.csv'
            out=SDUDSAS.sdud2004
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2005.csv'
            out=SDUDSAS.sdud2005
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2006.csv'
            out=SDUDSAS.sdud2006
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2007.csv'
            out=SDUDSAS.sdud2007
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2008.csv'
            out=SDUDSAS.sdud2008
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2009.csv'
            out=SDUDSAS.sdud2009
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;
proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2010.csv'
            out=SDUDSAS.sdud2010
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2011.csv'
            out=SDUDSAS.sdud2011
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2012.csv'
            out=SDUDSAS.sdud2012
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;


proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2013.csv'
            out=SDUDSAS.sdud2013
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2014.csv'
            out=SDUDSAS.sdud2014
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2015.csv'
            out=SDUDSAS.sdud2015
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2016.csv'
            out=SDUDSAS.sdud2016
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2017.csv'
            out=SDUDSAS.sdud2017
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2018.csv'
            out=SDUDSAS.sdud2018
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2019.csv'
            out=SDUDSAS.sdud2019
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2020.csv'
            out=SDUDSAS.sdud2020
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2021.csv'
            out=SDUDSAS.sdud2021
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2022.csv'
            out=SDUDSAS.sdud2022
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2023.csv'
            out=SDUDSAS.sdud2023
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

proc import datafile='C:\Users\CECARROLL2\OneDrive - Ball State University\Documents\NPProject\Original_CSVs\StateDrugUtilizationData2024.csv'
            out=SDUDSAS.sdud2024
            dbms=csv
            replace;
			guessingrows=max;
   getnames=yes;
run;

