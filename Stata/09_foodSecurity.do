/*-------------------------------------------------------------------------------
# Name:		09_foodSecurity
# Purpose:	Process household data for food security modules
# Author:	Tim Essam, Ph.D.
# Created:	2014/12/08
# Modified: 2014/12/08
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	distinct
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/
clear
ssc inst distinct
capture log close
log using "$pathlog/09_foodSecurity", replace
use "$pathin/048_mod_w4_female.dta"

* First consider illnesses in the household
g byte ill = w4_01 == 1
g byte illHoh = (w4_01 ==1 & mid == 1)
la var illHoh "Hoh was ill in last 4 weeks"
bys a01: egen illCount = total(ill)
la var ill "At least one member of hh was ill"
la var illCount "Total casss in hh over last 4 weeks"

* Diarrhea reporting
g byte diarrhea = w4_07 == 1
la var diarrhea "hh reported at least 1 case of diarrhea"
bys a01: egen diarrheaCount = total(diarrhea)
la var diarrheaCount "Total cases of diarrhea in HH"

* How much time was missed due to illness
g weeksAbsent = .
replace weeksAbsent = 0 if inlist(w4_03, 0, 99) 
replace weeksAbsent = 1 if inlist(w4_03, .5, 1, 2, 3, 4, 5, 6, 7)
replace weeksAbsent = 2 if inlist(w4_03, 8, 9, 10, 11, 12, 13, 14)
replace weeksAbsent = 3 if inlist(w4_03, 15, 16, 18, 19, 20, 21)
replace weeksAbsent = 4 if inlist(w4_03, 22, 23, 25, 26, 27, 28)
replace weeksAbsent = 5 if inlist(w4_03, 30, 32, 40, 36, 60, 77, 90, 150, 240, 360, 365, 1095, 1825)

la var weeksAbsent "Max time lost due to illness (15+ only)"
tab weeksAbsent

g weeksAbsentHead = weeksAbsent if mid == 1
la var weeksAbsentHead "Hoh time lost due to illness"

* Symptoms if illnesses
g byte feverWeightLoss = (w4_04==1 & w4_05==1)
la var feverWeightLoss "hh member had fever and weight loss"

g byte weightLoss = w4_04 == 1
g byte fever = w4_05 == 1
la var weightLoss "hh member reported weight loss"
la var fever "hh member reported persistent fever"

* Collapse down to hh level being careful to take max/aves where needed
include "$pathdo/copylabels.do"

#delimit ;
collapse (max)ill illHoh illCount diarrhea diarrheaCount mid
		  weeksAbsentHead feverWeightLoss weightLoss fever
		  weeksAbsent, by(a01);
# delimit cr
include "$pathdo/attachlabels.do"

* Calculate percent of houshole that was ill
g illShare = ill/mid
la var illShare "Share of household members reporting illness"
tab illCount

* Label time off values
la define abs 0 "0" 1 "1" 2 "2" 3 "3" 4 "4" 5 "4+"
la val weeksAbsent abs

* Save health data
save "$pathout/health.dta", replace

* Load food security module
use "$pathin/051_mod_x3_female.dta", clear

* Food security related measures
g byte foodLack = x3_01 == 1
la var foodLack "lack of resources to get food in last 4 weeks"

* Every variable should have 8 distinct values (not the case!)
distinct x3_07*

tab x3_07_5, mi
replace x3_07_5 = 5 if x3_07_5 == .5

tab x3_07_9, mi nol
replace x3_07_9 = 7 if x3_07_9 <.71 & x3_07_9> .68

tab x3_07_11, mi nol
replace x3_07_11 = 1 if  x3_07_11< .2 & x3_07_11>.09

tab x3_07_12, mi nol
replace x3_07_12 = 5 if  x3_07_12 == .5


* Construct a diet diversity index using aggregates of consumption of different foods
local foodlist bread rice tubers cereal veg fruit pulse egg dairy meat poultry fish oil sweet cond nut tobacco
local i = 1
foreach x of local foodlist {
    g byte `x' = x3_07_`i' !=0
    la var `x' "hh consumed `x' in last 7 days"
    local i = `i' + 1 
  }
*end

* Create metric capturing number of food groups consumed
egen dietDiversity = rsum2(bread rice tubers cereal veg fruit pulse /*
*/ egg dairy meat poultry fish oil sweet cond nut tobacco)
la var dietDiversity "Dietary diversity based on number of foods consumed"

/* Calculate Food Consumption Score based on WFP methodology
* https://github.com/tessam30/Bangladesh/wiki/Food-Security-Notes
* Weighted range is 0 to 126 ( . 

"In line with WFP’s methodology, the thresholds had to be adjusted considering the oil 
consumption of char dwellers. In Bangladesh, there is a known high consumption of 
edible oil. The FCS thresholds therefore had to be raised by seven points each to 
consider this daily consumption of oil (pp. 2)" 
http://clp-bangladesh.org/wp-content/uploads/2014/05/Measuring-the-Food-Consumption-Score.pdf
*/

egen cereal_days = rowmax(x3_07_1 x3_07_2 x3_07_4 )
g cerealFCS = cereal_days * 2

egen tubers_days = rowmax(x3_07_3)
g tubersFCS = tubers_days * 2

egen staples_days = rowmax(x3_07_1 x3_07_2 x3_07_4 x3_07_3)
g staplesFCS = staples_days * 2

egen pulse_days = rowmax(x3_07_7 x3_07_16)
g pulseFCS = pulse_days * 3

* Both weighted by 1
egen veg_days = rowmax(x3_07_5)
g vegFCS = veg_days

egen fruit_days = rowmax(x3_07_6)
g fruitFCS = fruit_days

egen meat_days = rowmax(x3_07_10 x3_07_11 x3_07_12)
g meatFCS = meat_days * 4

egen milk_days = rowmax(x3_07_9)
g milkFCS = milk_days * 4

egen sugar_days = rowmax(x3_07_14)
g sugarFCS = sugar_days * 0.5

egen oil_days = rowmax(x3_07_13)
g oilFCS = oil_days * 0.5

* Label the variables, get their averages and plot them on same graph to compare
local ftype cereal tubers staples pulse veg fruit meat milk sugar oil 
local n: word count `ftype'
forvalues i = 1/`n' {
	local a: word `i' of `ftype'
	la var `a'_days "Number of days consuming `a'"

}
*end

* Calculate overall FCS
egen FCS = rsum2(staplesFCS pulseFCS vegFCS fruitFCS meatFCS milkFCS sugarFCS oilFCS)
sum *FCS
assert FCS <= 112
la var FCS "Food Consumption Score"

* Clone FCS and recode based on Bangladesh thresholds
clonevar FCS_categ = FCS 
recode FCS_categ (0/28 = 0) (28.5/42 = 1) (42.1/53 = 2) (53/112 = 3)
lab def fcscat 0 "Poor" 1 " Borderline" 2 " Acceptable low" 3 "Acceptable high"
lab val FCS_categ fcscat
la var FCS_categ "Food consumption score category"
tab FCS_cat, mi


* Calculate shares of Food groups
foreach x of varlist staplesFCS pulseFCS vegFCS fruitFCS meatFCS milkFCS sugarFCS oilFCS {
	g `x'_pct = `x' / FCS
}
*end

* Calculate cumlative frequencies for each FCS score
foreach x of varlist staples_days pulse_days veg_days fruit_days meat_days milk_days sugar_days oil_days {
	bysort FCS: gen cf_`x' = sum(`x')
	}
*end

* Create a graphic that shows the composition of diet based on FCS; 
/* Need to reshape the data so that each food category is listed by FCS score
Will do this in R to generate nice looking ggplots using ggplot
(d, aes(x=FCS, y=val, group=var, fill=var)) + geom_area(position="fill")"
 */
 
 * Merge in geographic data 
merge 1:1 a01 using "$pathin/001_mod_a_male.dta"
 
preserve
keep staples_days pulse_days veg_days fruit_days meat_days milk_days sugar_days oil_days FCS a01 div_name District_Name Upazila_Name
order FCS staples_days meat_days veg_days oil_days sugar_days fruit_days pulse_days milk_days a01 div_name District_Name Upazila_Name
rename *_days* *
qui export delimited using "$pathexport\food.consumption.score.csv", replace 
restore

* Create an export for making diet diversity plots in R
preserve
keep dietDiversity a01 div_name District_Name Upazila_Name
order dietDiversity a01 div_name District_Name Upazila_Name
qui export delimited using "$pathexport\diet.diversity.csv", replace 
restore

keep sample_type foodLack dietDiversity FCS FCS_categ cereal_days tubers_days staples_days pulse_days /*
*/ veg_days fruit_days meat_days milk_days sugar_days oil_days a01
save "$pathout/foodSecurity.dta", replace

* Construct food prices for dietary diversity and FCS scores
clear

use "$pathin/031_mod_o1_female.dta", replace
egen price_wheat = mean(o1_07) if inlist(o1_01, 5, 6, 7, 8, 9, 213, 279, /*
*/ 281, 282, 285, 296, 297, 299, 301, 303, 306, 311), by(a01)

egen price_rice = mean(o1_07) if inlist(o1_01, 1, 2, 3, 4, 11, 12, 277, 280), by(a01)
egen price_starch = mean(o1_07) if inlist(o1_01, 14, 61, 62, 55), by(a01)
egen price_cereal = mean(o1_07) if inlist(o1_01, 5, 6, 8, 13,  15, 16, 901), by(a01)

egen price_vegetables = mean(o1_07) if inlist(o1_01, 25, 27, 42, 43, /*
*/ 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 57, 58, 59, 60, 64, /*
*/ 65, 69, 70, 72, 73, 76, 80, 80, 86, 87, 88, 93, 94, 97, 101, 102, /*
*/ 103, 104, 105, 106, 107, 109, 111, 114, 254, 287, 288, 292, 295, /*
*/ 904, 905), by(a01)

egen price_fruit = mean(o1_07) if inlist(o1_01, 56, 56, 63, 71, 74, 141, 142, 144, /*
*/ 145, 147, 148, 149, 151, 152, 154, 155, 156, 157, 160, 161, 166, 167, 168, 274, 907), by(a01)

egen price_beans = mean(o1_07) if inlist(o1_01, 21, 22 /* 
*/ 23, 24, 26, 31, 78, 112, 291, 298, 302, 902), by(a01)

egen price_eggs = mean(o1_07) if inlist(o1_01, 130, 289), by(a01)
egen price_dairy = mean(o1_07) if inlist(o1_01, 132, 133, 134, 294, 321), by(a01)

egen price_meat = mean(o1_07) if inlist(o1_01, 121, 122, /* 
*/126,  127, 128, 129, 164, 203, 283, 290, 322, 906), by(a01)

egen price_poultry = mean(o1_07) if inlist(o1_01, 123, 124, 125), by(a01)

egen price_fish = mean(o1_07) if inlist(o1_01, 131, 176, 177, 178, 181, /*
*/ 184, 186, 187, 188, 189, 190, 191, 192, 193, 194, 196, 198, 204, 205, /*
*/ 211, 214, 215, 223, 230, 238, 240, 241, 242, 243, 908, 909), by(a01)

egen price_fats = mean(o1_07) if inlist(o1_01, 34, 35, 36, 903, 135), by(a01)

egen price_sugar = mean(o1_07) if inlist(o1_01, 162 /*
*/ 212, 253, 271, 276, 293, 304, 307, 266, 267), by(a01)

egen price_condiments = mean(o1_07) if inlist(o1_01, 32, 150, 153, 158, /*
*/  247, 248, 251, 252, 257, 264, 269, 272, 300, 308, 910), by(a01)

egen price_nuts = mean(o1_07) if inlist(o1_01, 79, 146, 163, 259, 270), by(a01)
*egen price_tobacco = mean(o1_07) if inlist(o1_01, 314, 315, 316), by(a01)

* Label the variables, get their averages and plot them on same graph to compare
local ptype wheat rice starch cereal veg fruit beans eggs dairy meat poultry fish fats sugar condiments nuts
local n: word count `ptype'
forvalues i = 1/`n' {
	local a: word `i' of `ptype'
	la var price_`a' "Average price for `a'"
	cap g `a' = 1
	qui reg price_`a' `a', nocons
	eststo fp`i'
	drop `a' _est_fp`i'
}
*end

* Plot averages and confidence bands for each price on same graph; Save it.
coefplot fp1 fp2 fp3 fp4 fp5 fp6 fp7 fp8 fp9 fp10 fp11 fp12 fp13 fp14 fp15 fp16, legend(off)/*
*/ title(Average food prices, size(small) color(black))
graph export "$pathgraph\Ave_food_prices.png", as(png) replace  width(800) height(600)

* Keep prices and household identifier; Collapse and keep max average prices
ds(o1* sample_type), not
keep `r(varlist)'
include "$pathdo/copylabels.do"
collapse (max) price*, by(a01)
include "$pathdo/attachlabels.do"

merge 1:1 a01 using "$pathout/foodSecurity.dta", gen(fcs_merge)
drop fcs_merge

merge 1:1 a01 using "$pathin/001_mod_a_male.dta", gen(tmp)
drop tmp 
drop a02 a10 a11 a12 a13 a14 a15 a16_dd a16_mm a16_yy /*
*/  a17_dd a17_mm a17_yy a18 a19 a20_dd a20_mm a20_yy a21 Flagaddl regnm

* Replace missing values for food prices with the median value at the village/district/division level
local flist wheat rice starch cereal veg fruit beans eggs dairy meat poultry fish fats sugar condiments nuts
foreach x of local flist {
	cap egen `x'tmp  = median(price_`x'), by(vcode_n)
	cap egen `x'tmp2 = median(price_`x'), by(dcode)
	cap egen `x'tmp3 = median(price_`x'), by(div)
	
	replace price_`x' = `x'tmp  if price_`x' == .
	replace price_`x' = `x'tmp2 if price_`x' == .
	replace price_`x' = `x'tmp3 if price_`x' == .	
	
	drop `x'tmp*
	
}
*end
compress

save "$pathout/foodSecurity.dta", replace

capture log close
log2html "$pathlog/09_foodSecurity", replace

