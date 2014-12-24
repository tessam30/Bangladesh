/*-------------------------------------------------------------------------------
# Name:		02_hhinfra
# Purpose:	Process household data and create hh characteristic variables
# Author:	Tim Essam, Ph.D.
# Created:	2014/11/05
# Modified: 2014/11/05
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	labutil, labutil2 (ssc install labutil, labutil2)
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/

clear
capture log close
log using "$pathlog/02_hhinfra", replace
set more off

/* Load module with information on household quality. */
use "$pathin/035_mod_q_male.dta", clear

g byte ownHouse = inlist(q_01, 1)
la var ownHouse "HH owns dwelling"

g houseAge = .
replace houseAge = 1 if inlist(q_04, 0, 1, 2, 3, 4, 5)
replace houseAge = 2 if inlist(q_04, 6, 7, 8, 9, 10)
replace houseAge = 3 if inlist(q_04, 11, 12, 13, 14, 15)
replace houseAge = 4 if q_04 >15 & q_04<9999
replace houseAge = 5 if q_04 == 9999
la var houseAge "Age of household"
lab def home 1 "0-5 years" 2 "6-10 years" 3 "11-15" /*
*/ 4 "15 +" 5 "unknown"

g byte newHome = houseAge ==1
la var newHome "House is less than 5 years old"

* Dwelling quality
clonevar houseSize = q_12
clonevar houseQual = q_06

g byte brickTinHome = inlist(q_07, 1, 2)
la var brickTinHome "Dwelling primarily brick or tin"

g byte mudHome = inlist(q_07, 4)
la var mudHome "Dwelling entirely made of mud"

g byte metalRoof = inlist(q_08, 1, 2)
la var metalRoof "Roof primarily of tin/contrete" 

g byte dfloor = inlist(q_09, 4)
la var dfloor "Dirt floor"

g byte singleRoom = inlist(q_10, 1)
la var singleRoom "Dwelling is single room"

clonevar electricity = q_13
recode electricity (2=0) 
clonevar elecQual = q_14

* Cooking fuel source
g cookFuel = .
replace cookFuel = 1 if inlist(q_16, 1)
replace cookFuel = 2 if inlist(q_16, 2, 3, 4)
replace cookFuel = 3 if inlist(q_16, 5, 8, 9)
replace cookFuel = 4 if inlist(q_16, 6)
replace cookFuel = 5 if inlist(q_16, 10, 7)
la def fuel 1 "electric" 2 "gas" 3 "firewood/natural" 4 "dung" 5 "other"
la values cookFuel fuel
la var cookFuel "Fuel used for cooking"

* Binary for electric fuel sources 
g byte electFuel = q_16 == 1

* Lighting fuel
g byte lightFuel = inlist(q_18, 1, 2, 3)
la var lightFuel "HH uses electricity for lighting"

g byte mobile = q_20 > 0
la var mobile "HH owns at least on mobile phone"

* keep relevant variables and save dataset for merging w/ other assets
#delimit ;
	keep a01 ownHouse houseAge newHome houseSize houseQual 
		brickTinHome mudHome metalRoof dfloor singleRoom 
		electricity elecQual cookFuel lightFuel mobile
		sample_type;
#delimit cr

* Save house infrastructure data
save "$pathout/houseinfra.dta", replace

**************
* Sanitation *
**************
use "$pathin/036_mod_r_male.dta", clear

g byte latrineSealed = inlist(r01, 4, 5)
la var latrineSealed "Water sealed latrine"

g byte waterAccess = r02 == 1
la var waterAccess "HH has access to water supply"

g byte privateWater = inlist(r03, 1, 2, 3)
la var privateWater "Water source is private (tube well or piped)"

g byte publicWater = inlist(r03, 4, 5, 6, 7, 8)
la var publicWater "Water source is public or open (community tubewell)"

g byte garbage = inlist(r10, 1, 2, 3 4)
la var garbage "Garbage pit or collection"

keep latrineSealed waterAccess privateWater publicWater garbage a01

* Merge in household infrastructure and create factor analysis/PCA
 merge 1:1 a01 using "$pathout/houseinfra.dta"
 drop _merge
 save "$pathout/houseinfra.dta", replace
 
**********************
* Community Services *
**********************
use "$pathin/037_mod_s_male.dta", clear

g distHealth = s_04 if inlist(s_01, 1)
g distRoad = s_04 if inlist(s_01, 3)
g distTown = s_04 if inlist(s_01, 7)
g distMarket = s_04 if inlist(s_01, 6)

collapse (max) distHealth distRoad distTown distMarket, by(a01)

la var distHealth "Distance to nearest health center (in km)"
la var distRoad "Distance to nearest road (in km)"
la var distTown "Distance to nearest town (in km)"
la var distMarket "Distance to nearest market (in km)"

merge 1:1 a01 using "$pathout/houseinfra.dta"
drop _merge

 
* Run factor analysis to develop infrastructure index for households
/* NOTES: Create Infrastructure indices 
 Keeping only first factor to simplify;
 Use polychoric correlation matrix because of binary variables
 http://www.ats.ucla.edu/stat/stata/faq/efa_categorical.htm
*/

* Set global vector of variables to include in analysis
#delimit ;
	local infra brickTinHome dfloor distHealth distMarket distRoad 
	distTown electricity garbage newHome latrineSealed lightFuel 
	metalRoof mobile ownHouse privateWater singleRoom waterAccess
	 ;
#delimit cr

* Standardize vector of data for use in PCA; Replace missing values with mean values
* Is this ok to do w/ 0/1 variables? Check robustness
foreach x of local infra {
	egen mean`x' = mean(`x')
	replace `x' = mean`x' if `x' ==.
	*egen `x'_std = std(`x')
	drop mean`x'
}
*
notes: Check robustness PCA on infrastructure of replacing missing values with averages.

*Now run factor analysis retaining only principal component factors
factor brickTinHome dfloor electricity garbage newHome /* 
*/ latrineSealed lightFuel metalRoof mobile ownHouse /* 
*/ privateWater singleRoom waterAccess, pcf
rotate	
predict infraindex
la var infraindex "infrastructure index"

* Plot loadings for review
loadingplot, mlabs(small) mlabc(maroon) mc(maroon) /*
	*/ xline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*
	*/ yline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*
	*/ title(Household infrastructure index loadings)
graph export "$pathgraph/infraLoadings.png", as(png) replace
scree, title(Scree plot of infra index)
graph export "$pathgragh/infraScree.png", as(png) replace
	
*Now run factor analysis retaining only principal component factors
factor distHealth distMarket distRoad distTown, pcf	
predict accessindex
la var infraindex "accessiblity index"
	
*loadingplot, mlabs(small) mlabc(maroon) mc(maroon) /*
*	*/ xline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*
*	*/ yline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*
*	*/ title(Household Accessibility Index Loadings)
*graph export "$pathgraph\assessabilityLoadings.png", as(png) replace
* Only one factor retained so there is no two-way graph.	
scree, title(Scree plot of assessibility index)
graph export "$pathgragh/infraScree.png", as(png) replace

* Save the hhinfra dataset
save "$pathout/hhinfra.dta", replace
log2html "$pathlog/02_hhinfra", replace
log close

