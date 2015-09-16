clear
set more off
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
* Merge in lat long for testing residuals
drop div
merge 1:1 a01 using "$pathSensitive/Geovariables.dta", gen(_mergegps)

* Export a cut of food security variable to CSV for mapping
preserve
save "$pathexport\BangladeshLVAM.dta", replace
keep a01 latitude longitude FCS FCS_categ dietDiversity  dietDiv2 foodLack  Sample_type priceshkR priceshk 
export delimited using "$pathexport\foodsecurity.csv", replace
restore

* Encode the division and district names for use as dummies
encode div_name, gen(divName)
encode District_Name, gen(distName)

* Create a wealth index in manner similar to that done for Ethiopia LSMS
local assets kaste nirani ladder rake ploughYoke reaper sprayer wheelbarrow tractor tiller trolley thresher fodderMachine swingBasket Don handWell llp stubeWell elecPump dieselPump
foreach x of local assets {
		g byte `x'Own = `x' > 1
		la var `x'Own "hh owns at least one `x'"
}

#delimit ; 
local wealthVars waterAccess latrineSealed privateWater ownHouse houseAge houseQual
	brickTinHome mudHome metalRoof dfloor electricity mobile kasteOwn niraniOwn 
	trunk bucket bed cabinet
	tableChairs fan iron radio cd clock tvclr gold bike 
	moto saw hammer fishnet spade axe shabol;
 #delimit cr 

factor `wealthVars', pcf means
predict wealthIndex
estat kmo
scree
histogram wealthIndex

xtile wealthDecile = wealthIndex, nq(10)
g byte ftfzone = inlist(Sample_type, 1, 2)
la def ftfzone 0 "non-FTFzone" 1 "ftfzone"
la val ftfzone ftfzone

* Look at how shocks and food security outcomes vary across wealth

* How do health shocks vary with wealth and ftf zones?
twoway (lpoly healthshk wealthIndex if ftfzone == 0, clcolor(eltblue) clwidth(medium))/*
*/ (lpoly healthshk wealthIndex if ftfzone == 1, clcolor(orange) clwidth(medium))/*
*/ (scatter healthshk wealthIndex if ftfzone == 0, mcolor(eltblue) msize(small)  mlcolor(eltblue) msymbol(smcircle) jitter(7))/*
*/ (scatter healthshk wealthIndex if ftfzone == 1, mcolor(orange) msize(small)  mlcolor(erose) msymbol(smcircle) jitter(7))/*
*/, scheme(burd5) /*
*/ xlabel(-2.5 "very poor" 0 "poor" 2.5 "moderately wealthy", labsize(small))/*
*/ ytitle(Percent of households with shock, size(small)) ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%" 1 "100%", labsize(small))/*
*/yline(0.5, lwidth(thin) lpattern(vshortdash) lcolor(gs13)) legend(off) /*
*/title("Health Shocks (last 5 years) are more common in Feed the Future Households", size(small))

twoway (lpoly healthshkR wealthIndex if ftfzone == 0, clcolor(eltblue) clwidth(medium))/*
*/ (lpoly healthshkR wealthIndex if ftfzone == 1, clcolor(orange) clwidth(medium))/*
*/ (scatter healthshkR wealthIndex if ftfzone == 0, mcolor(eltblue) msize(small)  mlcolor(eltblue) msymbol(smcircle) jitter(7))/*
*/ (scatter healthshkR wealthIndex if ftfzone == 1, mcolor(orange) msize(small)  mlcolor(erose) msymbol(smcircle) jitter(7))/*
*/, scheme(burd5) /*
*/ xlabel(-2.5 "very poor" 0 "poor" 2.5 "moderately wealthy", labsize(small))/*
*/ ytitle(Percent of households with shock, size(small)) ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%" 1 "100%", labsize(small))/*
*/yline(0.5, lwidth(thin) lpattern(vshortdash) lcolor(gs13)) legend(off) /*
*/title("Health Shocks (last 3 years) are more common in Feed the Future Households", size(small))

* Look at the distribution of FCS and diet diversity by district
*twoway (histogram dietDiversity, discrete), by(div_name District_Name)
*twoway (histogram dietDivFCS, discrete), by(div_name District_Name)
*twoway (kdensity FCS), by(div_name District_Name)

* Summarize the data
tabstat dietDiversity dietDiv2 dietDivFCS FCS, by(divName) stats(mean sd p25 p50 p75 n)

* Create education category variables

clonevar educAdultM_cat = educAdultM_18
recode educAdultM_cat (1 = 0) (2 = 1) (3 4 = 2)(5 6 = 3)
clonevar educAdultF_cat = educAdultF_18
recode educAdultF_cat (1 = 0) (2 = 1) (3 4 = 2)(5 6 = 3)
la def educLab 0 "No education" 1 "Primary" 2 "Secondary" 3 "Tertiary"
la val educAdultM_cat educLab
la val educAdultF_cat educLab
* Export a cut of data for Laura to use in data visualizations	
compress
sa "$pathexport/BNG_201509_all.dta", replace
export excel using "$pathxls/BNG_201509_all.xlsx", sheet("BNG_201509_all") firstrow(variables) nolabel replace

* Winsorize the cultivatable land variable to limit influence of outliers
clonevar cultland_trim = cultland
winsor2 cultland_trim, cuts(0 99) replace
clonevar logland = cultland_trim
replace logland = log(logland+1)

* Religion of household head 
clonevar religHoh = a13
recode religHoh (1 = 0) (2 3 = 1)
lab def relig 0 "Muslim" 1 "Hindu or Christian"
la val religHoh relig 
la var ftfzone "hh in ftfzone"
la var 

* Hoh primary occupation is in agriculture
g byte farmOccupHoh = inlist(occupHoh, 1, 8) == 1
la var farmOccupHoh "Hoh involved in agrarian livelihood"

* Look at the various shocks by profession (LAURA plot)
graph dot (mean) medexpshkR priceshkR agshkR hazardshkR, over(occupHoh)

* Define possible exogenous variables
global demog1 "farmOccupHoh religHoh marriedHead femhead agehead c.agehead#c.agehead i.literateHead educAdultM_18 educAdultF_18"
global demog2 "hhsize depRatio sexRatio mlabor flabor  "
global assets "i.dfloor i.electricity i.latrineSealed i.mobile"
global assets2 "landless logland i.migration" 
global assets3 "wealthIndex TLUtotal "
global geo "i.ftfzone distHealth distRoad distTown distMarket ib(3).divName ib(4).intDate"
global stderr " ,cluster(district)"
global stderr1 " ,cluster(uncode)"
global FCSprice "FCS_price_staples FCS_price_pulse FCS_price_veg FCS_price_fruit FCS_price_fish FCS_price_dairy FCS_price_sugar FCS_price_fats"




******************
* Medical shocks *
******************
mean medexpshkR priceshkR hazardshkR agshkR



est clear
eststo med1, title("Medical 1"): reg medexpshkR $demog1 $demog2 $assets $assets2 $assets3 $geo $stderr 
cap byte reg_sample = e(sample)
eststo med2, title("Medical 2"): reg medexpshkR $demog1 $demog2 $assets2 $assets3 $geo $stderr

eststo price1, title("Price 1"): reg priceshkR $demog1 $demog2 $assets $assets2 $assets3 $geo $stderr 
eststo price2 , title("Price 2"): reg priceshkR $demog1 $demog2 $assets2 $assets3 $geo $stderr

eststo haz1, title("Hazard 1"): reg hazardshkR $demog1 $demog2 $assets $assets2 $assets3 $geo $stderr
eststo haz2, title("Hazard 2"): reg hazardshkR $demog1 $demog2 $assets2 $assets3 $geo $stderr

eststo ag1, title("Ag 1"): reg agshkR $demog1 $demog2 $assets $assets2 $assets3 $geo $stderr
eststo ag2, title("Ag 2"): reg agshkR $demog1 $demog2 $assets2 $assets3 $geo $stderr

la var reg_sample "Sample used in regressions"
esttab *














***************************
* Food Consumption Scores *
***************************

* Set dietary diversity price macro to obtain all food groups
#delimit ;
global DDprice "dd_price_wheat dd_price_rice dd_price_starch dd_price_cereal dd_price_vegetables 
		dd_price_fruit dd_price_beans dd_price_eggs dd_price_dairy dd_price_meat dd_price_poultry 
		dd_price_fish dd_price_fats dd_price_sugar dd_price_condiments dd_price_nuts dd_price_tobacco";
#delimit cr

* Model food consumption score as an OLS, using robust standard errors
est clear
qui eststo fcs, title("FCS OLS"): reg FCS $ddexog1 $FCSprice, vce(robust)  
qui eststo fcs2, title("FCS OLS"): reg FCS $ddexog2 $FCSprice, vce(robust) 
qui eststo fcs3, title("FCS OLS"): reg FCS $ddexog3 $FCSprice, vce(robust)  
qui eststo fcs3, title("FCS OLS"): reg FCS $ddexog3 $FCSprice  $geo, vce(robust) 
est stats fcs*

esttab, se star(* 0.10 ** 0.05 *** 0.01) label 

esttab using "$pathreg/FCS.OLS.txt", replace wide plain se mlabels(none) label

* Create a coefficient plot of the main covariates
coefplot fcs || fcs2 || fcs3 , xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small) /*mc(black) mlsty(black) mcolor(red) mlstyle(p1)*/ xlabel(, labsize(small)) cismooth norecycle/*
*/ scale(1) drop(_cons) keep($ddexog3 $FCSprice) base


coefplot fcs fcs2 fcs3, xline(1, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small)  xlabel(, labsize(small)) cismooth /*
*/ scale(1) drop(_cons) keep($ddexog3 $FCSprice) 

* Only looking at geographic effects
coefplot fcs1 || fcs2 || fcs3 , xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small) mc(black) mlsty(black) mcolor(red) mlstyle(p1) xlabel(, labsize(small)) /*
*/ title(OLS Results for Dietary Diversity, size(small) color(black)) scale(0.75) drop(_cons) keep($geo)

/* Food Consumption Score is a weighted frequency of consumption of eight food groups at by the household. The metric 
represents both dietary diversity and freqency dimensions of food consumption. */


*#############*
* Low Scores  *
*#############*

* Create a binary variable indicating Low food consumption scores 
g byte lowFCS = inlist(FCS_categ, 0, 1) == 1 
qui eststo lowfcs, title("FCS OLS"): logit lowFCS $ddexog1 $FCSprice, vce(robust) or
qui eststo lowfcs1, title("FCS OLS"): logit lowFCS $ddexog1 $FCSprice  $geo, vce(robust) or
qui eststo lowfcs2, title("FCS OLS"): logit lowFCS $ddexog2 $FCSprice  $geo, vce(robust) or
qui eststo lowfcs3, title("FCS OLS"): logit lowFCS $ddexog3 $FCSprice  $geo, vce(robust) or

esttab, eform se star(* 0.10 ** 0.05 *** 0.01) label 

coefplot lowfcs || lowfcs1 || lowfcs2 || lowfcs3 , xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small) cismooth norecycle xlabel(, labsize(small)) /*
*/ title(Logit Results for low FCS, size(small) color(black)) scale(0.75) drop(_cons) keep($ddexog3 $FCSprice)

coefplot lowfcs lowfcs1 lowfcs2 lowfcs3 , xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small) cismooth norecycle xlabel(, labsize(small)) /*
*/ title(Logit Results for low FCS, size(small) color(black)) scale(0.75) drop(_cons) keep($ddexog3 $FCSprice)

*********************
* Dietary Diversity *
*********************

* Look at dietary diversity and how outcomes compare with Food Consumption Scores
est clear
qui eststo dd, title("Diet Diversity OLS"): reg dietDiversity $ddexog1 $DDprice, vce(robust)
qui eststo dd1, title("Diet Diversity OLS"): reg dietDiversity $ddexog1 $DDprice $geo, vce(robust)
qui eststo dd2, title("Diet Diversity OLS"): reg dietDiversity $ddexog2 $DDprice $geo, vce(robust)
qui eststo dd3, title("Diet Diversity OLS"): reg dietDiversity $ddexog3 $DDprice $geo, vce(robust)

esttab, se star(* 0.10 ** 0.05 *** 0.01) label 
esttab using "$pathreg/DietDiversity.OLS.txt", replace wide plain se mlabels(none) label

coefplot dd || dd1 || dd2 || dd3 , xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small)  xlabel(, labsize(small)) cismooth /*
*/ scale(1) drop(_cons) keep($ddexog3 $FCSprice) 

est clear 
qui eststo ddPOI: poisson dietDiversity $ddexog1 $DDprice, vce(robust)
qui eststo ddTPOI: tpoisson dietDiversity $ddexog3 $DDprice, ll(0) vce(robust)
qui eststo ddTPOI2: tpoisson dietDiversity $ddexog3 $DDprice $geo, ll(0) vce(robust) 

esttab, se star(* 0.10 ** 0.05 *** 0.01) label 
esttab using "$pathreg/DietDiversity.Poisson.txt", replace wide plain se mlabels(none) label

coefplot ddPOI  ddTPOI ddTPOI2, xline(1, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small)  xlabel(, labsize(small)) cismooth /*
*/ scale(1) drop(_cons) keep($ddexog3 $FCSprice) eform

****************
* Lacking food *
****************

*What determines whether or not food is lacking within a household?
eststo fl1: logit foodLack $ddexog1 $FCSprice, or robust
eststo fl2: logit foodLack $ddexog3 $FCSprice, or robust
eststo fl2: logit foodLack $ddexog3 $FCSprice i.divName, or robust

*STOPPED HERE

* Malnutrition

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
