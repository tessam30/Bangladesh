
<html>
<head>
</head>
<body>
<pre>
--------------------------------------------------------------------------------------------------------------------------------------------------
      name:  <span class=result>&lt;unnamed&gt;</span>
<span class=result>       </span>log:  <span class=result>U:\Bangladesh\Log/08_remittances.smcl</span>
<span class=result>  </span>log type:  <span class=result>smcl</span>
<span class=result> </span>opened on:  <span class=result> 8 Dec 2014, 12:40:43</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Load social safety net data first</span>
<span class=input>. use "$pathin/040_mod_u_male.dta"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Look at which saftey net programs are widely received</span>
<span class=input>. tab slno if u01 == 1, mi</span>
<br><br>
<span class=result>        </span>serial no of safety net program |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                          ananda school |<span class=result>         24        0.58        0.58</span>
           stipend for primary students |<span class=result>      1,518       36.90       37.48</span>
                 school feeding program |<span class=result>        156        3.79       41.27</span>
           stipend for dropout students |<span class=result>         11        0.27       41.54</span>
stipend for secondary and higher second |<span class=result>        350        8.51       50.05</span>
stipend for poor boys in secondary scho |<span class=result>         29        0.70       50.75</span>
          stipend for disabled students |<span class=result>          3        0.07       50.83</span>
                      old age allowance |<span class=result>        324        7.88       58.70</span>
allowances for distressed cultural pers |<span class=result>          1        0.02       58.73</span>
allowances for beneficiaries in ctg. hi |<span class=result>          5        0.12       58.85</span>
allowances for the widowed, deserted an |<span class=result>         96        2.33       61.18</span>
allowances for the financially insolven |<span class=result>         17        0.41       61.59</span>
allowances  for urban low-income lactat |<span class=result>          8        0.19       61.79</span>
honorarium for insolvent freedom fighte |<span class=result>         19        0.46       62.25</span>
honorarium for injured freedom fighters |<span class=result>          3        0.07       62.32</span>
               gratuitous relief (cash) |<span class=result>         16        0.39       62.71</span>
          gratuitious relief (gr)- food |<span class=result>        300        7.29       70.00</span>
            general relief activities   |<span class=result>        177        4.30       74.31</span>
                          cash for work |<span class=result>         13        0.32       74.62</span>
             agriculture rehabilitation |<span class=result>         20        0.49       75.11</span>
          subsidy for open market sales |<span class=result>        190        4.62       79.73</span>
     vulnerable group development (vgd) |<span class=result>        155        3.77       83.50</span>
      vgd-up (8 district on monga area) |<span class=result>         16        0.39       83.88</span>
         vulnerable group feeding (vgf) |<span class=result>        369        8.97       92.85</span>
                  test relief (tr) food |<span class=result>         67        1.63       94.48</span>
food assistance in ctg-hill tracts area |<span class=result>          2        0.05       94.53</span>
                    food for work (ffw) |<span class=result>          2        0.05       94.58</span>
special fund for employment generation  |<span class=result>          4        0.10       94.68</span>
fund for the welfare of acid burnt and  |<span class=result>          1        0.02       94.70</span>
             100 days employment scheme |<span class=result>         57        1.39       96.09</span>
rural employment opportunities for prot |<span class=result>          1        0.02       96.11</span>
rural employment and rural maintenance  |<span class=result>          3        0.07       96.18</span>
          community nutrition program   |<span class=result>          4        0.10       96.28</span>
                        char livelihood |<span class=result>          5        0.12       96.40</span>
                      shouhardo program |<span class=result>          5        0.12       96.52</span>
accommodation (poverty alleviation &amp; re |<span class=result>          1        0.02       96.55</span>
                        housing support |<span class=result>         15        0.36       96.91</span>
                             tup (brac) |<span class=result>         28        0.68       97.59</span>
                   one house one khamar |<span class=result>         16        0.39       97.98</span>
    mother &amp; child nutrition assistance |<span class=result>         21        0.51       98.49</span>
                    food for work (ngo) |<span class=result>          9        0.22       98.71</span>
                                 other  |<span class=result>         53        1.29      100.00</span>
----------------------------------------+-----------------------------------
                                  Total |<span class=result>      4,114      100.00</span>
<br><br>
<span class=input>. g byte safetyNet = u01 == 1</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Calculate total monetary value for each program</span>
<span class=input>. egen snettmp = rsum2(u02 u04 u06 u08 u07) if u01 == 1</span>
(275515 missing values generated)
<br><br>
<span class=input>. </span>
<span class=input>. * Calculate total saftey net value by household</span>
<span class=input>. egen snetValue = total(snettmp), by(a01)</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Create groups of social safety nets</span>
<span class=input>. g byte snetEduc = inlist(slno, 1, 2, 3, 4, 5, 6, 7) if u01 == 1</span>
(275515 missing values generated)
<br><br>
<span class=input>. g byte snetAge  = inlist(slno, 8) if u01 == 1</span>
(275515 missing values generated)
<br><br>
<span class=input>. g byte snetAllow = inlist(slno, 9, 10, 11, 12, 13, 14, 15, 16) if u01 == 1</span>
(275515 missing values generated)
<br><br>
<span class=input>. g byte snetAid = inlist(slno, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, /*</span>
<span class=input>&gt; */ 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43) if u01 == 1</span>
(275515 missing values generated)
<br><br>
<span class=input>. </span>
<span class=input>. la var snetEduc "Education safety net"</span>
<br><br>
<span class=input>. la var snetAge "Age related safety net"</span>
<br><br>
<span class=input>. la var snetAllow "Allowance based safety net"</span>
<br><br>
<span class=input>. la var snetAid "Aid related safety net (includes food)"</span>
<br><br>
<span class=input>. </span>
<span class=input>. foreach x of varlist snetEduc snetAge snetAllow snetAid {</span>
  2<span class=input>.         egen `x'Value = total(snettmp) if `x' == 1, by(a01)</span>
  3<span class=input>.         copydesc `x' `x'Value</span>
  4<span class=input>.         }</span>
(277538 missing values generated)
(279305 missing values generated)
(279480 missing values generated)
(278079 missing values generated)
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. * Collapse and copy labels</span>
<span class=input>. include "$pathdo/copylabels.do"</span>
<br><br>
<span class=input>. /*-------------------------------------------------------------------------------</span>
<span class=input>&gt; # Name:         copylabels</span>
<span class=input>&gt; # Purpose:      Copies labels from a dataset; for use before collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStream Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #-------------------------------------------------------------------------------</span>
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
<span class=input>. #delimit ;</span>
delimiter now ;
<span class=input>. collapse (max) snetValue snetEduc snetAge snetAllow snetAid snetEducValue </span>
<span class=input>&gt;                 snetAgeValue snetAllowValue snetAidValue, by(a01);</span>
<br><br>
<span class=input>. # delimit cr</span>
delimiter now cr
<span class=input>. include "$pathdo/attachlabels.do"</span>
<br><br>
<span class=input>. /*-------------------------------------------------------------------------------</span>
<span class=input>&gt; # Name:         attachlables</span>
<span class=input>&gt; # Purpose:      Attaches labels to a dataset; for use after collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStream Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #-------------------------------------------------------------------------------</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. foreach v of var * {</span>
  2<span class=input>.         label var `v' "`l`v''"</span>
  3<span class=input>. }</span>
<br><br>
<span class=input>. </span>
<span class=input>. </span>
<span class=input>. * Save safety nets and move to migration remmitances</span>
<span class=input>. save "$pathout/safetynets.dta", replace</span>
(note: file U:\Bangladesh\Dataout/safetynets.dta not found)
file U:\Bangladesh\Dataout/safetynets.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. * Load migration and remittances module</span>
<span class=input>. use "$pathin/041_mod_v1_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte migrationNW = v1_01 == 1</span>
<br><br>
<span class=input>. la var migrationNW "Household is part of migration network"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte migType = inlist(v1_02, 2) == 1</span>
<br><br>
<span class=input>. la var migType "Migrant relation to hoh is husband/wife"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte migAbroad = (migrationNW == 1 &amp; v1_09 == 2)</span>
<br><br>
<span class=input>. g byte migDomestic = (migrationNW == 1 &amp; v1_09 == 1)</span>
<br><br>
<span class=input>. la var migAbroad "Migration abroad"</span>
<br><br>
<span class=input>. la var migDomest "Migration within Bangladesh"</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Looking at migration variables; </span>
<span class=input>&gt;  * Most migration occured in last 5 years</span>
<span class=input>&gt;  * 83% of migrants are males</span>
<span class=input>&gt;  * (68% of all ) Dhaka and Chittagong are most common places</span>
<span class=input>&gt;  * (32% of all) Saudia Arabia &amp; UAE are most common abroad</span>
<span class=input>&gt;  * Private enterprise is most common occupation</span>
<span class=input>&gt;  * 73% migrate for employment purposes</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. * Collapse down</span>
<span class=input>. include "$pathdo/copylabels.do"</span>
<br><br>
<span class=input>. /*-------------------------------------------------------------------------------</span>
<span class=input>&gt; # Name:         copylabels</span>
<span class=input>&gt; # Purpose:      Copies labels from a dataset; for use before collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStream Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #-------------------------------------------------------------------------------</span>
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
<span class=input>. collapse (max) migrationNW migAbroad migDomestic migType, by(a01)</span>
<br><br>
<span class=input>. include "$pathdo/attachlabels.do"</span>
<br><br>
<span class=input>. /*-------------------------------------------------------------------------------</span>
<span class=input>&gt; # Name:         attachlables</span>
<span class=input>&gt; # Purpose:      Attaches labels to a dataset; for use after collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStream Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #-------------------------------------------------------------------------------</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. foreach v of var * {</span>
  2<span class=input>.         label var `v' "`l`v''"</span>
  3<span class=input>. }</span>
<br><br>
<span class=input>. </span>
<span class=input>. </span>
<span class=input>. * Save migration files</span>
<span class=input>. save "$pathout/migration.dta", replace</span>
(note: file U:\Bangladesh\Dataout/migration.dta not found)
file U:\Bangladesh\Dataout/migration.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. * Load in remittances-in data</span>
<span class=input>. use "$pathin/042_mod_v2_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte remitIn = v2_01 == 1</span>
<br><br>
<span class=input>. la var remitIn "HH received remittances in"</span>
<br><br>
<span class=input>. </span>
<span class=input>. egen totremitIn = total(v2_06), by(a01)</span>
<br><br>
<span class=input>. la var totremitIn "Total remittances received"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Nearly all money received for this is from Hoh spouse;</span>
<span class=input>. egen hohremitIn = total(v2_06) if v2_02 == 2, by(a01)</span>
(6291 missing values generated)
<br><br>
<span class=input>. la var hohremitIn "Total remittances received from hoh spouse"</span>
<br><br>
<span class=input>. </span>
<span class=input>. egen remitInChild = total(v2_06) if v2_02 == 3, by(a01)</span>
(5879 missing values generated)
<br><br>
<span class=input>. la var remitInChild "Total remittances received from children"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Collapse down</span>
<span class=input>. include "$pathdo/copylabels.do"</span>
<br><br>
<span class=input>. /*-------------------------------------------------------------------------------</span>
<span class=input>&gt; # Name:         copylabels</span>
<span class=input>&gt; # Purpose:      Copies labels from a dataset; for use before collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStream Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #-------------------------------------------------------------------------------</span>
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
<span class=input>. collapse (max) remitIn totremitIn hohremitIn, by(a01)</span>
<br><br>
<span class=input>. include "$pathdo/attachlabels.do"</span>
<br><br>
<span class=input>. /*-------------------------------------------------------------------------------</span>
<span class=input>&gt; # Name:         attachlables</span>
<span class=input>&gt; # Purpose:      Attaches labels to a dataset; for use after collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStream Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #-------------------------------------------------------------------------------</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. foreach v of var * {</span>
  2<span class=input>.         label var `v' "`l`v''"</span>
  3<span class=input>. }</span>
<br><br>
<span class=input>. </span>
<span class=input>. </span>
<span class=input>. save "$pathout/remitIn.dta", replace</span>
(note: file U:\Bangladesh\Dataout/remitIn.dta not found)
file U:\Bangladesh\Dataout/remitIn.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. * Calculate other income sources</span>
<span class=input>. clear</span>
<br><br>
<span class=input>. use "$pathin/044_mod_v4_male.dta"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Calculate total value of other income streams</span>
<span class=input>. clonevar landRent = v4_01</span>
(1998 missing values generated)
<br><br>
<span class=input>. egen otherInc = rsum2(v4_01 v4_02 v4_03 v4_04 v4_05 v4_06 v4_07 v4_08 v4_09 v4_10 v4_11 v4_12 v4_13)</span>
<br><br>
<span class=input>. la var otherInc "Total value of other income"</span>
<br><br>
<span class=input>. keep a01 landRent otherInc</span>
<br><br>
<span class=input>. save "$pathout/otherInc.dta", replace</span>
(note: file U:\Bangladesh\Dataout/otherInc.dta not found)
file U:\Bangladesh\Dataout/otherInc.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. * Load in remittances out data</span>
<span class=input>. use "$pathin/043_mod_v3_male.dta", replace</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte remitOut = v3_01 == 1</span>
<br><br>
<span class=input>. la var remitOut "HH sent remittances out"</span>
<br><br>
<span class=input>. </span>
<span class=input>. egen totremitOut = total(v3_06), by(a01)</span>
<br><br>
<span class=input>. la var totremitOut "Total remittances sent out"</span>
<br><br>
<span class=input>. </span>
<span class=input>. egen totremitChild = total(v3_06) if v3_02 == 3, by(a01)</span>
(6296 missing values generated)
<br><br>
<span class=input>. la var totremitChild "Total remittances sent to children"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * 77% of all remittances out are sent to children</span>
<span class=input>. </span>
<span class=input>. * Collapse down</span>
<span class=input>. include "$pathdo/copylabels.do"</span>
<br><br>
<span class=input>. /*-------------------------------------------------------------------------------</span>
<span class=input>&gt; # Name:         copylabels</span>
<span class=input>&gt; # Purpose:      Copies labels from a dataset; for use before collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStream Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #-------------------------------------------------------------------------------</span>
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
<span class=input>. collapse (max) remitOut totremitOut totremitChild, by(a01)</span>
<br><br>
<span class=input>. include "$pathdo/attachlabels.do"</span>
<br><br>
<span class=input>. /*-------------------------------------------------------------------------------</span>
<span class=input>&gt; # Name:         attachlables</span>
<span class=input>&gt; # Purpose:      Attaches labels to a dataset; for use after collapse command</span>
<span class=input>&gt; # Author:       Tim Essam, Ph.D.</span>
<span class=input>&gt; # Created:      2014/11/06</span>
<span class=input>&gt; # Copyright:    USAID GeoCenter</span>
<span class=input>&gt; # Licence:      &lt;Tim Essam Consulting/OakStream Systems, LLC&gt;</span>
<span class=input>&gt; # Ado(s):       none</span>
<span class=input>&gt; #-------------------------------------------------------------------------------</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. foreach v of var * {</span>
  2<span class=input>.         label var `v' "`l`v''"</span>
  3<span class=input>. }</span>
<br><br>
<span class=input>. </span>
<span class=input>. </span>
<span class=input>. * Stitch all remittances data together and delete extra files</span>
<span class=input>. merge 1:1 a01 using "$pathout/safetynets.dta", gen(snets_merge)</span>
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>               0</span>
    matched                  <span class=result>           6,503</span>  (snets_merge==3)
    -----------------------------------------
<br><br>
<span class=input>. merge 1:1 a01 using "$pathout/migration.dta", gen(mig_merge)</span>
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>               0</span>
    matched                  <span class=result>           6,503</span>  (mig_merge==3)
    -----------------------------------------
<br><br>
<span class=input>. merge 1:1 a01 using "$pathout/remitIn.dta", gen(remit_merge)</span>
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>               0</span>
    matched                  <span class=result>           6,503</span>  (remit_merge==3)
    -----------------------------------------
<br><br>
<span class=input>. merge 1:1 a01 using "$pathout/otherInc.dta", gen(othInc_merge)</span>
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>               0</span>
    matched                  <span class=result>           6,503</span>  (othInc_merge==3)
    -----------------------------------------
<br><br>
<span class=input>. </span>
<span class=input>. * No merging errors, dump variables</span>
<span class=input>. drop *_merge</span>
<br><br>
<span class=input>. </span>
<span class=input>. compress</span>
<span class=result>  </span>snetEducValue was <span class=result>float</span> now <span class=result>int</span>
  (13,006 bytes saved)
<br><br>
<span class=input>. save "$pathout/remittances.dta", replace</span>
file U:\Bangladesh\Dataout/remittances.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. local efiles safetynets migration remitIn otherInc</span>
<br><br>
<span class=input>. cd "$pathout"</span>
<span class=result>U:\Bangladesh\Dataout</span>
<br><br>
<span class=input>. foreach x of local efiles {</span>
  2<span class=input>.         capture findfile `x'.dta</span>
  3<span class=input>.         if _rc!=601 {</span>
  4<span class=input>.                 erase "$pathout/`x'.dta"</span>
  5<span class=input>.                 display in red "`x' removed from data out folder"</span>
  6<span class=input>.                 }</span>
  7<span class=input>.         else disp in yellow "`x' already removed."</span>
  8<span class=input>. }</span>
safetynets removed from data out folder
migration removed from data out folder
remitIn removed from data out folder
otherInc removed from data out folder
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
</pre>
</body>
</html>
