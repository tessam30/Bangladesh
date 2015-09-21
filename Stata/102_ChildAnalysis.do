/*-------------------------------------------------------------------------------
# Name:		102_ChildHealthanalysis
# Purpose:	Create and test models for shocks and dietary outcomes
# Author:	Tim Essam, Ph.D.
# Created:	2014/11/05
# Modified: 2015/09/17
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	labutil, labutil2 (ssc install labutil, labutil2)
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/


* Individual analysis using child malnutrition data and reverse merging (1:m) on hh char.
clear
use "$pathout/ChildHealth_indiv.dta"

* Merge all data sets together
local mlist hhchar hhinfra hhpc hhTLU_pc finances nc remittances foodSecurity
local i = 1
foreach x of local mlist {
	merge m:m a01 using "$pathout/`x'.dta", gen(merge_`i')
	local i = `i' + 1
	}
*end
drop if merge_1 == 2 

* Recall, those household with no children under 5 will not be represented
* Have 2911 children under five after dropping relevant obs.

* Recode a few of the variables
recode gender (2=0)
g byte livestock = TLUtotal>0 & TLUtotal!=.
encode div_name, gen(divName)
encode District_Name, gen(distName)

* HH composotion
bys a01: gen hhUnder5=_N

global exog1 "gender gender#c.ageMonths ageMonths c.ageMonths#c.ageMonths hhUnder5 hhSize sexRatio depRatio hhlabor femhead agehead educAdult"
global exog2 "$exog1 FCS dietDiversity privateWater latrineSealed distHealth distMarket"
global exog3 "$exog2 infraindex agAssetWealth durwealth cultland livestock migrationNW ib(3).divName i.hh_type"

est clear
eststo stunt1, title("model 1"): xi:reg stunting $exog1, robust
eststo stunt2, title("model 2"): xi:reg stunting $exog2, robust
eststo stunt3, title("model 3"): xi:reg stunting $exog3, robust
predict resid, resid
kdensity resid, normal
rvfplot2, ms(oh)
esttab, se star(* 0.10 ** 0.05 *** 0.01) label 
esttab using "$pathreg/stunting.txt", replace wide plain se mlabels(none) label 

est clear
drop resid
eststo uweight1, title("model 1"): xi:reg underweight $exog1, robust
eststo uweight2, title("model 2"): xi:reg underweight $exog2, robust
eststo uweight3, title("model 3"): xi:reg underweight $exog3, robust
predict resid, resid
kdensity resid, normal
rvfplot2, ms(oh) 
esttab, se star(* 0.10 ** 0.05 *** 0.01) label 
esttab using "$pathreg/underweight.txt", replace wide plain se mlabels(none) label 

est clear
drop resid
eststo wasting1, title("model 1"): xi:reg wasting $exog1, robust
eststo wasting2, title("model 2"): xi:reg wasting $exog2, robust
eststo wasting3, title("model 3"): xi:reg wasting $exog3, robust
predict resid, resid
kdensity resid, normal
rvfplot2, ms(oh)
esttab, se star(* 0.10 ** 0.05 *** 0.01) label 
esttab using "$pathreg/wasting.txt", replace wide plain se mlabels(none) label

est clear
eststo stunting, title("model 3"): xi:reg stunting $exog3, robust
eststo underweight, title("model 3"): xi:reg underweight $exog3, robust
eststo wasting, title("model 3"): xi:reg wasting $exog3, robust
esttab, se star(* 0.10 ** 0.05 *** 0.01) label 
esttab using "$pathreg/combinedCH.txt", replace wide plain se mlabels(none) label


coefplot stunting underweight wasting, xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small)  xlabel(, labsize(small))  /*
*/ scale(1) drop(_cons)  


* Look at the outcomes by age category (Nice summary graphic)
twoway (lowess stunted ageMonths, mean adjust bwidth(0.3)) /*
*/ (lowess wasted ageMonths, mean adjust bwidth(0.3)) /*
*/ (lowess underwgt ageMonths, mean adjust bwidth(0.3)),  xlabel(0(2)60,  labsize(tiny))

lpoly stunted ageMonths, deg(1) bw(.8)

* Export to R for a look in ggplot
keep stunted underwgt wasted
