/*-------------------------------------------------------------------------------
# Name:		12_GPSconvert
# Purpose:	Destring GPS coordinates and calculate decimal degrees
# Author:	Tim Essam, Ph.D.
# Created:	2015/01/30
# Modified: 2015/01/30
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	http://andrew.hedges.name/experiments/convert_lat_long/
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/
clear
capture log close
log using "$pathlog/GPSconvert", replace

use "$pathin/male_mod_a_with_gps.dta."

* Convert GPS data into useable format
split a08_n, parse(.)
split a08_e, parse(.)

foreach x of varlist a08_* {
	destring `x', replace
	}
*end

* Apply appropriate converstions to minutes and seconds
foreach x of varlist a08_n2 a08_e2 {
	replace `x' = `x'/60
	}
*end

foreach x of varlist a08_n3 a08_e3 {
	replace `x' = `x'/3600
	}
*end

g latitude = a08_n1 + a08_n2 + a08_n3
g longitude = a08_e1 + a08_e2 + a08_e3

la var latitude "Household longitude"
la var longitude "Household latititude"

export delimited using "U:\Bangladesh\Export\Lat.lon.mapped.csv", replace

* Plotted lat lon in AGOL and found a few of the points fall outside of the country. Not sure if this is do to the offsets or if they are incorrect.

