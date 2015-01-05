/*-------------------------------------------------------------------------------
# Name:		10_WomensStatus
# Purpose:	Women's domestic violence, abuse, and decision-making
# Author:	Tim Essam, Ph.D.
# Created:	2014/12/30
# Modified: 2014/12/30
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	https://ideas.repec.org/c/boc/bocode/s457279.html (zscore06) 
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/

clear
capture log close
log using "$pathlog/WomensStatus", replace


* Load first module
use "$pathin/060_mod_z1_female.dta"

* Female works? money earned?
recode z1_01 (2 = 0 "No") (1 = 1 "Yes"), gen(femWork) label(nolab)
clonevar femWorkMoney = z1_10

* Decision on where to spend money
clonevar femMoneyDecis = z1_11

save "$pathout/femwork.dta", replace
clear

use "$pathin/063_mod_z4_female.dta"

* Divorce threats
g byte divorceThreat = inlist(z4_01a, 1, 2, 3) == 1
replace divorceThreat = . if z4_01a==9 //ac(2)
g byte anotherWife = inlist(z4_01b, 1, 2, 3) == 1
replace anotherWife = . if z4_01b==9 //ac(2)
g byte verbalAbuse = inlist(z4_01c, 1, 2, 3) == 1
replace verbalAbuse = . if z4_01c==9 //ac(2)
g byte physicalAbuse = inlist(z4_01d, 1, 2, 3) == 1
replace physicalAbuse = . if z4_01d==9 //ac(2)

la var divorceThreat "Husband made divorce threats" 
la var anotherWife "Husband threatened to take another wife" 
la var verbalAbuse "Someone in household verbally abused female" 
la var physicalAbuse "Someone in household physically abused female"

merge 1:1 a01 using "$pathout/femwork.dta", gen(femwork_merge)
tab femwork_merge
drop femwork_merge
erase "$pathout/femwork.dta"
drop z* flag 

save "$pathout/womensStatus.dta", replace

