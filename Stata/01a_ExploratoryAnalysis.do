* Exploratory data analysis
* date: 11/4/2014

* Load the data
use "$pathin\038_mod_t1_male.dta", clear

* Merge in Module A which contains information on the geographic location
merge m:1 a01 using "$pathin\001_mod_a_male.dta"
drop if _merge==2
drop _merge

* Merge in female surveys
merge m:1 a01 using "$pathin\002_mod_a_female.dta", force

* Look at shock variables; For sorted tabulations (*ssc install tab_chi)
tabsort t1_02 t1_05 if inlist(t1_10, 1, 2)

/* Major shocks are related to medical expenses due to illness or injury (30%); Food price
shocks were common in 2011 and slightly in 2012. The 2007 floods appear to have
affected about 207 households asset base. May be interesting to see how they've recovered.*/


* what is the timing of shocks? Most med expenses incurred in Feb through October
tabsort t1_02 t1_04 if inlist(t1_10, 1, 2) & 
tab t1_02 t1_04 if inlist(t1_10, 1, 2) & t1_05 == 2011

* Create sub-aggregated shocks
* Death of a household member and most or 2nd most worst shock
g byte deathshk = (inlist(t1_02, 1, 2) & inlist(t1_10, 1, 2))

* Loss of income or medical expenses due to illness or injury
g byte healthshk = inlist(t1_02, 3, 4) & inlist(t1_10, 1, 2)

* Any flood related shock
g byte floodshk = inlist(t1_02, 6, 9, 11, 14, 16) & inlist(t1_10, 1, 2)

* Ag shocks for any reason (includes livestock and crops)
g byte agshk = inlist(t1_02, 9, 10, 11, 12, 13) & inlist(t1_10, 1, 2)

* Asset shocks (loss of productivive and non-productive assets)
g byte assetshk = inlist(t1_02, 14, 15, 16, 17) & inlist(t1_10, 1, 2)

* Financial shocks (dowry, wedding, bribes, extortion, bankruptcy, division of property, court)
g byte finshk = inlist(t1_02, 18, 19, 20, 21, 22, 25, 26, 27, 28) & inlist(t1_10, 1, 2)

* Food price shock
g byte foodshk = inlist(t1_02, 32) & inlist(t1_10, 1, 2)

* What do these look like on a district level?
foreach x of varlist *shk {
	tab district_name `x', mi
}

