/*-------------------------------------------------------------------------------
# Name:		01_hhchar
# Purpose:	Process household data and create hh characteristic variables
# Author:	Tim Essam, Ph.D.
# Created:	2014/11/05
# Modified: 2014/12/17
# Owner:	USAID GeoCenter | OakStream Systems, LLC
# License:	MIT License
# Ado(s):	labutil, labutil2 (ssc install labutil, labutil2)
# Dependencies: copylables, attachlabels, 00_SetupFoldersGlobals.do
#-------------------------------------------------------------------------------
*/
capture log close
log using "$pathlog/01_hhchar", replace

* Load household survey module of all individuals. Collapse down for hh totals.
use "$pathin\003_mod_b1_male.dta", clear

/* Demographic list to calculate
1. household size
2. dependency ratio
3. hoh education
4. male hoh education
5. wife education
6. Gender ratio
7. Principal occupation of hoh
*/

* Create head of household variable based on primary respondent and sex
g byte hoh = b1_03 == 1
la var hoh "Head of household"

g byte femhead = b1_01 == 2 & b1_03 == 1
la var femhead "Female head of household"

g agehead = b1_02 if hoh == 1
la var agehead "Age of head of household"
g ageheadsq = agehead^2
la var ageheadsq "Squared age of the head (for non-linear effects)"
g ageSpouse = b1_02 if b1_03 == 2
la var ageSpouse "Age of the spouse of household"

* Relationship status
g byte marriedHead = b1_04 == 2 & hoh==1
la var marriedHead "married HoH"

g byte widowHead = (b1_04 == 3 & hoh==1)
la var widowHead "widowed HoH"

g byte widowFemhead = (b1_04 == 3 & femhead)
la var widowFemhead "Widowed Female head of household"

g byte singleHead = (marriedHead==0 & hoh==1)
la var singleHead "single HoH"

* Create a migration network variable
g byte migration = b1_05 == 1
la var migration "Household has access to migration networks"
g byte migrationHoh = b1_05 == 1 & hoh == 1
la var migrationHoh "Hoh has migrated in last 6 months"

* Create household size variables
bysort a01: gen hhsize = _N 
la var hhsize "Household size"

* Create sex ratio for households
g byte male = b1_01 == 1
g byte female = b1_01 == 2
la var male "male hh members"
la var female "female hh members"

egen msize = total(male), by(a01)
la var msize "number of males in hh"

egen fsize = total(female), by(a01)
la var fsize "number of females in hh"

g sexRatio = msize/fsize
recode sexRatio (. = 0) if fsize==0
la var sexRatio "Number of males divided by females in HH"

/* Create intl. HH dependency ratio (age ranges appropriate for Bangladesh)
# HH Dependecy Ratio = [(# people 0-14 + those 65+) / # people aged 15-64 ] * 100 # 
The dependency ratio is defined as the ratio of the number of members in the age groups 
of 0–14 years and above 60 years to the number of members of working age (15–60 years). 
The ratio is normally expressed as a percentage (data below are multiplied by 100 for pcts.*/
g byte numDepRatio = (b1_02<15 | b1_02>64) 
g byte demonDepRatio = numDepRatio!=1 
egen totNumDepRatio = total(numDepRatio), by(a01)
egen totDenomDepRatio = total(demonDepRatio), by(a01)
g byte hhShareOver64t = (b1_02 > 64)
egen over64 = total(hhShareOver64t), by(a01)
g over64share = over64 / hhsize
drop hhShareOver64t

* Check that numbers add to hhsize
assert hhsize == totNumDepRatio+totDenomDepRatio
g depRatio = (totNumDepRatio/totDenomDepRatio)*100 if totDenomDepRatio!=.
recode depRatio (. = 0) if totDenomDepRatio==0
la var depRatio "Dependency Ratio"

* Drop extra information
drop numDepRatio demonDepRatio totNumDepRatio totDenomDepRatio

/* Household Labor Shares */
g byte hhLabort = (b1_02>= 12 & b1_02<60)
egen hhlabor = total(hhLabort), by(a01)
la var hhlabor "hh labor age>11 & < 60"

g byte mlabort = (b1_02>= 12 & b1_02<60 & b1_01 == 1)
egen mlabor = total(mlabort), by(a01)
la var mlabor "hh male labor age>11 & <60"

g byte flabort = (b1_02>= 12 & b1_02<60 & b1_01 == 2)
egen flabor = total(flabort), by(a01)
la var flabor "hh female labor age>11 & <60"
drop hhLabort mlabort flabort

* Male/Female labor share in hh
g mlaborShare = mlabor/hhlabor
recode mlaborShare (. = 0) if hhlabor == 0
la var mlaborShare "share of working age males in hh"

g flaborShare = flabor/hhlabor
recode flaborShare (. = 0) if hhlabor == 0
la var flaborShare "share of working age females in hh"


* Code below is inefficient; Should use cut command as w/ ETH do files
* % of hh females aged 20-34 & 35 - 59
g byte fem20_34tmp = (b1_02>=20 &  b1_02<35) & (female == 1)
g byte fem35_59tmp = (b1_02>=35 & b1_02<60) & (female == 1)
egen femCount20_34 = total(fem20_34tmp), by(a01)
egen femCount35_59 = total(fem35_59tmp), by(a01)
g femRatio20_34 = femCount20_34/hhsize
g femRatio35_59 = femCount35_59/hhsize

la var femRatio20_34 "Share of females in hh 20-34"
la var femRatio35_59 "Share of females in hh 35-59"
la var femCount20_34 "Number of females in hh 20-34"
la var femCount35_59 "Number of females in hh 35-59"

* Collapse will take care of aggregation at hh level
g byte under5t = b1_02 <=5
egen under5 = total(under5t), by(a01)
egen under5male = total(under5t) if male == 1, by(a01)
egen under5female = total(under5t) if female == 1, by(a01)
drop under5t

* Number of hh members under 15
g byte under15t = b1_02<15
egen under15 = total(under15t), by(a01)
la var under15 "number of hh members under 15"
egen under15male = total(under15t) if male==1, by(a01)
egen under15female = total(under15t) if female == 1, by(a01)
egen under15male_r = max(under15male), by(a01) //ac
egen under15female_r = max(under15female), by(a01)
replace under15male = under15male_r //ac
replace under15female = under15female_r
drop under15male_r  under15female_r //ac
la var under15male "number of hh male members under 15"
la var under15female "number of hh female members under 15"
recode under15male (. = 0) if under15male== .
recode under15female (. = 0) if under15female == .

* Number of hh members under 24
g byte under24t = b1_02<24
egen under24 = total(under24t), by(a01)
egen under24male = total(under24t) if male==1, by(a01)
egen under24male_r = max(under24male), by(a01) //ac
replace under24male = under24male_r //ac
drop under24male_r //ac
recode under24male (. = 0) if under24male==.
la var under24 "number of hh members under 24"
la var under24male "number of hh male members under 24"

* HH share of members under 15/24
g under15Share = under15/hhsize
la var under15Share "share of hh members under 15"
g under24Share = under24/hhsize
la var under24Share "share of hh members under 24"

* Generate adult equivalents in household
g male10 	= 1
g fem10_19 	= 0.84
g fem20		= 0.72
g child10	= 0.60

g ae = .
replace ae = male10 if (b1_02 >=10 ) & male == 1
replace ae = fem10_19 if (b1_02 >= 10 & b1_02 < 20) & male ~=1
replace ae = fem20 if (b1_02 >= 20) & male ~=1
replace ae = child10 if (b1_02) < 10 
la var ae "Adult equivalents"

egen adultEquiv = total(ae), by(a01)
la var adultEquiv "Total adult equivalent units"

* drop temp variables
drop under15t under24t

**********************
* Education outcomes *
**********************

* head of household literate
g byte literateHead   = (b1_07 == 4 & hoh == 1)
g byte readOnlyHead   = b1_07 == 3 & hoh == 1
g byte signOnlyHead   = b1_07 == 2 & hoh == 1
g byte illitHead 	  = b1_07 == 1 & hoh

la var literateHead "HoH is literate"
la var readOnlyHead "Hoh can read only"
la var signOnlyHead "Hoh can sign only"
la var illitHead 	"Hoh cannot read and write"

* wife of hoh is literate
g byte spouseLit = (b1_04 == 2 & b1_03 == 2 & b1_07 ==4) 
g byte spouseIllit = (b1_04 == 2 & b1_03 == 2 & b1_07 == 1) 
la var spouseLit "Spouse is literate"

/* Education for individuals: 
http://en.wikipedia.org/wiki/Education_in_Bangladesh#mediaviewer/File:BangEduSys.png
No education (0 years)
PRe-primary (less than 1)
Primary Level (years 1 to 4)
Junior Level (years 5 to 8)
Secondary Level (years 9 to 10)
Higher Secondary Level (years 11 and 12)
Tertiary Level (all above Secondary)
Other
*/

* No education listed (codebook pag 2 Module B)
g educ = .
la var educ "Education levels"
* No education
replace educ = 0 if inlist(b1_08, 99)
* Pre-primary
replace educ = 1 if inlist(b1_08, 0, 66, 67)
* Primary
replace educ = 2 if inlist(b1_08, 1, 2, 3, 4, 5)
* Junior 
replace educ = 3 if inlist(b1_08, 6, 7, 8)
* Secondary 
replace educ = 4 if inlist(b1_08, 9, 10, 12, 33, 75, 11)
* Tertiary
replace educ = 5 if inlist(b1_08, 14, 15, 16, 22, 71, 72, 73, 74)
* Other
replace educ = 6 if inlist(b1_08, 76)

* Create variable reflect the max education in the household for those 25+
egen educAdult_25 = max(educ) if b1_02 > 24, by(a01)
egen educAdultF_25 = max(educ) if b1_02 > 24 & female == 1, by(a01)
egen educAdultM_25 = max(educ) if b1_02 > 24 & female == 0, by(a01)

egen educAdult_18 = max(educ) if b1_02 > 17, by(a01)
egen educAdultF_18 = max(educ) if b1_02 > 17 & female == 1, by(a01)
egen educAdultM_18 = max(educ) if b1_02 > 17 & female == 0, by(a01)
* Create similar variable but for males and for females
g educHead = educ if hoh == 1
g educSpouse = educ if b1_03 == 2

g educHoh = educ if hoh==1
la var educAdult_18 "Highest adult (18+) education in household"
la var educAdultM_18 "Highest adult (18+) education in household"
la var educAdultF_18 "Highest adult (18+) education in household"

la var educAdult_25 "Highest adult (25+) education in household"
la var educAdult_25 "Highest adult (25+) education in household"
la var educAdult_25 "Highest adult (25+) education in household"

la var educHoh "Education of Hoh"

* Look at child brides; Anyone who identifies as spouse and is under 18
* Few child brides; skipping topic

/* Main occupation of household head
1. Ag day laborer
2. Non-ag day laborer
3. Salaried
4. Self-employed
5. Rickshaw/van puller
6. Business/trade
7. Production business
8. Farming
9. Non-earning occupation
*/
g occupHoh = .
la var occupHoh "Main occupation of hoh"
* Ag day
replace occupHoh = 1 if inlist(b1_10, 1) & hoh == 1
* Non-ag
replace occupHoh = 2 if inlist(b1_10, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ) & hoh == 1
* Salaried
replace occupHoh = 3 if inlist(b1_10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21) & hoh == 1
* Self-employed
replace occupHoh = 4 if inlist(b1_10, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,  /*
*/ 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 72) & hoh == 1
* Rickshaw
replace occupHoh = 5 if inlist(b1_10, 22) & hoh == 1
* Trade
replace occupHoh = 6 if inlist(b1_10, 50, 51, 52, 53, 54) & hoh == 1
* Production
replace occupHoh = 7 if inlist(b1_10, 55, 56, 57) & hoh == 1
* Farming
replace occupHoh = 8 if inlist(b1_10, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71) & hoh == 1
* Non-earning
replace occupHoh = 9 if inlist(b1_10, 81, 82, 83, 84, 85, 86) & hoh == 1

g byte occupSpouseChx = b1_10 == 69 & b1_03 == 2
g byte occupSpouseLvstk = inlist(b1_10, 70, 71) & b1_03 == 2
g byte occupSpouseHwife = b1_10 == 82 & b1_03 == 2
la var occupSpouseChx "Spouse raises chicken"
la var occupSpouseLvstk "Spouse raises livestock or milk producer"
la var occupSpouseHwife "Spouse is housewife"

* Collapse everything down to HH-level using max values for all vars
* Copy variable labels to reapply after collapse

ds(b1* mid), not
keep `r(varlist)'

ds (a01), not
include "$pathdo2/copylabels.do"
collapse (max) `r(varlist)', by(a01)
include "$pathdo2/attachlabels.do"

* Create value labels for edu
la def ed 0 "No Education" 1 "Pre-primary" 2 "Primary" /*
	*/ 3 "Junior Secondary" 4 "Secondary" 5 "Tertiary" 6 "Other"
foreach x of varlist educ* {
	label values `x' ed
	}
*end

la def occ 1 "Ag-day laborer" 2 "Non-ag day laborer" /*
	*/ 3 "Salaried" 4 "Self-employed" 5 "Rickshaw/van puller" /*
	*/ 6 "Business or trade" 7 "Production business" 8 "Farming" /*
	*/ 9 "Non-earning occupation"
la values occupHoh occ
* 
la def sample 1 "ftf original" 2 "ftf additional" /*
	*/ 3 "national representative" 
la values sample_type sample

* Add notes to variables if needed
notes educAdult_25: missing values indicate that no member of household was over 25
compress
aorder

* Save
save "$pathout/hhchar.dta", replace
* Keep a master file of only household id's for missing var checks
keep a01
save "$pathout\hhid.dta", replace


* Create an html file of the log for internet sharability
log2html "$pathlog/01_hhchar", replace
log close
