/*-------------------------------------------------------------------------------
# Name:		08_remittances
# Purpose:	Process household data and create safetey nets and migration/remittances
# Author:	Tim Essam, Ph.D.
# Created:	2014/11/25
# Modified: 2014/11/25
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	tabsort, 
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/

clear
capture log close
log using "$pathlog/08_remittances", replace

* Load social safety net data first
use "$pathin/040_mod_u_male.dta"

* Look at which saftey net programs are widely received
tab slno if u01 == 1, mi
g byte safetyNet = u01 == 1

* Calculate total monetary value for each program
egen snettmp = rsum2(u02 u04 u06 u08 u07) if u01 == 1

* Calculate total saftey net value by household
egen snetValue = total(snettmp), by(a01)

* Create groups of social safety nets
g byte snetEduc = inlist(slno, 1, 2, 3, 4, 5, 6, 7) if u01 == 1
g byte snetAge  = inlist(slno, 8) if u01 == 1
g byte snetAllow = inlist(slno, 9, 10, 11, 12, 13, 14, 15, 16) if u01 == 1
g byte snetAid = inlist(slno, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, /*
*/ 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43) if u01 == 1

la var snetEduc "Education safety net"
la var snetAge "Age related safety net"
la var snetAllow "Allowance based safety net"
la var snetAid "Aid related safety net (includes food)"

foreach x of varlist snetEduc snetAge snetAllow snetAid {
	egen `x'Value = total(`x') if `x' == 1, by(a01)
	copydesc `x' `x'Value
	}
*end



