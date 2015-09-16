/*-------------------------------------------------------------------------------
# Name:		09_foodSecurity
# Purpose:	Process household data for food security modules
# Author:	Tim Essam, Ph.D.
# Created:	2014/12/08
# Modified: 2014/12/08
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	distinct
# Dependencies: For translation of food items see FAO doc here: 
# (http://www.fao.org/fileadmin/templates/food_composition/documents/FCT_10_2_14_final_version.pdf)
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
la var illCount "Total cases in hh over last 4 weeks"

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
include "$pathdo2/copylabels.do"

#delimit ;
collapse (max)ill illHoh illCount diarrhea diarrheaCount mid
		  weeksAbsentHead feverWeightLoss weightLoss fever
		  weeksAbsent, by(a01);
# delimit cr
include "$pathdo2/attachlabels.do"

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
clonevar foodLack = x3_01 
clonevar foodLackFreq = x3_02
clonevar sleepHungry = x3_03 
clonevar sleepHungryFreq = x3_04
clonevar noFood = x3_05 
clonevar noFoodFreq = x3_06

foreach x of varlist foodLack sleepHungry noFood {
		recode `x' (2 = 0)
}

egen foodInsecurity = rsum2(foodLack sleepHungry noFood)
la var foodInsecurity "Sum of three food security binary variables"


*########## Full Dietary Diversity *17 food groups) ##########

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
    g byte `x'OwnProd = (x3_08_`i' == 1) 
    la var `x'OwnProd "hh is net producer of `x'"
    tab `x'OwnProd, mi
    local i = `i' + 1 
    *display in yellow "`x'"
  }
*end

* Create metric capturing number of food groups consumed
egen dietDiversity = rsum2(bread rice tubers cereal veg fruit pulse /*
*/ egg dairy meat poultry fish oil sweet cond nut tobacco)
la var dietDiversity "Dietary diversity based on number of foods consumed"
recode dietDiversity (17 = 15)

* Create diet Diversity using 9 food categories
* 1) Cereals - 1, 2, 4 combine (bread, rice, cereal)
* 2) Tubers - 3 
* 3) Veg - 5
* 4) Fruit - 6 
* 5) Meat - (10 - 11) or meat + poultry
* 6) eggs (8)
* 7) fish (12)
* 8) pulse (pulse + nut)
* 9) dairy - 9
* 10) 13 - oils
* 11) 14 - sweets
* 12) 15 - condiments

g byte cereal2 = (bread == 1 | rice == 1 | cereal == 1)
g byte meat2 = (meat == 1 | poultry == 1)
g byte pulse2 = (pulse == 1 | nut == 1)

egen dietDiv = rsum2(cereal2 tubers veg fruit pulse2 /*
*/ egg dairy meat2 fish oil sweet cond)
la var dietDiv "Dietary diversity based on 12 category FAO HDDS "
recode dietDiv (17 = 15)





*########## Food Consumption Scores ##########

/* Calculate Food Consumption Score based on WFP methodology
* https://github.com/tessam30/Bangladesh/wiki/Food-Security-Notes
* Weighted range is 0 to 112 ( . 

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

* wheat, rice, cereal, starch
egen staples_days = rowmax(x3_07_1 x3_07_2 x3_07_4 x3_07_3)
g staplesFCS = staples_days * 2

* legumes, beans, lentils, nuts, peas & nuts and seeds
egen pulse_days = rowmax(x3_07_7 x3_07_16)
g pulseFCS = pulse_days * 3

* Both weighted by 1
egen veg_days = rowmax(x3_07_5)
g vegFCS = veg_days

egen fruit_days = rowmax(x3_07_6)
g fruitFCS = fruit_days

* meat, poultry, fish, eggs
egen meat_days = rowmax(x3_07_8 x3_07_10 x3_07_11 x3_07_12)
g meatFCS = meat_days * 4

egen milk_days = rowmax(x3_07_9)
g milkFCS = milk_days * 4

egen sugar_days = rowmax(x3_07_14)
g sugarFCS = sugar_days * 0.5

egen oil_days = rowmax(x3_07_13)
g oilFCS = oil_days * 0.5

* Create second dietary diversity index using 10 base foods from WFP FCS
local flist staples pulse veg fruit meat milk sugar oil 
foreach x of local flist {
	g byte tmp`x' = `x'_days >0
	
	}
*end
egen dietDivFCS = rsum2(tmpstaples tmppulse tmpveg tmpfruit tmpmeat tmpmilk tmpsugar tmpoil)
la var dietDivFCS "Dietary diversity based on FCS groups"

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

twoway(lowess staplesFCS_pct FCS)(lowess pulseFCS_pct FCS)(lowess vegFCS_pct FCS)(lowess fruitFCS_pct FCS)/*
*/(lowess meatFCS_pct FCS)(lowess milkFCS_pct FCS)(lowess sugarFCS_pct FCS)(lowess oilFCS_pct FCS)


* Calculate cumlative frequencies for each FCS score
foreach x of varlist staples_days pulse_days veg_days fruit_days meat_days milk_days sugar_days oil_days {
	bysort FCS: gen cf_`x' = sum(`x')
	la var cf_`x' "Cumulative frequency of food consumption by FCS"
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
keep dietDiversity dietDiv a01 div_name District_Name Upazila_Name
order dietDiversity dietDiv a01 div_name District_Name Upazila_Name
qui export delimited using "$pathexport\diet.diversity.csv", replace 
restore

* Keep select variables for now, can go back and pull in shares if needed.
keep sample_type foodLack dietDiversity FCS dietDivFCS dietDiv FCS_categ cereal_days tubers_days staples_days pulse_days /*
*/ veg_days fruit_days meat_days milk_days sugar_days oil_days a01
save "$pathout/foodSecurity.dta", replace


***************
* FOOD PRICES *
***************

* Construct food prices for dietary diversity and FCS scores
* Create another dietary Diveristy metric based on 12 major food groups identified
* Refer to page 47 onward of 001_bangladesh_ihs_questionnaire
clear
use "$pathin/031_mod_o1_female.dta", replace

***************************
* Food groups pp 47-57 *
***************************

* Cereal are items 1/16 + 901 on pg. 47
cnumlist "1/16 901"
bys a01: g byte cerealCons = 1 if (o1_02 == 1) & (inlist (o1_01, `r(numlist)'))
egen price_cereal = mean(o1_07) if (inlist (o1_01, `r(numlist)')), by(a01)

cnumlist "21/28 902"
bys a01: g byte pulseCons = 1 if (o1_02 == 1) & (inlist (o1_01, `r(numlist)'))	
egen price_pulse = mean(o1_07) if (inlist (o1_01, `r(numlist)')), by(a01)

cnumlist "31/36 903"
bys a01: g byte oilCons = 1 if (o1_02 == 1) & (inlist (o1_01, `r(numlist)'))
egen price_oil = mean(o1_07) if (inlist (o1_01, `r(numlist)')), by(a01)	

cnumlist "41/82 904 86/115 906"
bys a01: g byte vegCons = 1 if (o1_02 == 1) & (inlist (o1_01, `r(numlist)'))
egen price_veg = mean(o1_07) if (inlist (o1_01, `r(numlist)')), by(a01)

cnumlist "121/135 906"
bys a01: g byte meatCons = 1 if (o1_02 == 1) & (inlist (o1_01, `r(numlist)'))
egen price_meat = mean(o1_07) if (inlist (o1_01, `r(numlist)')), by(a01)

cnumlist "141/170 907"
bys a01: g byte fruitCons = 1 if (o1_02 == 1) & (inlist (o1_01, `r(numlist)'))
egen price_fruit = mean(o1_07) if (inlist (o1_01, `r(numlist)')), by(a01)

cnumlist "176/205 908 211/243 909"
bys a01: g byte fishCons = 1 if (o1_02 == 1) & (inlist (o1_01, `r(numlist)'))
egen price_fish = mean(o1_07) if (inlist (o1_01, `r(numlist)')), by(a01)	

cnumlist "246/264 910"
bys a01: g byte spiceCons = 1 if (o1_02 == 1) & (inlist (o1_01, `r(numlist)'))
egen price_spice = mean(o1_07) if (inlist (o1_01, `r(numlist)')), by(a01)	

cnumlist "266/271"
bys a01: g sugarCons = 1 if (o1_02 == 1) & (inlist(o1_01, `r(numlist)'))	
egen price_sugar = mean(o1_07) if (inlist (o1_01, `r(numlist)')), by(a01)

local flist "cereal pulse oil veg meat fruit fish spice sugar"
local n: word count `flist'
forvalues i = 1/`n' {
	local a: word `i' of `flist'
	replace `a'Cons = 0 if `a'Cons ==.
}
*end

***************************
* Dietary Diversity pp 90 *
***************************

* Generate prices for each of the 17 foodgroups identified from food security mod (pp. 90) 
cnumlist "5/10 901"
egen dd_price_wheat = mean(o1_07) if inlist(o1_01, `r(numlist)'), by(a01)

cnumlist "1/4 11/12"
egen dd_price_rice = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

cnumlist "61 62 55"
egen dd_price_starch = mean(o1_07) if inlist(o1_01, `r(numlist)'), by(a01)

cnumlist "5 13 14 15"
egen dd_price_cereal = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

cnumlist "41/60 63/82 904 86/115 906"
egen dd_price_vegetables = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

cnumlist "141/170 907"
egen dd_price_fruit = mean(o1_07) if inlist(o1_01, `r(numlist)'), by(a01)

cnumlist "21/28 902" 
egen dd_price_beans = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

cnumlist "130 131"
egen dd_price_eggs = mean(o1_07) if inlist(o1_01, `r(numlist)'), by(a01)

cnumlist "132/135"
egen dd_price_dairy = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

cnumlist " 121 122 126/129 906"
egen dd_price_meat = mean(o1_07) if inlist(o1_01, `r(numlist)'), by(a01)

cnumlist "123 124 125"
egen dd_price_poultry = mean(o1_07) if inlist(o1_01, `r(numlist)'), by(a01)

cnumlist "176/205 908 211/243 909"
egen dd_price_fish = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

cnumlist "31/36 903"
egen dd_price_fats = mean(o1_07) if inlist(o1_01, `r(numlist)'), by(a01)

cnumlist "266/269 271"
egen dd_price_sugar = mean(o1_07) if inlist(o1_01, `r(numlist)'), by(a01)

cnumlist "246/264 910"
egen dd_price_condiments = mean(o1_07) if inlist(o1_01, `r(numlist)'), by(a01)

cnumlist "270"
egen dd_price_nuts = mean(o1_07) if inlist(o1_01, `r(numlist)'), by(a01)

* Tobacco unit price is zero, but o1_08 var is not; average value of tobacco consumed
cnumlist "314"
egen dd_price_tobacco = mean(o1_08) if inlist(o1_01, `r(numlist)'), by(a01)

*********************************
* Food Consumption Scores pp    *
* Based on pp 90                *
*********************************

/* Do same groupings but for FCS groups: cereal tubers staples pulse veg fruit meat milk sugar oil 
staples = wheat, rice, cereal, starch
pulse = legumes, beans, lentils, nuts, peas & nuts and seeds
veg = veg
fruit = fruit
meat and fish = meat, chicken, fish, eggs
milk = dairy
sugar
oil
condiments
*/

cnumlist "1/16 901 21/28 902"
egen FCS_price_staples = mean(o1_07) if inlist(o1_01,`r(numlist)'), by(a01)

cnumlist "21/28 902"
egen FCS_price_pulse = mean(o1_07) if inlist(o1_01,`r(numlist)'), by(a01)

cnumlist "41/82 904 86/115 906"
egen FCS_price_veg = mean(o1_07) if inlist(o1_01, `r(numlist)'), by(a01)

cnumlist "141/170 907"
egen FCS_price_fruit = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

cnumlist "121/129 906 176/205 908 211/243 909"
egen FCS_price_fish = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

cnumlist "132 133 134 135"
egen FCS_price_dairy = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

cnumlist "266/269 271"
egen FCS_price_sugar = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

cnumlist "31/36 903"
egen FCS_price_fats = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

cnumlist "246/264 910"
egen FCS_price_condiments = mean(o1_07) if inlist(o1_01, `r(numlist)' ), by(a01)

* Keep prices and household identifier; Collapse and keep max average prices
ds(o1* sample_type), not
keep `r(varlist)'
include "$pathdo/copylabels.do"
collapse (max) price* FCS_price* *Cons dd_*, by(a01)
include "$pathdo/attachlabels.do"

* Create second diet diversity variable using survey categories
egen dietDiv2 = rsum2(cerealCons pulseCons oilCons vegCons meatCons fruitCons fishCons spiceCons sugarCons)
la var dietDiv2 "Dietary Diversity based on 9 food groups from survey"

* Spice prices seem to be abnormally high; remove outliers and recalculate
sum price_spice, d
replace price_spice = (`r(mean)') if price_spice >`r(p95)' & price_spice~=.

* label food prices and generate coef plot of average prices
est clear
local flist "cereal pulse oil veg meat fruit fish spice sugar"
local n: word count `flist'
forvalues i = 1/`n' {
	local a: word `i' of `flist'
	la var `a'Cons "Consumed `a' in last 7 days"
	la var price_`a' "Unit price of `a'"
	cap g `a' = 1
	qui reg price_`a' `a', nocons
	eststo fp`i'
	drop `a' _est_fp`i'
}
*end

* Plot averages and confidence bands for each price on same graph; Save it.
coefplot fp1 fp2 fp3 fp4 fp5 fp6 fp7 fp8 fp9 , legend(off)/*
*/ title(Average food prices, size(small) color(black))
graph export "$pathgraph\Ave_survey_prices.png", as(png) replace  width(800) height(600)


* Label the variables, get their averages and plot them on same graph to compare
est clear
local ptype wheat rice starch cereal veg fruit beans eggs dairy meat poultry fish fats sugar condiments nuts
local n: word count `ptype'
forvalues i = 1/`n' {
	local a: word `i' of `ptype'
	la var dd_price_`a' "Average price for `a'"
	cap g `a' = 1
	qui reg dd_price_`a' `a', nocons
	eststo fp`i'
	drop `a' _est_fp`i'
}
*end

* Plot averages and confidence bands for each price on same graph; Save it.
coefplot fp1 fp2 fp3 fp4 fp5 fp6 fp7 fp8 fp9 fp10 fp11 fp12 fp13 fp14 fp15 fp16, legend(off)/*
*/ title(Average food prices, size(small) color(black))
graph export "$pathgraph\Ave_food_prices.png", as(png) replace  width(800) height(600)

* Create summary statistics of each food for plotting
est clear 
local fcstype staples pulse veg fruit fish dairy sugar fats condiments
local n: word count `fcstype'
forvalues i = 1/`n' {
	local a: word `i' of `fcstype'
	la var FCS_price_`a' "Average price for `a'"
	cap g `a' = 1
	qui reg FCS_price_`a' `a', nocons
	eststo fp`i'
	drop `a' _est_fp`i'
}
*end

coefplot fp1 fp2 fp3 fp4 fp5 fp6 fp7 fp8 fp9, legend(off)/*
*/ title(Average food prices, size(small) color(black))
graph export "$pathgraph\Ave_FCS_prices.png", as(png) replace  width(800) height(600)

merge 1:1 a01 using "$pathout/foodSecurity.dta", gen(fcs_merge)
drop fcs_merge

merge 1:1 a01 using "$pathin/001_mod_a_male.dta", gen(tmp)
drop tmp 
drop a02 a10 a11 a12 a13 a14 a15 a16_dd a16_mm a16_yy /*
*/  a17_dd a17_mm a17_yy a18 a19 a20_dd a20_mm a20_yy a21 Flagaddl regnm

* Replace missing values for food prices with the median value at the village/district/division level
local flist "cereal pulse oil veg meat fruit fish spice sugar"
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

* Full dietary diversity index
local flist wheat rice starch cereal veg fruit beans eggs dairy meat poultry fish fats sugar condiments nuts tobacco
foreach x of local flist {
	cap egen `x'tmp  = median(dd_price_`x'), by(vcode_n)
	cap egen `x'tmp2 = median(dd_price_`x'), by(dcode)
	cap egen `x'tmp3 = median(dd_price_`x'), by(div)
	
	replace dd_price_`x' = `x'tmp  if dd_price_`x' == .
	replace dd_price_`x' = `x'tmp2 if dd_price_`x' == .
	replace dd_price_`x' = `x'tmp3 if dd_price_`x' == .	
	
	drop `x'tmp*
}
*end

* Repeate for food consumption scores as well
local fcstype staples pulse veg fruit fish dairy sugar fats condiments
foreach x of local fcstype {
	cap egen `x'tmp  = median(FCS_price_`x'), by(vcode_n)
	cap egen `x'tmp2 = median(FCS_price_`x'), by(dcode)
	cap egen `x'tmp3 = median(FCS_price_`x'), by(div)
	
	replace FCS_price_`x' = `x'tmp  if FCS_price_`x' == .
	replace FCS_price_`x' = `x'tmp2 if FCS_price_`x' == .
	replace FCS_price_`x' = `x'tmp3 if FCS_price_`x' == .
	
	drop `x'tmp*
	}
*end
compress

save "$pathout/foodSecurity.dta", replace

capture log close
log2html "$pathlog/09_foodSecurity", replace

