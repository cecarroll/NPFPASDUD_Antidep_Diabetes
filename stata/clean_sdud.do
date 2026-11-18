//Cole Carroll @ Ball State University 2025

//1991###############################

use "SDUDDTA\SDUD1991.dta" 
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD1991clean.dta", replace


//1992##############################

use "SDUDDTA\SDUD1992.dta" 
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD1992clean.dta", replace

//1993#############################

use "SDUDDTA\SDUD1993.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD1993clean.dta", replace

//1994#############################

use "SDUDDTA\SDUD1994.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD1994clean.dta", replace

//1995#############################

use "SDUDDTA\SDUD1995.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD1995clean.dta", replace

//1996#############################

use "SDUDDTA\SDUD1996.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD1996clean.dta", replace

//1997#############################

use "SDUDDTA\SDUD1997.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD1997clean.dta", replace

//1998#############################

use "SDUDDTA\SDUD1998.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD1998clean.dta", replace

//1999#############################

use "SDUDDTA\SDUD1999.dta" 
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD1999clean.dta", replace

//2000#############################

use "SDUDDTA\SDUD2000.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2000clean.dta", replace

//2001#############################

use "SDUDDTA\SDUD2001.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2001clean.dta", replace

//2002#############################

use "SDUDDTA\SDUD2002.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2002clean.dta", replace

//2003#############################

use "SDUDDTA\SDUD2003.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2003clean.dta", replace

//2004#############################

use "SDUDDTA\SDUD2004.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2004clean.dta", replace

//2005#############################

use "SDUDDTA\SDUD2005.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2005clean.dta", replace

//2006#############################

use "SDUDDTA\SDUD2006.dta"
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2006clean.dta", replace

//2007#############################

use "SDUDDTA\SDUD2007.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2007clean.dta", replace

//2008#############################

use "SDUDDTA\SDUD2008.dta" 
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2008clean.dta", replace

//2009#############################

use "SDUDDTA\SDUD2009.dta" 
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2009clean.dta", replace

//2010#############################

use "SDUDDTA\SDUD2010.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2010clean.dta", replace

//2011#############################

use "SDUDDTA\SDUD2011.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2011clean.dta", replace

//2012#############################

use "SDUDDTA\SDUD2012.dta" 
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2012clean.dta", replace

//2013#############################

use "SDUDDTA\SDUD2013.dta" 
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2013clean.dta", replace

//2014#############################

use "SDUDDTA\SDUD2014.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2014clean.dta", replace

//2015#############################

use "SDUDDTA\SDUD2015.dta" 
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2015clean.dta", replace

//2016#############################

use "SDUDDTA\SDUD2016.dta" 
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2016clean.dta", replace

//2017#############################

use "SDUDDTA\SDUD2017.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2017clean.dta", replace

//2018#############################

use "SDUDDTA\SDUD2018.dta" 
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2018clean.dta", replace

//2019#############################

use "SDUDDTA\SDUD2019.dta" 
 
replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2019clean.dta", replace

//2020#############################

use "SDUDDTA\SDUD2020.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2020clean.dta", replace

//2021#############################

use "SDUDDTA\SDUD2021.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2021clean.dta", replace

//2022#############################

use "SDUDDTA\SDUD2022.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2022clean.dta", replace

//2023#############################

use "SDUDDTA\SDUD2023.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2023clean.dta", replace

//2024#############################

use "SDUDDTA\SDUD2024.dta" 

replace utilizationtype = "1" if utilizationtype == "MCOU" //Converting utilizationtype and suppressionused to booleans 
replace utilizationtype = "0" if utilizationtype == "FFSU"
destring(utilizationtype), replace 

replace suppressionused = "0" if suppressionused == "false"
replace suppressionused = "1" if suppressionused == "true"
destring(suppressionused), replace

/*
Including these lines would save space, but it is not worth it given the lack of information that we have on the drugs. 

drop labelercode
drop productcode

tostring(packagesize), replace

I honestly don't know where this came from but I don't remember where I needed it and I'm too afraid to delete it.
destring(ndc), gen(ndc1)
list ndc if missing(real(productcode))


Here is a key for what the new binary space-saving variables mean.

suppression for privacy used = 1 
suppression for privacy not used = 0 

MCOU = 1
FFSU = 0
*/
label variable suppressionused "Suppression Used: 1 indicates used" // Labeling the boolean variables that need a key
label variable utilizationtype "Utilization Type: 1 indicates MCOU, 0 indicates FFSU"

//There's surely a reason I'm casting a string of length 11 to be a string of length 11. FAFO if you want. 
tostring(ndc), replace format(%011.0f)

save "SDUDDTA\SDUD2024clean.dta", replace

