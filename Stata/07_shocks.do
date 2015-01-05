/*-------------------------------------------------------------------------------
# Name:		07_shocks
# Purpose:	Process household data and create positive and negative shock vars
# Author:	Tim Essam, Ph.D.
# Created:	2014/11/14
# Modified: 2014/11/14
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	tabsort, 
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/

* Exploratory data analysis
* date: 11/4/2014
capture log close
log using "$pathlog/07_shocks", replace

set more off
* Load the data for negative shocks
use "$pathin\038_mod_t1_male.dta", clear

* Look at shock variables; For sorted tabulations (*ssc install tab_chi)
tabsort t1_02 t1_05 if inlist(t1_10, 1, 2), mi

/* Major shocks are related to medical expenses due to illness or injury (30%); Food price
shocks were common in 2011 and slightly in 2012. The 2007 floods appear to have
affected about 207 households asset base. May be interesting to see how they've recovered.
*/

* what is the timing of shocks? Most med expenses incurred in Feb through October
tab t1_02 t1_04 if inlist(t1_10, 1, 2) & t1_05 == 2011

/* Create sub-aggregated shocks, criteria follow:
1) Shock must be listed as worst or 2nd worst
2) Shocks can have occured anytime in last 5 years or recent 3 years
3) Shocks are aggregated up to general categories to help w/ power
*/

*Total shocks in past 5 years of any type
bys a01: g shkTot = _N
la var shkTot "Total shocks reported of all types"

egen shkLossTot = total(t1_07), by(a01)
la var shkLossTot "Total value of loss due to shocks"

egen shkLossTotR = total(t1_07) if inlist(t1_05, 2010, 2011, 2012), by(a01)
*replace shkLossTotR = 0 if shkLossTotR==.
la var shkLossTot "Total value of loss due to shocks in last 5 years"
la var shkLossTotR "Total value of loss due to shocks in last 3 years"

** Please refer to crosswalk **
* Loss of income or medical expenses due to illness, injury, or death.
g byte healthshk = inlist(t1_02, 1, 2, 3, 4) & inlist(t1_10, 1, 2)
g byte healthshkR = inlist(t1_02, 1, 2, 3, 4) & inlist(t1_10, 1, 2) & inlist(t1_05, 2010, 2011, 2012)
la var healthshk "Loss of income or medical expenses due to illness or injury"
la var healthshkR "Loss of income or medical expenses due to illness or injury in last 3 years"

* Because of frequency create annual health shock dummy
foreach x of numlist 2007(1)2012 { //ac (2)
	g byte healthshk`x' =inlist(t1_02, 1, 2, 3, 4) & inlist(t1_10, 1, 2) & t1_05 == `x'
	la var healthshk`x' "Health shock in `x'"
	}
*end

* See if health shocks are recurring in same HH
*foreach x of numlist 2007(1)2012 {
*	g tmpshk`x' = inlist(t1_02, 1, 2, 3, 4) & inlist(t1_10, 1, 2) & t1_05 == `x'
*}	//ac (2)
*end
egen healthshkHist = rsum(healthshk2007 healthshk2008 healthshk2009 healthshk2010 healthshk2011 healthshk2012) //ac (2) 
la var healthshkHist "Number of total health shocks in last 5 years"
*drop tmpshk* //ac (2) 

* Any flood related shock (includes loss of livestock and crops specifically due to flood)
g byte floodshk = inlist(t1_02, 6, 9, 11, 14, 16) & inlist(t1_10, 1, 2)
g byte floodshkR = inlist(t1_02, 6, 9, 11, 14, 16) & inlist(t1_10, 1, 2) & inlist(t1_05, 2010, 2011, 2012)
g byte floodshk2007 = inlist(t1_02, 6, 9, 11, 14, 16) & inlist(t1_10, 1, 2) & inlist(t1_05, 2007)
la var floodshk "Any flood related shock"
la var floodshkR "Any flood related shock in last 3 years"
la var floodshk2007 "Flood related shock in 2007 (Cyclone Sidr)"

* Ag shocks for any reason (includes livestock and crops)
g byte agshk = inlist(t1_02, 9, 10, 11, 12, 13) & inlist(t1_10, 1, 2) 
g byte agshkR = inlist(t1_02, 9, 10, 11, 12, 13) & inlist(t1_10, 1, 2) & inlist(t1_05, 2010, 2011, 2012)
la var agshk "Any type of agricultural shock"
la var agshkR "Any type of agricultural shock in last 3 years"

* Asset shocks (loss of productivive and non-productive assets)
g byte assetshk = inlist(t1_02, 14, 15, 16, 17) & inlist(t1_10, 1, 2) 
g byte assetshkR = inlist(t1_02, 14, 15, 16, 17) & inlist(t1_10, 1, 2) & inlist(t1_05, 2010, 2011, 2012)
la var assetshk "Loss of productive and non-productive assets"
la var assetshkR "Loss of productive and non-productive assets in last 3 years"

* Financial shocks (dowry, wedding, bribes, extortion, bankruptcy, division of property, court)
g byte finshk = inlist(t1_02, 1, 3, 4, 5, 18, 19, 20, 21, 22, 25, 26, 27, 28, 30, 31) & inlist(t1_10, 1, 2) //ac (3)
g byte finshkR = inlist(t1_02, 1, 3, 4, 5, 18, 19, 20, 21, 22, 25, 26, 27, 28, 30, 31) & inlist(t1_10, 1, 2) & inlist(t1_05, 2010, 2011, 2012) //ac (3)
la var finshk "Any type of financial shock (dowry, wedding, bribes, extortion...etc)"
la var finshkR "Any type of financial shock (dowry, wedding, bribes, extortion...etc)"

* Food price shock
g byte priceshk = inlist(t1_02, 32, 33) & inlist(t1_10, 1, 2)  //ac(4)
g byte priceshkR = inlist(t1_02, 32, 33) & inlist(t1_10, 1, 2) & inlist(t1_05, 2010, 2011, 2012) //ac(4)
la var priceshk "Price shock"
la var priceshkR "Price shock in last 3 years"

* Other shocks
g byte othershk = inlist(t1_02, 7, 8, 23, 24, 29, 34, 35) & inlist(t1_10, 1, 2) 
g byte othershkR = inlist(t1_02, 7, 8, 23, 24, 29, 34, 35) & inlist(t1_10, 1, 2) & inlist(t1_05, 2010, 2011, 2012)
la var othershk "Other shocks including eviction, divorce, arrested, prision, other"
la var othershkR "Other shocks including eviction, divorce, arrested, prision, other in last 3 years"

* Calculate total loss value of each type of shock & coping strategy
foreach x of varlist healthshk floodshk agshk assetshk finshk priceshk {
	egen `x'Tot = total(t1_07) if `x' == 1, by(a01)
	la var `x'Tot "Total loss value of `x'"
	egen `x'RTot = total(t1_07) if `x'R == 1, by(a01)
	la var `x'RTot "Total loss value of `x'"
}
*end

/* Coping Mechanisms - What are good v. bad coping strategies? From (Heltberg et al., 2013)
	http://siteresources.worldbank.org/EXTNWDR2013/Resources/8258024-1352909193861/
	8936935-1356011448215/8986901-1380568255405/WDR15_bp_What_are_the_Sources_of_Risk_Oviedo.pdf
	Good Coping:: use of savings, credit, asset sales, additional employment, 
					migration, and assistance
	Bad Coping : increases vulnerabiliy* compromising health and edudcation 
				expenses, productive asset sales, conumsumption reductions 
	NOTE: Codebook pp 75 of survey has inconsistencies with the data.
				*/
				
g byte nocope =   t1_08a == 1
g byte goodcope = inlist(t1_08a|t1_08b, 6, 7, 8, 9, 13, 19, 20, 21, 22, 23, 24) | ///
	inlist(t1_08b, 6, 7, 8, 9, 13, 19, 20, 21, 22, 23, 24) | ///
	inlist(t1_08c, 6, 7, 8, 9, 13, 19, 20, 21, 22, 23, 24) // ac(6)
g byte badcope =  inlist(t1_08a, 2, 3, 4, 5, 10, 11, 12, 14, 15, 16, 17, 18) | ///
	inlist(t1_08b, 2, 3, 4, 5, 10, 11, 12, 14, 15, 16, 17, 18) | ///
	inlist(t1_08c, 2, 3, 4, 5, 10, 11, 12, 14, 15, 16, 17, 18) // ac(6)
g byte loancopeNGO = inlist(t1_08a, 8) | inlist(t1_08b, 89) | inlist(t1_08c, 9) // ac(6 & 7)
g byte loancopeMahajan = inlist(t1_08a, 9) | inlist(t1_08b, 9) | inlist(t1_08c, 9) // ac(6)

g byte nocopeR =   t1_08a == 1 & inlist(t1_05, 2010, 2011, 2012)
g byte goodcopeR = (inlist(t1_08a, 6, 7, 8, 9, 13, 19, 20, 21, 22, 23, 24) | ///
	inlist(t1_08b, 6, 7, 8, 9, 13, 19, 20, 21, 22, 23, 24) | ///
	inlist(t1_08c, 6, 7, 8, 9, 13, 19, 20, 21, 22, 23, 24)) & ///
	inlist(t1_05, 2010, 2011, 2012)  //ac(6)
g byte badcopeR =  (inlist(t1_08a, 2, 3, 4, 5, 10, 11, 12, 14, 15, 16, 17, 18) | ///
	inlist(t1_08b, 2, 3, 4, 5, 10, 11, 12, 14, 15, 16, 17, 18) | ///
	inlist(t1_08c, 2, 3, 4, 5, 10, 11, 12, 14, 15, 16, 17, 18)) & ///
	inlist(t1_05, 2010, 2011, 2012) //ac(6)
g byte loancopeNGOR = (inlist(t1_08a, 8) | inlist(t1_08b, 8) | inlist(t1_08c, 8)) & ///
	inlist(t1_05, 2010, 2011, 2012) //ac(6 & 7)
g byte loancopeMahajanR = (inlist(t1_08a, 9) | inlist(t1_08b, 9) | inlist(t1_08c, 9)) & ///
	inlist(t1_05, 2010, 2011, 2012) //ac(6)

la var nocope "No coping strategy used by hh"
la var goodcope "Good coping strategy"
la var badcope "Bad coping strategy"
la var loancopeNGO "To cope take NGO loan"
la var loancopeMahajan "To cope take money lender loan"

la var nocopeR "No coping strategy used by hh in last 3 years"
la var goodcopeR "Good coping strategy in last 3 years"
la var badcopeR "Bad coping strategy in last 3 years"
la var loancopeNGOR "To cope take NGO loan in last 3 years"
la var loancopeMahajanR "To cope take money lender loan in last 3 years"

* Collapse data down to household level making everything wide
qui ds (t1*), not
keep `r(varlist)'

* Collapse down to hh
include "$pathdo/copylabels.do"
qui ds(a01 sample_type), not
collapse (max) `r(varlist)', by(a01)
include "$pathdo/attachlabels.do"

* Save as negative shocks
save "$pathout/negshocks.dta", replace

** Load positive shock data **
use "$pathin/039_mod_t2_male.dta", clear

* Create positive shock variables
g byte edshkpos = inlist(t2_02, 7, 9, 10) & inlist(t2_07, 1, 2) & t2_03 == 1 //ac(8)
la var edshkpos "Positive educational income shock"
egen edshkTot = total(t2_06) if edshkpos == 1, by(a01)
la var edshkTot "Total value of educational shock"

* Replace zeros with stipend values listed in question (100 taka)
replace edshkTot = edshkTot+100 if t2_02==9 & t2_03==1 //ac(9)

g byte finshkpos = inlist(t2_02, 2, 3, 4, 5) & inlist(t2_07, 1, 2) & t2_03 == 1
la var finshkpos "Positive financial shock not employment related"
egen finshkTot = total(t2_06) if finshkpos == 1, by(a01)
la var finshkTot "Total value of financial shock"

g byte bizshkpos = inlist(t2_02, 1, 6) & inlist(t2_07, 1, 2) & t2_03 == 1
la var bizshkpos "Positive income shock related to employment or business"
egen bizshkTot = total(t2_06) if bizshkpos == 1, by(a01)
la var bizshkTot "Total value of business/employment shock"

qui ds (t2*), not
keep `r(varlist)'

* Collapse down to hh
include "$pathdo/copylabels.do"
ds(a01 sample_type), not
collapse (max) `r(varlist)', by(a01)
include "$pathdo/attachlabels.do"

* Merge with negative shock data
merge 1:1 a01 using "$pathout/negshocks.dta", gen(shock_merge)

* Merge collapsed data back with 
* Merge in hh roster (just hhid) to compute zeros for missing households (are they missing at random?)
merge m:1 a01 using "$pathout\hhid.dta", gen(hhID_merge)
merge 1:1 a01 using "$pathin/001_mod_a_male.dta", gen(miss_merge)
bob

/* NOTE: Assuming that missing information is equivalent to zero; Validate for all vars */
* Note missingness in variables: Mostly related to asset losses
mdesc 

* Replace missing information with zeros noting potential introduction of bias here.
ds , not(type string) //ac(10)
foreach x of varlist `r(varlist)' { //ac(10)
	}
*end

* Add a note to dataset
notes: 2,976 were not included in shock module (unsure why). Setting to zero for now.

* Save
save "$pathout/shocks.dta", replace
log2html "$pathlog/07_shocks", replace
log close
