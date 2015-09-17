/*-------------------------------------------------------------------------------
# Name:		101_RegressionAnalysis
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

local yvar agshkR
twoway (lpoly `yvar' wealthIndex if ftfzone == 0, clcolor(eltblue) clwidth(medium))/*
*/ (lpoly `yvar' wealthIndex if ftfzone == 1, clcolor(orange) clwidth(medium))/*
*/ (scatter `yvar' wealthIndex if ftfzone == 0, mcolor(eltblue) msize(small)  mlcolor(eltblue) msymbol(smcircle) jitter(7))/*
*/ (scatter `yvar' wealthIndex if ftfzone == 1, mcolor(orange) msize(small)  mlcolor(erose) msymbol(smcircle) jitter(7))/*
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
tabstat dietDiversity dietDiv dietDivFCS FCS, by(divName) stats(mean sd p25 p50 p75 n)

* Create education category variables and replace hh with no males as having 0 male educ 
clonevar educAdultM_cat = educAdultM_18
recode educAdultM_cat (1 = 0) (2 = 1) (3 4 = 2)(5 6 = 3)
tab femhead if educAdultM_cat == .
replace educAdultM_cat = 0 if educAdultM_cat == .

clonevar educAdultF_cat = educAdultF_18
recode educAdultF_cat (1 = 0) (2 = 1) (3 4 = 2)(5 6 = 3)
la def educLab 0 "No education" 1 "Primary" 2 "Secondary" 3 "Tertiary"
la val educAdultM_cat educLab
la val educAdultF_cat educLab
* Export a cut of data for Laura to use in data visualizations	
compress
sa "$pathexport/BNG_201509_all.dta", replace
*export excel using "$pathxls/BNG_201509_all.xlsx", sheet("BNG_201509_all") firstrow(variables) nolabel replace

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

* Collapsing tertiary education into primary b/c of few obs w/ tertiary
recode educAdultM_cat (3 = 2), gen(educAdultM_cat2)
recode educAdultF_cat (3 = 2), gen(educAdultF_cat2)

* TLUs have a really fat right tail, winsorizing values so outliers are not driving results
clonevar TLUtotal_trim = TLUtotal
winsor2 TLUtotal_trim, cuts(0 99.9) replace
sum TLU*

* Hoh primary occupation is in agriculture
g byte farmOccupHoh = inlist(occupHoh, 1, 8) == 1
la var farmOccupHoh "Hoh involved in agrarian livelihood"

* Look at the various shocks by profession (LAURA plot)
graph dot (mean) medexpshkR priceshkR agshkR hazardshkR, over(occupHoh)

* Define possible exogenous variables
global demog1 "farmOccupHoh religHoh marriedHead femhead agehead c.agehead#c.agehead i.literateHead i.educAdultM_cat2 i.educAdultF_cat2"
global demog2 "hhsize depRatio sexRatio mlabor flabor  "
global assets "i.dfloor i.electricity i.latrineSealed i.mobile"
global assets2 "landless logland i.migration" 
global assets3 "wealthIndex TLUtotal_trim "
global geo "ib(1).ftfzone distHealth c.distHealth#c.distHealth distRoad c.distRoad#c.distRoad distMarket c.distMarket#c.distMarket ib(3).divName ib(4).intDate"
global geo1 "ib(1).ftfzone distHealth distRoad distMarket ib(3).divName ib(4).intDate"
*global stderr " , cluster(district)"
global stderr1 " , cluster(uncode)"
global modeltype "reg"

******************
* Medical shocks *
******************
table divName, c(mean medexpshkR mean priceshkR mean hazardshkR mean agshkR)
set showbaselevels off, permanently
* Household surveys are conducted at the uncode level, thus any correlation that may be present
* would appear at this lower level. For this reason, we cluster at the uncode level

est clear
eststo med1, title("Medical 1"):  $modeltype medexpshkR $demog1 $demog2 $assets $assets2 $geo $stderr1 
cap gen byte reg_sample = e(sample)
linktest
eststo med2, title("Medical 2"): $modeltype medexpshkR $demog1 $demog2 $assets2 $assets3 $geo $stderr1
linktest

eststo haz1, title("Hazard 1"): $modeltype hazardshkR $demog1 $demog2 $assets $assets2  $geo $stderr1
linktest
eststo haz2, title("Hazard 2"): $modeltype hazardshkR $demog1 $demog2 $assets2 $assets3 $geo $stderr1
linktest

eststo ag1, title("Ag 1"): $modeltype agshkR $demog1 $demog2 $assets $assets2 $geo $stderr1
linktest
eststo ag2, title("Ag 2"): $modeltype agshkR $demog1 $demog2 $assets2 $assets3 $geo $stderr1
linktest

la var reg_sample "Sample used in regressions"
esttab * 


coefplot med1 ||  haz1 || ag1  ,  xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small) /*mc(black) mlsty(black) mcolor(red) mlstyle(p1)*/ xlabel(, labsize(small)) cismooth norecycle/*
*/ scale(1) drop(_cons) 

coefplot med1 || med2 ,  xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
*/ msize(small) /*mc(black) mlsty(black) mcolor(red) mlstyle(p1)*/ xlabel(, labsize(small)) /*
*/ levels(99 95 90 80) ciopts(lwidth(1 ..) lcolor(*.25 *.5 *.75 *1)) /*
*/ legend(order(1 "99" 2 "95" 3 "90" 4 "80") row(1)) /*
*/ scale(1) drop(_cons) 

preserve
clonevar shkLossTotR_trim = shkLossTotR
winsor2 shkLossTotR_trim, cuts(0 98) replace
keep latitude longitude a01 medexpshkR priceshkR agshkR hazardshkR goodcopeR badcopeR nocopeR FCS dietDiv ftfzone wealthIndex reg_sample /*
*/ medExpShk2007 medExpShk2008 medExpShk2009 medExpShk2010 medExpShk2011 shkLossTotR_trim edshkpos mobile 
export delimited using "$pathexport/BNG_201509_kriging.csv", replace
restore

* Run Price regression separetely because of lack of spatial variation
eststo price1, title("Price 1"): $modeltype priceshkR $demog1 $demog2 $assets $assets2 /*
*/ ib(3).divName if inlist(divName, 1, 2, 3, 6 ) $stderr1 
linktest
eststo price2 , title("Price 2"): $modeltype priceshkR $demog1 $demog2 $assets2 $assets3 /*
*/ ib(3).divName if inlist(divName, 1, 2, 3, 6 ) $stderr1
linktest

* Export same cut of data to WVU folks for GWRs
preserve
keep farmOccupHoh religHoh marriedHead femhead agehead literateHead educAdultM_cat2 educAdultF_cat2 /*
*/ hhsize depRatio sexRatio mlabor flabor dfloor electricity latrineSealed mobile landless logland  /*
*/ migration wealthIndex TLUtotal_trim distHealth distRoad distMarket medexpshkR priceshkR agshkR  /*
*/ hazardshkR dietDiv FCS a01
export excel using "$pathexport\BNG_201509_GWR.xls", sheet("BNG_GWR") firstrow(variables) nolabel replace
restore

* Export a copy of the dataset to R for spatial filter models
preserve
keep farmOccupHoh religHoh marriedHead femhead agehead literateHead educAdultM_cat2 educAdultF_cat2 /*
*/ hhsize depRatio sexRatio mlabor flabor dfloor electricity latrineSealed mobile landless logland  /*
*/ migration wealthIndex TLUtotal_trim distHealth distRoad distMarket medexpshkR priceshkR agshkR  /*
*/ hazardshkR dietDiv FCS a01 latitude longitude 
saveold "$pathout/BGD_201509_SpatFilter.dta", replace version(13)
restore
bob




***************************
* Food Consumption Scores *
***************************

* Set dietary diversity price macro to obtain all food groups
* Run three types of models to check robustness of estimates; Not worry about potential endogeneity of wealth for now 
* Can think about instrumenting for it later or even instrumenting for pcexpenditures
eststo dd1, title("Diet Diversity 1"): $modeltype dietDiv $demog1 $demog2 $assets $assets2  $geo  FCS_price* $stderr1
eststo dd2, title("Diet Diversity 2"): $modeltype dietDiv $demog1 $demog2 $assets2 $assets3 $geo  FCS_price* $stderr1
eststo ddPOI: poisson dietDiv $demog1 $demog2 $assets $assets2  $geo FCS_price*, vce(robust)
eststo ddPOI2: poisson dietDiv $demog1 $demog2 $assets2 $assets3 $geo FCS_price*, vce(robust)
eststo ddTPOI: tpoisson dietDiv $demog1 $demog2 $assets $assets2  $geo FCS_price*, ll(0) vce(robust)
eststo ddTPOI2: tpoisson dietDiv $demog1 $demog2 $assets2 $assets3 $geo FCS_price*, ll(0) vce(robust)
esttab dd*

/* Main conclusions
1) female education has large effects
2) Assets (dirt floor negative correlation; electricity and mobile phones good)
3) TLU and Wealth Index strongly signficant (as expected)
4) Households interviewed in October and November have significantly lower DD;
5) Rangpur & Khulna lower DD


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

/* Look at dietary diversity and how outcomes compare with Food Consumption Scores
est clear
qui eststo dd, title("Diet Diversity OLS"): reg dietDiversity $ddexog1 $DDprice, vce(robust)
qui eststo dd1, title("Diet Diversity OLS"): reg dietDiversity $ddexog1 $DDprice $geo, vce(robust)
qui eststo dd2, title("Diet Diversity OLS"): reg dietDiversity $ddexog2 $DDprice $geo, vce(robust)
qui eststo dd3, title("Diet Diversity OLS"): reg dietDiversity $ddexog3 $DDprice $geo, vce(robust)

esttab, se star(* 0.10 ** 0.05 *** 0.01) label 
esttab using "$pathreg/DietDiversity.OLS.txt", replace wide plain se mlabels(none) label

coefplot dd || dd1 || dd2 || dd3 , xline(0, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
 	msize(small)  xlabel(, labsize(small)) cismooth /*
	scale(1) drop(_cons) keep($ddexog3 $FCSprice) 

est clear 
qui eststo ddPOI: poisson dietDiversity $ddexog1 $DDprice, vce(robust)
qui eststo ddTPOI: tpoisson dietDiversity $ddexog3 $DDprice, ll(0) vce(robust)
qui eststo ddTPOI2: tpoisson dietDiversity $ddexog3 $DDprice $geo, ll(0) vce(robust) 

esttab, se star(* 0.10 ** 0.05 *** 0.01) label 
esttab using "$pathreg/DietDiversity.Poisson.txt", replace wide plain se mlabels(none) label

coefplot ddPOI  ddTPOI ddTPOI2, xline(1, lwidth(thin) lcolor(gray)) mlabs(small) ylabel(, labsize(tiny)) /*
	msize(small)  xlabel(, labsize(small)) cismooth /*
	scale(1) drop(_cons) keep($ddexog3 $FCSprice) eform

****************
* Lacking food *
****************

*What determines whether or not food is lacking within a household?
eststo fl1: logit foodLack $ddexog1 $FCSprice, or robust
eststo fl2: logit foodLack $ddexog3 $FCSprice, or robust
eststo fl2: logit foodLack $ddexog3 $FCSprice i.divName, or robust

*STOPPED HERE

* Malnutrition







