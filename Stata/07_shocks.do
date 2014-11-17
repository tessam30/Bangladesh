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

* Load the data for negative shocks
use "$pathin\038_mod_t1_male.dta", clear

* Look at shock variables; For sorted tabulations (*ssc install tab_chi)
tabsort t1_02 t1_05 if inlist(t1_10, 1, 2)

/* Major shocks are related to medical expenses due to illness or injury (30%); Food price
shocks were common in 2011 and slightly in 2012. The 2007 floods appear to have
affected about 207 households asset base. May be interesting to see how they've recovered.*/

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
replace shkLossTotR = 0 if shkLossTotR==.
la var shkLossTot "Total value of loss due to shocks in last 5 years"
la var shkLossTotR "Total value of loss due to shocks in last 3 years"

** Please refer to crosswalk **
* Loss of income or medical expenses due to illness, injury, or death.
g byte healthshk = inlist(t1_02, 1, 2, 3, 4) & inlist(t1_10, 1, 2)
g byte healthshkR = inlist(t1_02, 1, 2, 3, 4) & inlist(t1_10, 1, 2) & inlist(t1_05, 2010, 2011, 2012)
la var healthshk "Loss of income or medical expenses due to illness or injury"
la var healthshkR "Loss of income or medical expenses due to illness or injury in last 3 years"

* See if health shocks are recurring in same HH
foreach x of numlist 2007(1)2012 {
	g tmpshk`x' = inlist(t1_02, 1, 2, 3, 4) & inlist(t1_10, 1, 2) & t1_05 == `x'
}	
*end
egen healthshkHist = rsum(tmpshk2007 tmpshk2008 tmpshk2009 tmpshk2010 tmpshk2011 tmpshk2012)
la var healthshkHist "Number of total health shocks in last 5 years"
drop tmpshk*

* Any flood related shock (includes loss of livestock and crops specifically due to flood)
g byte floodshk = inlist(t1_02, 6, 9, 11, 14, 16) & inlist(t1_10, 1, 2)
g byte floodshkR = inlist(t1_02, 6, 9, 11, 14, 16) & inlist(t1_10, 1, 2) & inlist(t1_05, 2010, 2011, 2012)
la var floodshk "Any flood related shock"
la var floodshkR "Any flood related shock in last 3 years"

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
g byte finshk = inlist(t1_02, 5, 18, 19, 20, 21, 22, 25, 26, 27, 28, 30, 31) & inlist(t1_10, 1, 2) 
g byte finshkR = inlist(t1_02, 5, 18, 19, 20, 21, 22, 25, 26, 27, 28, 30, 31) & inlist(t1_10, 1, 2) & inlist(t1_05, 2010, 2011, 2012)
la var finshk "Any type of financial shock (dowry, wedding, bribes, extortion...etc)"
la var finshkR "Any type of financial shock (dowry, wedding, bribes, extortion...etc)"

* Food price shock
g byte priceshk = inlist(t1_02, 32, 33) & inlist(t1_10, 1, 2) 
g byte priceshkR = inlist(t1_02, 32) & inlist(t1_10, 1, 2) & inlist(t1_05, 2010, 2011, 2012)
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
	Good Coping:: use of savings, credit, asset sales, additional employment, 
					migration, and assistance
	Bad Coping : increases vulnerabiliy* compromising health and edudcation 
				expenses, productive asset sales, conumsumption reductions 
	NOTE: Codebook pp 75 of survey has inconsistencies with the data.
				*/
				
g byte nocope =   t1_08a == 1
g byte goodcope = inlist(t1_08a, 6, 7, 8, 9, 13, 19, 20, 21, 22, 23, 24) 
g byte badcope =  inlist(t1_08a, 2, 3, 4, 5, 10, 11, 12, 14, 15, 16, 17, 18) 
g byte loancopeNGO = inlist(t1_08a, 9)
g byte loancopeMahajan = inlist(t1_08a, 9)

g byte nocopeR =   t1_08a == 1 & inlist(t1_05, 2010, 2011, 2012)
g byte goodcopeR = inlist(t1_08a, 6, 7, 8, 9, 13, 19, 20, 21, 22, 23, 24)  & inlist(t1_05, 2010, 2011, 2012)
g byte badcopeR =  inlist(t1_08a, 2, 3, 4, 5, 10, 11, 12, 14, 15, 16, 17, 18) & inlist(t1_05, 2010, 2011, 2012)
g byte loancopeNGOR = inlist(t1_08a, 9) & inlist(t1_05, 2010, 2011, 2012)
g byte loancopeMahajanR = inlist(t1_08a, 9) & inlist(t1_05, 2010, 2011, 2012)

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
ds(a01 sample_type), not
collapse (max) `r(varlist)', by(a01)
include "$pathdo/attachlabels.do"


* Merge in Module A which contains information on the geographic location
merge m:1 a01 using "$pathin\001_mod_a_male.dta"
drop if _merge==2
drop _merge

* Merge in female surveys
merge m:1 a01 using "$pathin\002_mod_a_female.dta", force

* What do these look like on a district level? *Do any appear to be village-wide?
foreach x of varlist *shk {
	tab district_name `x', mi
}
*end


