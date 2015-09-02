/*-------------------------------------------------------------------------------
# Name:		10_Malnutrition
# Purpose:	Create malnutrition indicators for selected households
# Author:	Tim Essam, Ph.D.
# Created:	2014/11/25
# Modified: 2014/11/25
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	https://ideas.repec.org/c/boc/bocode/s457279.html (zscore06) 
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/
capture log close
log using "$pathlog/Malnutrition", replace
clear
use "$pathin/046_mod_w2_female.dta"

* Merge with hh details to get gender of child
merge 1:1 a01 mid using "$pathin\003_mod_b1_male.dta"
drop if _merge == 2
drop _merge
merge m:1 a01 using "$pathin/001_mod_a_male.dta"
drop if _merge ==2
drop _merge

keep a01 mid w2* b1_01 b1_02 a16_dd a16_mm a16_yy div_name /*
*/ District_Name Upazila_Name Union_Name hh_type div_name

* Clean up months
replace w2_04 = 1 if w2_04 == 0.5

* Check days in month
tab w2_02

* Calculate childrens age in months (should be under 5)
generate bday= mdy(w2_04, w2_02, w2_05)
replace bday = mdy(w2_04, 1, w2_05) if bday == .
format bday %d 

gen intday = mdy(a16_mm, a16_dd, a16_yy)
form intday %d

* Create ageMonths variable, round it off
g ageMonths = (intday - bday)/(365/12)
replace ageMonths = round(ageMonths, 1)

* How many children in household? Including those from other mothers
bys a01 (ageMonths): gen childCount = _n
bys a01 (ageMonths): gen totChild = _N
sum childCount, d
la var childCount "Order of the child"

* Create a variable marking first born or multiple children
local birthOrd "first second third fourth"
local n: word count `birthOrd'
forvalues i = 1/`n' {
	local a: word `i' of `birthOrd'
	g byte `a'Born = childCount == `i' & totChild >1
	la var `a'Born "Birth order of child (`a')"
}
g byte notFirstBorn = childCount>1 & totChild >1


* Was child born 24 months after previous one? Use w2_01 to ensure that birth is from same mother
sort a01 ageMonths
bys a01 (ageMonths): g birthGap = ageMonths[_n-1] - ageMonths if totChild>1 & w2_01[_n-1] ==w2_01
la var birthGap "Gap in months between siblings"

* Some of the values are clearly incorrect or not explanable by data (-2 month difference between births?)
* Tagginb observations where value is -24 or greater
g byte birthGap24Mos = (birthGap <= -24)
recode w2_11 (2 = 0 "no") (1 = 1 "yes"), gen(breastFed) label(bfed)

* Calculate z-scores using zscore06 package
zscore06, a(ageMonths) s(b1_01) h(w2_08) w(w2_07) measure(w2_09)

* Remove scores that are implausible
replace haz06=. if haz06<-6 | haz06>6
replace waz06=. if waz06<-6 | waz06>5
replace whz06=. if whz06<-5 | whz06>5
replace bmiz06=. if bmiz06<-5 | bmiz06>5

ren haz06 stunting
ren waz06 underweight
ren whz06 wasting
ren bmiz06 BMI

la var stunting "Stunting: Length/height-for-age Z-score"
la var underweight "Underweight: Weight-for-age Z-score"
la var wasting "Wasting: Weight-for-length/height Z-score"

g byte stunted = stunting < -2 if stunting != .
g byte underwgt = underweight < -2 if underweight != . 
g byte wasted = wasting < -2 if wasting != . 
g byte BMIed = BMI <-2 if BMI ~= . 
la var stunted "Child is stunting"
la var underwgt "Child is underweight for age"
la var wasted "Child is wasting"

sum stunted underwgt wasted

/* Values can be interpreted as standard deviations shorter/lower than
the referene population. 
A child is considered to be malnourished if her relevant z-score 
is less than –2.0.*/

la var bday "Birthday of hh member"
la var intday "Interview date"
la var ageMonth "Age of respondent in months"

* Calculate those below 2 s.d. for each score at District, Upazila, Union
foreach x of varlist stunted underwgt wasted BMI {
	egen `x'Div = mean(`x'), by(div_name)
	copydesc `x' `x'Div
	egen `x'Dist = mean(`x'), by(District_Name)
	copydesc `x' `x'Dist 
	egen `x'Upaz = mean(`x'), by(Upazila_Name)
	copydesc `x' `x'Upaz 
	egen `x'Union = mean(`x'), by(Union_Name)
	copydesc `x' `x'Union 
}
*end

* Those with scores of less than -2 are considered to be malnourished;
* use tab div_name, sum(stundedDiv) for summary stats

clonevar height = w2_08
clonevar weight = w2_07
recode b1_01 (2 = 1 "female") (1 = 0 "male"), generate(gender) label(gend) 

* Create summary statistics for use in R/
foreach x of varlist stunted underwgt wasted {
	ttest `x', by(gender)
}
*end

* Look at distribution of stunting by divisions
twoway(lowess stunted ageMonths if notFirstBorn == 0)(lowess stunted ageMonths if notFirstBorn == 1), by(div_name)
twoway (lowess stunted ageMonths, mean adjust lcolor(cranberry) lwidth(medthick) connect(direct) cmissing(y))/*
*/ (scatter stunted ageMonths, mcolor(gs14) msize(small)  mlcolor(gs12) msymbol(circle) jitter(5)), scheme(burd5)/*
*/ xlabel(0(12)60) ytitle(Percent stunted) ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%" 1 "100%")/*
*/yline(0.5, lwidth(thin) lpattern(vshortdash) lcolor(gs13)) legend(off) by(div_name, total rows(2) iscale(*0.70))

* Plot stunting rates across divisions across ages
twoway (lpolyci stunted ageMonths, clcolor(cranberry) clwidth(medium)  fintensity(25) fcolor(gs15) blcolor(gs16) blwidth(none))/*
*/ (scatter stunted ageMonths, mcolor(gs14) msize(small)  mlcolor(gs12) msymbol(circle) jitter(5)), scheme(burd5)/*
*/ xlabel(0(12)60) ytitle(Percent stunted) ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%" 1 "100%")/*
*/yline(0.5, lwidth(thin) lpattern(vshortdash) lcolor(gs13)) legend(off) by(div_name, total rows(2) iscale(*0.80))

* Create two way plot of stunting and ages, by gender across divisions
twoway (lpoly stunted ageMonths if gender == 0, clcolor(eltblue) clwidth(medium))/*
*/ (lpoly stunted ageMonths if gender == 1, clcolor(erose) clwidth(medium))/*
*/ (scatter stunted ageMonths if gender == 0, mcolor(eltblue) msize(small)  mlcolor(eltblue) msymbol(smcircle) jitter(5))/*
*/ (scatter stunted ageMonths if gender == 1, mcolor(erose) msize(small)  mlcolor(erose) msymbol(smcircle) jitter(5))/*
*/, scheme(burd5)/*
*/ xlabel(0(12)60) ytitle(Percent stunted) ylabel(0 "0%" 0.2 "20%" 0.4 "40%" 0.6 "60%" 0.8 "80%" 1 "100%")/*
*/yline(0.5, lwidth(thin) lpattern(vshortdash) lcolor(gs13)) legend(off) by(div_name, total rows(2) iscale(*0.80))

* Create an extract for making graphics in R
preserve
collapse stuntedDiv stuntedDist underwgtDiv underwgtDist wastedDiv wastedDist, by(District_Name div_name)
export delimited using "$pathexport/malnutrition.csv", replace
restore

compress
save "$pathout/ChildHealth_ind.dta", replace

* Collapse data down to household level
include "$pathdo/copylabels.do"
collapse (mean) stunted underwgt wasted BMIed (mean) stunting height weight gender /*
*/ underweight wasting, by(a01 div_name District_Name Upazila_Name Union_Name)
include "$pathdo/attachlabels.do"

save "$pathout/ChildHealth_hh.dta", replace

log2html "$pathlog/Malnutrition", replace
log close
