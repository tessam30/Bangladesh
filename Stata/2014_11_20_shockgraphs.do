clear
capture log close
log using $pathlog/SummaryStats, replace

use $pathout/shocks.dta
merge 1:1 a01 using $pathin/001_mod_a_male.dta

local mlist hhchar hhinfra hhpc hhTLU_pc finances 

local i = 1
foreach x of local mlist {
	merge 1:1 a01 using "$pathout/`x'.dta", gen(merge_`i')
	local i = `i' + 1
	}
*

*Export a cut to R for bar graphs
local shocks "healthshk agshk finshk assetshk priceshk floodshk  othershk"
collapse (mean) `shocks' (sum) thlth=healthshk tagshk = agshk tfin = finshk tass = assetshk tpr = priceshk tfld = floodshk toth = othershk, by(div_name)
g id=_n

export delimited using "$pathexport\shocks.csv", replace

*estpost tabstat `shocks', by(div_name) stat(mean sd) col(statistics) listwise

local hshocks "healthshk healthshkR healthshk2007 healthshk2008 healthshk2009 healthshk2010 healthshk2011"
tabstat `hshocks', by(div_name) stat(mean sd)

