/*-------------------------------------------------------------------------------
# Name:		50_preAnalysis
# Purpose:	Prepare initial round of data for preliminary analysis (weight free)
# Author:	Tim Essam, Ph.D.
# Created:	2014/12/24
# Modified: 2014/12/24
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	modeldiag, iqr
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/
clear
capture log close
log using "$pathlog/50_preAnalysis", replace

do "$pathdo2/01_hhchar.do"
do "$pathdo2/02_hhinfra.do"
do "$pathdo2/03_hhpc.do"
do "$pathdo2/04_tlus.do"
do "$pathdo2/05_nc.do"
do "$pathdo2/06_financial.do"
do "$pathdo2/07_shocks.do"
do "$pathdo2/08_remittances.do"
do "$pathdo2/09_foodSecurity.do"
do "$pathdo2/11_womensStatus.do"
bob

clear
use $pathout/shocks.dta
merge 1:1 a01 using $pathin/001_mod_a_male.dta

* Merge all data sets together
local mlist hhchar hhinfra hhpc hhTLU_pc finances nc remittances foodSecurity womensStatus
local i = 1
foreach x of local mlist {
	merge 1:1 a01 using "$pathout/`x'.dta", gen(merge_`i')
	local i = `i' + 1
	}
*

* Encode the division and district names for use as dummies
encode div_name, gen(divName)
encode District_Name, gen(distName)

* First model is looking at dietary diversity
graph matrix dietDiversity femhead agehead ageheadsq marriedHead hhSize sexRatio depRatio literateHead educAdult

* Model dietary diversity as both a OLS and poisson
global ddexog1 "i.femhead agehead i.marriedHead hhSize sexRatio depRatio i.literateHead educAdult i.landless"
global ddexog2 "$ddexog1 infraindex cultland" 
reg dietDiversity $ddexog1 price_* ib(39).distName, robust

* Now as a poisson with a zero-truncated model b/c the value zero cannot appear (households have to eat)
tpoisson dietDiversity $ddexog1 price_* , ll(0) vce(robust) 
est sto tpois1
tpoisson dietDiversity $ddexog2 price_* ib(39).distName, ll(0) vce(robust)
est sto tpois2
est stat tpois1 tpois2









* Set global exogenous variables for different model specifications
global exog1 "femhead marriedHead agehead ageheadsq hhSize sexRatio depRatio hhlabor under15 literateHead educAdult"
global exog2 "$exog1 distHealth distMarket infraindex agAssetWealth durwealth landless migrationNW"
global exog3 "$exog2 waterAccess latrineSealed TLUtotal"

*tabstat $endog $endog2, by(div_name)
g byte nonResponse = shock_merge == 1
la var nonResponse "Non response to shock module"
la def resp 0 "Respondent" 1 "Non-respondent"
la var nonResponse resp 

* Non-response analysis for missing shock module; Can we predict who doesn't respond?
* Division base is Dhaka ; District base is
eststo divNR: logit nonResponse $exog2 ib(8).occupation ib(3).divName ib(3).Sample_type, robust or
lroc, nograph
predict xb1, xb

eststo distNR: logit nonResponse $exog2 ib(8).occupation ib(39).distName ib(3).Sample_type, robust or
lroc, nograph
predict xb2, xb

* Compare results from each model
roccomp nonResponse xb1 xb2, graph summary

* Create coefficient plots for the results and save it as .png
coefplot distNR, xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small) mc(black) mlsty(black) mcolor(red) mlstyle(p1) xlabel(, labsize(small)) /*
*/ title(Non-reponse Analysis Results, size(small) color(black)) scale(0.75) drop(_cons) 
graph export "$pathgraph\Non_response_analysis.png", as(png) replace

* Analyze household food consumption scores; First check for outliers and distribution of data
twoway(kdensity FCS) //looks normalish
tabsort distName, su(FCS) so(mean)  //Most of the low scores are in the north west corner of the country

*Pick a base geographic unit that is right in the middle (Jessore is 32nd in sorted rank ib(22))

* Consider OLS analysis of FCS at the household level; Use geographic fixed-effects
capture drop resid
est clear
qui eststo FCS1, title("Model 1"): reg FCS $exog1 ib(8).occupation ib(3).divName ib(3).Sample_type, robust
qui eststo FCS2, title("Model 1"): reg FCS $exog2 ib(8).occupation ib(22).distName ib(3).Sample_type, robust
qui eststo FCS3, title("Model 1"): reg FCS $exog3 ib(8).occupation i.distName ib(3).Sample_type, robust

* Plot coefficients
coefplot FCS2 || FCS3  , xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small) mc(black) mlsty(black) mcolor(red) mlstyle(p1) xlabel(, labsize(small)) /*
*/ title(OLS Results for Food Consumption Scores, size(small) color(black)) scale(0.75) drop(_cons) 

* Create a table of coefficient results
esttab, se star(* 0.10 ** 0.05 *** 0.01) label 
esttab using "$pathreg/FCS_Scores.txt", replace wide plain se mlabels(none) label 

* Check residuals for normality; Check fitstat, linktest, and ovtest
predict resid, resid
kdensity resid, normal
rvfplot2, ms(oh)
pnorm resid
qnorm resid
ovfplot

* Checking overall model diagnostics
linktest
ovtest //
vif // Check for multicollinearity


* Shock analysis; Look at shock rankings by district
tabsort distName, su(healthshk) so(mean) 
tabsort distName, su(healthshkR) so(mean) 

set more off
est clear
local endog1 "healthshk floodshk agshk assetshk finshk priceshk othershk"
local endog2 "healthshkR floodshkR agshkR assetshkR finshkR priceshkR othershkR"
local shock "health flood ag asset financial price other"
local n: word count `shock'
local i = 1
foreach x of local endog1 {
	*eststo mod`count': logit `x' $exog2 ib(8).occupation i.divName if nonResponse == 1, robust or
	local a: word `i' of `shock'
	qui eststo `a': logit `x' $exog3 ib(8).occupation i.divName ib(3).Sample_type if nonResponse == 0, robust or
	*logit healthshkR $exog2 
	*fitstat
	*lroc
	local i = `i' + 1
}
* list estimates
est dir

coefplot health || flood || ag || asset || financial || price, xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small) mc(black) mlsty(black) mcolor(red) mlstyle(p1) xlabel(, labsize(small)) /*
*/ title(Logit Shock Results, size(small) color(black)) scale(0.75) drop(_cons) 
esttab, se star(* 0.10 ** 0.05 *** 0.01) label 


* Savings accounts correlates
est clear
eststo savings: logit savings $exog3 ib(8).occupation i.divName ib(3).Sample_type

* Export a cut of data to .csv for data mining in R
keep $exog3 a01 healthshk floodshk agshk assetshk finshk priceshk othershk savings nocope goodcope /*
*/ badcope divName distName Sample_type remitOut totremitOut remitIn totremitIn landRent


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
global exog3 "$exog2 infraindex agAssetWealth durwealth cultLand livestock migrationNW ib(3).divName i.hh_type"

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
eststo uderweight, title("model 3"): xi:reg underweight $exog3, robust
eststo wasting, title("model 3"): xi:reg wasting $exog3, robust
esttab, se star(* 0.10 ** 0.05 *** 0.01) label 
esttab using "$pathreg/combinedCH.txt", replace wide plain se mlabels(none) label


coefplot stunting || uderweight || wasting, xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small) mc(black) mlsty(black) mcolor(red) mlstyle(p1) xlabel(, labsize(small))  /*
*/ title(Logit Shock Results, size(small) color(black)) scale(0.75) drop(_cons) 

* Look at the outcomes by age category
twoway (lowess stunted ageMonths, mean adjust bwidth(0.3)) /*
*/ (lowess wasted ageMonths, mean adjust bwidth(0.3)) /*
*/ (lowess underwgt ageMonths, mean adjust bwidth(0.3)),  xlabel(0(2)60,  labsize(tiny))

lpoly stunted ageMonths, deg(1) bw(.8)

* Export to R for a look in ggplot
keep stunted underwgt wasted

