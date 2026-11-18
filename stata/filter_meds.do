/*** Cole Carroll
@ Ball State University
August 2025
***/

local FDANameCorrect0 "00002010102"

local FDANameCorrect1 "00002010102" 
local FDANameCorrect2 "00002010102" 

/***
You can use multiple medications and mutliple states, just move around the comments
***/
local StNameCorrect2 "IN"
local StNameCorrect1 "IN"




local StNameCorrect0 "IN"

use Data_Folder\Total1991to1996.dta, clear

keep if inlist(state, "`StNameCorrect0'", "`StNameCorrect1'", "`StNameCorrect2'")
keep if inlist(ndc, "`FDANameCorrect0'", "`FDANameCorrect1'", "`FDANameCorrect2'")
save Data_Folder\Temp_place\minichunk0.dta, replace

use Data_Folder\Total1997to2003.dta, clear
keep if inlist(state, "`StNameCorrect0'", "`StNameCorrect1'", "`StNameCorrect2'")
keep if inlist(ndc, "`FDANameCorrect0'", "`FDANameCorrect1'", "`FDANameCorrect2'")
save Data_Folder\Temp_place\minichunk1, replace

use Data_Folder\Total2004to2010.dta, clear
keep if inlist(state, "`StNameCorrect0'", "`StNameCorrect1'", "`StNameCorrect2'")
keep if inlist(ndc, "`FDANameCorrect0'", "`FDANameCorrect1'", "`FDANameCorrect2'")
save Data_Folder\Temp_place\minichunk2, replace


use Data_Folder\Total2011to2017.dta, clear
keep if inlist(state, "`StNameCorrect0'", "`StNameCorrect1'", "`StNameCorrect2'")
keep if inlist(ndc, "`FDANameCorrect0'", "`FDANameCorrect1'", "`FDANameCorrect2'")
save Data_Folder\Temp_place\minichunk3, replace

use Data_Folder\Total2018to2024.dta, clear
keep if inlist(state, "`StNameCorrect0'", "`StNameCorrect1'", "`StNameCorrect2'")
keep if inlist(ndc, "`FDANameCorrect0'", "`FDANameCorrect1'", "`FDANameCorrect2'")
save Data_Folder\Temp_place\minichunk4, replace

use Data_Folder\Temp_place\minichunk0, clear
append using Data_Folder\Temp_place\minichunk1
append using Data_Folder\Temp_place\minichunk2
append using Data_Folder\Temp_place\minichunk3
append using Data_Folder\Temp_place\minichunk4

save Output_Folder\FilteredFor_`FDANameCorrect0'_`FDANameCorrect1'_`FDANameCorrect2'_`StNameCorrect0'_`StNameCorrect1'_`StNameCorrect2', replace