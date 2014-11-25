/*-------------------------------------------------------------------------------
# Name:		05_nc
# Purpose:	Process household data and create natural capital variables
# Author:	Tim Essam, Ph.D.
# Created:	2014/11/13
# Modified: 2014/11/13
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	labutil, labutil2 (ssc install labutil, labutil2)
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/

clear
capture log close
log using "$pathlog/05_nc", replace
set more off

* Read in land holdings information
use "$pathin/010_mod_g_male.dta", clear

* Does household own land? First by plot, then total by HH
* Rolls up by plotid then a01 (hhid)

g byte cultLand = inlist(g01, 2, 8) & inlist(g08a, 72, 73, 74, 98)!=1
egen cultLandTot = total(g02) if cultLand == 1, by(a01)
egen cultLandTotValue = total(g10) if cultLand == 1, by(a01)
egen landDist = min(g03) if cultLand == 1, by(a01)
egen cultLandFlood =total(g02) if cultLand == 1 & g04>0, by(a01)
bys a01: gen pctLandFlood = cultLandFlood/cultLandTot

la var cultLandTot "Total cultivable land"
la var cultLandTotValue "Total value of cultivable land"
la var landDist "Shortest distance to cultivable land"
la var cultLand "Household owns cultivable land"
la var cultLandFlood "Total cultivable land that floods during monsoon"
la var pctLandFlood "Percent of total land flooded"

* Collapse down to hh level
keep a01 plotid cultLand cultLandTot cultLandTotValue landDist cultLandFlood pctLandFlood

include "$pathdo/copylabels.do"
collapse (max) cultLand cultLandTot cultLandTotValue landDist cultLandFlood pctLandFlood, by(a01)
include "$pathdo/attachlabels.do"

* Replace missing values with zero; Can be reverted using cultLand variable
foreach x of varlist cultLandTot cultLandTot cultLandTotValue landDist cultLandFlood pctLandFlood {
	replace `x' = 0 if `x' == .
	note `x': Missing values changed to 0; Revert with cultLand variable
}
*end

save "$pathout/nc.dta", replace

log2html "$pathlog/05_nc", replace
log close

