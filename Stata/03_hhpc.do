/*-------------------------------------------------------------------------------
# Name:		03_hhpc
# Purpose:	Process household data and create physical capital indices
# Author:	Tim Essam, Ph.D.
# Created:	2014/11/05
# Modified: 2014/11/05
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	labutil, labutil2 (ssc install labutil, labutil2)
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/
clear
capture log close
log using "$pathlog/03_hhpc",  replace
set more off

/* Load module with information on household assets. */
use "$pathin/006_mod_d1_male.dta", clear

* Create variables reflecting ownership of different durable assets
/* Automate the process a bit to make processing easier*/

* create vector of assets for which binary variables are created
#delimit ;
local assets trunk bucket stove cookpots bed cabinet 
	tableChairs hukka fan iron radio cd clock tvbw tvclr
	gold sew bike rickshaw van boat elecboat moto 
	mobile landphone thresher mill randa saw hammer patkoa
	fishnet spade axe shovel shabol daa horse mule
	donkey;
#delimit cr

* Loop over each asset in order, verifying code using output (p. 7, Module D)
local count = 1
foreach x of local assets {
	qui g byte `x' = (d1_02 == `count' & d1_03 == 1)
	
	* Check that asset matches order
	display in yellow "`x': `count' asset code"
	local count = `count'+1
	}
*end
foreach name of varlist trunk-donkey {
	la var `name' "No. `name's owned by hh"
	bys a01: egen n`name' = (`name'*d1_04)
	replace n`name'=0 if n`name'==. 
	la var n`name' "Total `name's owned by hh"
}
*end

bys a01: g nsolar = d1_04 if d1_02 == 43 & d1_03 == 1
+replace nsolar = 0 if nsolar==.  //ac (2)
la var nsolar "hh has solar energy panel"

bys a01: g ngenerator = d1_04 if d1_02 == 44 & d1_03 == 1
replace ngenerator = 0 if ngenerator==. 
la var ngenerator "hh has electricity generator"

bys a01: g cashOnHand = d1_04 if d1_02 == 42 
replace cashOnHand = 0 if cashOnHand == .
la var cashOnHand "Cash on hand at time of survey"

bys a01: g jewelryVal = d1_10 if d1_02 == 16
replace jewelryVal = 0 if jewelryVal == .
la var jewelryVal "Value of jewelry"

* Exchange rate was about 0.014 dollars to Taka in 2011
* or about 71 Taka to dollars 
* Calculate value of durables owned and check distribution
sort a01 d1_02
egen hhDurablesValue = sum(d1_10), by(a01 d1_02)
egen hhDurablesTotVal = sum(hhDurablesValue), by(a01)
la var hhDurablesTotVal "Total value of durables using hh reported figures"
*tabstat hhDurablesValue, by(d1_02) stat(mean sd min max)

* Another method for hhdurval
egen munitprice = median(d1_10/d1_04), by(d1_02)  //ac (3)
la var munitprice "Median price of durable asset"

* Calculate total value of all durables (including gold and jewelry)
egen hhdurasset = total(d1_04 * munitprice), by(a01)
la var hhdurasset "Total value of all durable assets using item median"
replace hhdurasset = . if hhdurasset ==0

*Collapse process
ds (d1* munitprice), not
keep `r(varlist)'

*Order the variable list for ease
order a01 hhDurablesValue

* Collapse down to HH level
include "$pathdo/copylabels.do"
ds (a01 hhDurablesValue), not
collapse (sum) hhDurablesValue (max) `r(varlist)', by(a01)
include "$pathdo/attachlabels.do"

* Run summary statistics on assets
tabstat ntrunk-ngenerator, stat(mean sd min max)

* Winsorize the asset values (revisit this in QA/QC file
* winsor2 hhDurablesValue hhdurasset, replace cuts(1 99)

* Create durable wealth index based on durable assets
#delimit ;
	qui factor trunk bucket stove cookpots bed cabinet tableChairs hukka 
	fan iron radio cd clock tvbw tvclr sew bike rickshaw van 
	boat elecboat moto mobile landphone, pcf;
#delimit cr
qui rotate
qui predict durwealth

/* Check Cronbach's alpha for Scale reliability coefficent higher than 0.50;
	Scale derived is reasonable b/c the estimated correlation between it and 
	underlying factor it is measuring is sqrt(0.69) = .8333 */
#delimit ;
	alpha trunk bucket stove cookpots bed cabinet tableChairs hukka 
	fan iron radio cd clock tvbw tvclr sew bike rickshaw van 
	boat elecboat moto mobile landphone;
#delimit cr

* Plot loadings for review
loadingplot, mlabs(small) mlabc(maroon) mc(maroon) /*
	*/ xline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*
	*/ yline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*
	*/ title(Household durable wealth index loadings)
graph export "$pathgraph/durwealthLoadings.png", as(png) replace
scree, title(Scree plot of durable wealth index)
graph export "$pathgragh/durwealthScree.png", as(png) replace

* Generate variable reflecting fungible wealth
g fungWealth = jewelryVal + cashOnHand
la var fungWealth "fungible wealth holdings"

save "$pathout/hhdurables.dta", replace

*************
* Ag Assets *
*************

*load module
use "$pathin/007_mod_d2_male.dta", clear

* create vector of assets for which binary variables are created
#delimit ;
local agassets kaste nirani ladder rake ploughYoke reaper sprayer wheelbarrow
		bullockCart pushCart;
#delimit cr
local count = 1

foreach x of local agassets {
	bys a01: g `x' = d2_04 if (d2_02 == `count' & d2_03 == 1)
	replace `x' = 0 if `x' ==.
	la var `x' "HH owns `x'"
	
	* Check that asset matches order
	display in yellow "`x': `count' asset code"
	local count = `count'+1
	}
*end

* create vector of assets for which binary variables are created
#delimit ;
local machines tractor tiller trolley thresher fodderMachine swingBasket
		Don handWell treadlePump rowerPump llp stubeWell dtubeWell
		elecPump dieselPump elecSprayer harvester;
#delimit cr


* Start count on Machinery assets (p. 10, Module D2)
local count = 12
foreach x of local machines {
	bys a01: g `x' = d2_04 if (d2_02 == `count' & d2_03 == 1)
	replace `x' = 0 if `x' ==.
	la var `x' "HH owns `x'"
	
	* Check that asset matches order
	display in yellow "`x': `count' asset code"
	local count = `count'+1
	}
*end

* Calculate the median value of each asset group
* For example: for tractors, take the median value of all tractors listed
* Then multiply that number by the number of tractors owned by a hh 
egen munitprice = median(d2_10/d2_04), by(d2_02)
la var munitprice "Median price of ag assets"

egen hhagasset = total(d2_04 * munitprice), by(a01)
la var hhagasset "Total value of all ag assets"
* Question here: do we assumed if a hh does not own an asset it's value is missing
* or zero? To be revisited before analysis (can do w/ and w/out).
replace hhagasset = . if hhagasset ==0

* What is median price of assets?
tab d2_02, sum(munitprice) mi

*Collapse
ds(d2*), not
keep `r(varlist)'

* copy variable labels to reapply
include "$pathdo/copylabels.do"

* Collapse data down to HH level
ds(a01 munitprice), not
#delimit ;
	qui collapse (max) `r(varlist)',
	by(a01) fast;
#delimit cr

* Reapply variable lables and save a copy
include "$pathdo/attachlabels.do"

*Run factor analysis to create ag wealth index
qui ds(a01 sample_type hhagasset), not
qui factor kaste-harvester, pcf
rotate
predict agAssetWealth
alpha kaste-harvester

* Plot loadings for review
qui loadingplot, mlabs(small) mlabc(maroon) mc(maroon) /*
	*/ xline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*
	*/ yline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*
	*/ title(Household wealth ag index loadings)
qui graph export "$pathgraph/agwealthLoadings.png", as(png) replace
qui scree, title(Scree plot of ag wealth index)
qui graph export "$pathgragh/agwealthScree.png", as(png) replace

* Merge durables with agricultural implement assets
merge 1:1 a01  using "$pathout/hhdurables.dta", gen(assets)

compress
save "$pathout/hhpc.dta", replace
erase "$pathout/hhdurables.dta"
log2html "$pathlog/03_hhpc", replace
log close

