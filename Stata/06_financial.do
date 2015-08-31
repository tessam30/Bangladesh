/*-------------------------------------------------------------------------------
# Name:		06_financial
# Purpose:	Process household data and create financial variables
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
log using "$pathlog/06_financial", replace
set more off

* load savings data
use "$pathin/008_mod_e_male.dta", clear

* Generate dummy for existence of savings account
g byte savings = e02 == 1
g byte savingsMemb2 = (e02 == 1 & mid == 2)
la var savings "HH has savings account"
la var savingsMemb2 "HH member 2 has savings account"

g byte savingsYr = e01 == 1
la var savingsYr "HH had savings account in last year"

egen savingsTot = total(e06), by(a01)
la var savingsTot "Total amount currently saved"

g byte ngoSave = inlist(e04, 2)
la var ngoSave "HH saves with NGO"
g byte bankSave = inlist(e04, 4)
la var bankSave "HH saves with bank"
g byte insurSave = inlist(e04, 8)
la var insurSave "HH saves with insurance company"
g byte othSave = inlist(e04, 1, 3, 5, 6, 7, 9, 10, 11)
la var othSave "HH saves at other places"

* Collapse down to hh
include "$pathdo2/copylabels.do"
collapse savings savingsMemb2 savingsYr savingsTot (max) ngoSave bankSave insurSave othSave, by(a01)
include "$pathdo2/attachlabels.do"

* Save as savings
save "$pathout/savings.dta", replace

* Load loan information
use "$pathin/009_mod_f_male.dta", clear

* Make variables that track what type of loan it is, how much, and where from, interest and total debt.
g byte loans = f02 == 1
la var loans "Household currenlty has a loan"
g byte loansMemb2 = (f02 == 1& mid == 2)
la var loansMemb2 "Household member 2 currently has a loan"

* Loan use
g busLoan = inlist(f06_a, 1)
g agLoan = inlist(f06_a, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
g medLoan = inlist(f06_a, 16)
g consLoan = inlist(f06_a, 17)
g housingLoan = inlist(f06_a, 18)
g edLoan = inlist(f06_a, 19)
g marriageLoan = inlist(f06_a, 20, 21)
g othLoan = inlist(f06_a, 22, 23, 24, 25, 26)

* Create total hh value of each type of loan
local loans busLoan agLoan medLoan consLoan housingLoan edLoan marriageLoan othLoan
foreach x of local loans {
	bys a01: egen `x'Amt = total(f07) if `x' == 1
	la var `x'Amt "Value of `x'"
	la var `x' "Type of loan:`x'"
}
*end

* Calculate total value of outstanding loans
bys a01: egen loanTotal = total(f07)
la var loanTotal "Total value of oustanding loans"

* Keep new vars
ds(f0* mid f10 flag ), not
keep `r(varlist)'

* Collapse down to hh
include "$pathdo2/copylabels.do"
ds(a01 sample_type), not
collapse (max) `r(varlist)', by(a01)
include "$pathdo2/attachlabels.do"

merge 1:1 a01  using "$pathout/savings.dta", gen(fin_merge)
compress

save "$pathout/finances.dta", replace
erase "$pathout/savings.dta"

log2html "$pathlog/06_financial", replace
log close
