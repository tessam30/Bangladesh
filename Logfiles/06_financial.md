
<html>
<body>
<pre>
------------------------------------------------
      name:  <span class=result>&lt;unnamed&gt;</span>
<span class=result>       </span>log:  <span class=result>U:\Bangladesh\Log/06_financial.smcl</span>
<span class=result>  </span>log type:  <span class=result>smcl</span>
<span class=result> </span>opened on:  <span class=result>20 Nov 2014, 10:11:47</span>
<br><br>
<span class=input>. set more off</span>
<br><br>
<span class=input>. </span>
<span class=input>. * load savings data</span>
<span class=input>. use "$pathin/008_mod_e_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Generate dummy for existence of savings acco</span>
<span class=input>&gt; unt</span>
<span class=input>. g byte savings = e02 == 1</span>
<br><br>
<span class=input>. la var savings "HH has savings account"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte savingsYr = e01 == 1</span>
<br><br>
<span class=input>. la var savingsYr "HH had savings account in la</span>
<span class=input>&gt; st year"</span>
<br><br>
<span class=input>. </span>
<span class=input>. egen savingsTot = total(e06), by(a01)</span>
<br><br>
<span class=input>. la var savingsTot "Total amount currently save</span>
<span class=input>&gt; d"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte ngoSave = inlist(e04, 2)</span>
<br><br>
<span class=input>. la var ngoSave "HH saves with NGO"</span>
<br><br>
<span class=input>. g byte bankSave = inlist(e04, 4)</span>
<br><br>
<span class=input>. la var bankSave "HH saves with bank"</span>
<br><br>
<span class=input>. g byte insurSave = inlist(e04, 8)</span>
<br><br>
<span class=input>. la var insurSave "HH saves with insurance comp</span>
<span class=input>&gt; any"</span>
<br><br>
<span class=input>. g byte othSave = inlist(e04, 1, 3, 5, 6, 7, 9,</span>
<span class=input>&gt;  10, 11)</span>
<br><br>
<span class=input>. la var othSave "HH saves at other places"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Collapse down to hh</span>
<span class=input>. include "$pathdo/copylabels.do"</span>
<br><br>
<span class=input>. /*--------------------------------------------</span>
<span class=input>&gt; -----------------------------------</span>
<span class=input>&gt; # Name:         copylabels</span>
<span class=input>&gt; # Purpose:      Copies labels from a dataset; </span>
<span class=input>&gt; for use before collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStrea</span>
<span class=input>&gt; m Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #---------------------------------------------</span>
<span class=input>&gt; ----------------------------------</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. foreach v of var * {</span>
  2<span class=input>.         local l`v' : variable label `v'</span>
  3<span class=input>.             if `"`l`v''"' == "" {</span>
  4<span class=input>.             local l`v' "`v'"</span>
  5<span class=input>.         }</span>
  6<span class=input>. }</span>
<br><br>
<span class=input>. </span>
<span class=input>. collapse savings savingsYr savingsTot (max) ng</span>
<span class=input>&gt; oSave bankSave insurSave othSave, by(a01)</span>
<br><br>
<span class=input>. include "$pathdo/attachlabels.do"</span>
<br><br>
<span class=input>. /*--------------------------------------------</span>
<span class=input>&gt; -----------------------------------</span>
<span class=input>&gt; # Name:         attachlables</span>
<span class=input>&gt; # Purpose:      Attaches labels to a dataset; </span>
<span class=input>&gt; for use after collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStrea</span>
<span class=input>&gt; m Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #---------------------------------------------</span>
<span class=input>&gt; ----------------------------------</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. foreach v of var * {</span>
  2<span class=input>.         label var `v' "`l`v''"</span>
  3<span class=input>. }</span>
<br><br>
<span class=input>. </span>
<span class=input>. </span>
<span class=input>. * Save as savings</span>
<span class=input>. save "$pathout/savings.dta", replace</span>
(note: file U:\Bangladesh\Dataout/savings.dta no
&gt; t found)
file U:\Bangladesh\Dataout/savings.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. * Load loan information</span>
<span class=input>. use "$pathin/009_mod_f_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Make variables that track what type of loan </span>
<span class=input>&gt; it is, how much, and where from, interest and </span>
<span class=input>&gt; total debt.</span>
<span class=input>. g byte loans = f02 == 1</span>
<br><br>
<span class=input>. la var loans "Household currenlty has a loan"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Loan use</span>
<span class=input>. g busLoan = inlist(f06_a, 1)</span>
<br><br>
<span class=input>. g agLoan = inlist(f06_a, 2, 3, 4, 5, 6, 7, 8, </span>
<span class=input>&gt; 9, 10, 11, 12, 13, 14, 15)</span>
<br><br>
<span class=input>. g medLoan = inlist(f06_a, 16)</span>
<br><br>
<span class=input>. g consLoan = inlist(f06_a, 17)</span>
<br><br>
<span class=input>. g housingLoan = inlist(f06_a, 18)</span>
<br><br>
<span class=input>. g edLoan = inlist(f06_a, 19)</span>
<br><br>
<span class=input>. g marriageLoan = inlist(f06_a, 20, 21)</span>
<br><br>
<span class=input>. g othLoan = inlist(f06_a, 22, 23, 24, 25, 26)</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Create total hh value of each type of loan</span>
<span class=input>. local loans busLoan agLoan medLoan consLoan ho</span>
<span class=input>&gt; usingLoan edLoan marriageLoan othLoan</span>
<br><br>
<span class=input>. foreach x of local loans {</span>
  2<span class=input>.         bys a01: egen `x'Amt = total(f07) i</span>
<span class=input>&gt; f `x' == 1</span>
  3<span class=input>.         la var `x'Amt "Value of `x'"</span>
  4<span class=input>.         la var `x' "Type of loan:`x'"</span>
  5<span class=input>. }</span>
(8268 missing values generated)
(7718 missing values generated)
(8834 missing values generated)
(7904 missing values generated)
(8858 missing values generated)
(9294 missing values generated)
(9124 missing values generated)
(8159 missing values generated)
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. * Calculate total value of outstanding loans</span>
<span class=input>. bys a01: egen loanTotal = total(f07)</span>
<br><br>
<span class=input>. la var loanTotal "Total value of oustanding lo</span>
<span class=input>&gt; ans"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Keep new vars</span>
<span class=input>. ds(f0* mid f10 flag ), not</span>
a01           housingLoan   consLoanAmt
sample_type   edLoan        housingLoa~t
loans         marriageLoan  edLoanAmt
busLoan       othLoan       marriageLo~t
agLoan        busLoanAmt    othLoanAmt
medLoan       agLoanAmt     loanTotal
consLoan      medLoanAmt
<br><br>
<span class=input>. keep `r(varlist)'</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Collapse down to hh</span>
<span class=input>. include "$pathdo/copylabels.do"</span>
<br><br>
<span class=input>. /*--------------------------------------------</span>
<span class=input>&gt; -----------------------------------</span>
<span class=input>&gt; # Name:         copylabels</span>
<span class=input>&gt; # Purpose:      Copies labels from a dataset; </span>
<span class=input>&gt; for use before collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStrea</span>
<span class=input>&gt; m Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #---------------------------------------------</span>
<span class=input>&gt; ----------------------------------</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. foreach v of var * {</span>
  2<span class=input>.         local l`v' : variable label `v'</span>
  3<span class=input>.             if `"`l`v''"' == "" {</span>
  4<span class=input>.             local l`v' "`v'"</span>
  5<span class=input>.         }</span>
  6<span class=input>. }</span>
<br><br>
<span class=input>. </span>
<span class=input>. ds(a01 sample_type), not</span>
loans         edLoan        consLoanAmt
busLoan       marriageLoan  housingLoa~t
agLoan        othLoan       edLoanAmt
medLoan       busLoanAmt    marriageLo~t
consLoan      agLoanAmt     othLoanAmt
housingLoan   medLoanAmt    loanTotal
<br><br>
<span class=input>. collapse (max) `r(varlist)', by(a01)</span>
<br><br>
<span class=input>. include "$pathdo/attachlabels.do"</span>
<br><br>
<span class=input>. /*--------------------------------------------</span>
<span class=input>&gt; -----------------------------------</span>
<span class=input>&gt; # Name:         attachlables</span>
<span class=input>&gt; # Purpose:      Attaches labels to a dataset; </span>
<span class=input>&gt; for use after collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStrea</span>
<span class=input>&gt; m Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #---------------------------------------------</span>
<span class=input>&gt; ----------------------------------</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. foreach v of var * {</span>
  2<span class=input>.         label var `v' "`l`v''"</span>
  3<span class=input>. }</span>
<br><br>
<span class=input>. </span>
<span class=input>. </span>
<span class=input>. merge 1:1 a01  using "$pathout/savings.dta", g</span>
<span class=input>&gt; en(fin_merge)</span>
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>               0</span>
    matched                  <span class=result>           6,503</span>  (
&gt; fin_merge==3)
    -----------------------------------------
<br><br>
<span class=input>. compress</span>
<span class=result>  </span>busLoan was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>agLoan was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>medLoan was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>consLoan was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>housingLoan was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>edLoan was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>marriageLoan was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>othLoan was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>savings was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>savingsYr was <span class=result>float</span> now <span class=result>byte</span>
  (195,090 bytes saved)
<br><br>
<span class=input>. </span>
<span class=input>. save "$pathout/finances.dta", replace</span>
file U:\Bangladesh\Dataout/finances.dta saved
<br><br>
<span class=input>. erase "$pathout/savings.dta"</span>
<br><br>
<span class=input>. </span>
</pre>
</body>
</html>
