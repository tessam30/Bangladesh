/*-------------------------------------------------------------------------------
# Name:		05_nc
# Purpose:	Process household data and create natural capital variables
# Author:	Tim Essam, Ph.D.
# Created:	2014/11/13
# Modified: 2015/01/26
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/

clear
capture log close
log using "$pathlog/05_nc", replace
set more off

* Read in land holdings information
use "$pathin/010_mod_g_male.dta", clear

* Previous method is similar to IFPRI method but slighty over-estimates landless.
*Generate different land ownings from IFPRI Code
gen homestead=g02 if g01==1 & g11<4
gen cultland=g02 if inlist(g01, 2, 8) & g11<4
gen comercland=g02 if g01==7 & g11<4
gen otherland=g02 if inlist(g01, 3, 4, 5, 6, 9) & g11<4
gen ownland=g02 if g11<4
collapse (sum) ownland homestead-otherland, by (a01)
* no land for four housheold

egen totland = rsum (homestead-otherland)
gen diff = totland-ownland
sum diff //okay
drop totland diff

label variable ownland "total owned land in decimal (homestead, arable, comercial and other land)"
label variable homestead "Homestead land in decimal"
label variable cultland "cultivable land in decimal" 
label variable comercland "commercial/residential plot land in decimal"
label variable otherland "pasture, bush, unarable and land in river bed in decimal"

foreach x of varlist homestead-otherland {
recode `x' .=0
	}
*end

g byte landless = cultland == 0
la var landless "Household owns no cultivable land"


save "$pathout/nc.dta", replace

log2html "$pathlog/05_nc", replace
log close

