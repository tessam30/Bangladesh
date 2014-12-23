
<html>
<head>
</head>
<body>
<pre>
--------------------------------------------------------------------------------------------------------------------------------------------------
      name:  <span class=result>&lt;unnamed&gt;</span>
<span class=result>       </span>log:  <span class=result>U:\Bangladesh\Log/Malnutrition.smcl</span>
<span class=result>  </span>log type:  <span class=result>smcl</span>
<span class=result> </span>opened on:  <span class=result>16 Dec 2014, 15:24:30</span>
<br><br>
<span class=input>. clear</span>
<br><br>
<span class=input>. use "$pathin/046_mod_w2_female.dta"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Merge with hh details to get gender of child</span>
<span class=input>. merge 1:1 a01 mid using "$pathin\003_mod_b1_male.dta"</span>
(label sample_type already defined)
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>          24,374</span>
        from master          <span class=result>               0</span>  (_merge==1)
        from using           <span class=result>          24,374</span>  (_merge==2)
<br><br>
    matched                  <span class=result>           2,911</span>  (_merge==3)
    -----------------------------------------
<br><br>
<span class=input>. drop if _merge == 2</span>
(24374 observations deleted)
<br><br>
<span class=input>. drop _merge</span>
<br><br>
<span class=input>. merge m:1 a01 using "$pathin/001_mod_a_male.dta"</span>
(note: variable a01 was int, now double to accommodate using data's values)
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>           4,010</span>
        from master          <span class=result>               0</span>  (_merge==1)
        from using           <span class=result>           4,010</span>  (_merge==2)
<br><br>
    matched                  <span class=result>           2,911</span>  (_merge==3)
    -----------------------------------------
<br><br>
<span class=input>. drop if _merge ==2</span>
(4010 observations deleted)
<br><br>
<span class=input>. drop _merge</span>
<br><br>
<span class=input>. </span>
<span class=input>. keep a01 mid w2* b1_01 b1_02 a16_dd a16_mm a16_yy div_name /*</span>
<span class=input>&gt; */ District_Name Upazila_Name Union_Name hh_type div_name</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Clean up months</span>
<span class=input>. replace w2_04 = 1 if w2_04 == 0.5</span>
(1 real change made)
<br><br>
<span class=input>. </span>
<span class=input>. * Check days in month</span>
<span class=input>. tab w2_02</span>
<br><br>
childs date |
   of birth |
     (date) |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |<span class=result>        146        5.36        5.36</span>
          2 |<span class=result>        120        4.40        9.76</span>
          3 |<span class=result>         97        3.56       13.32</span>
          4 |<span class=result>         72        2.64       15.96</span>
          5 |<span class=result>        113        4.15       20.10</span>
          6 |<span class=result>         73        2.68       22.78</span>
          7 |<span class=result>         88        3.23       26.01</span>
          8 |<span class=result>         74        2.71       28.72</span>
          9 |<span class=result>         72        2.64       31.36</span>
         10 |<span class=result>        142        5.21       36.57</span>
         11 |<span class=result>         76        2.79       39.36</span>
         12 |<span class=result>        124        4.55       43.91</span>
         13 |<span class=result>         66        2.42       46.33</span>
         14 |<span class=result>         79        2.90       49.23</span>
         15 |<span class=result>        161        5.91       55.14</span>
         16 |<span class=result>        106        3.89       59.02</span>
         17 |<span class=result>         79        2.90       61.92</span>
         18 |<span class=result>         95        3.48       65.41</span>
         19 |<span class=result>         73        2.68       68.09</span>
         20 |<span class=result>        123        4.51       72.60</span>
         21 |<span class=result>         70        2.57       75.17</span>
         22 |<span class=result>         65        2.38       77.55</span>
         23 |<span class=result>         64        2.35       79.90</span>
         24 |<span class=result>         62        2.27       82.17</span>
         25 |<span class=result>        100        3.67       85.84</span>
         26 |<span class=result>         83        3.04       88.88</span>
         27 |<span class=result>         69        2.53       91.42</span>
         28 |<span class=result>         90        3.30       94.72</span>
         29 |<span class=result>         60        2.20       96.92</span>
         30 |<span class=result>         58        2.13       99.05</span>
         31 |<span class=result>         26        0.95      100.00</span>
------------+-----------------------------------
      Total |<span class=result>      2,726      100.00</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Calculate childrens age in months (should be under 5)</span>
<span class=input>. generate bday= mdy(w2_04, w2_02, w2_05)</span>
(187 missing values generated)
<br><br>
<span class=input>. replace bday = mdy(w2_04, 1, w2_05) if bday == .</span>
(171 real changes made)
<br><br>
<span class=input>. format bday %d </span>
<br><br>
<span class=input>. </span>
<span class=input>. gen intday = mdy(a16_mm, a16_dd, a16_yy)</span>
<br><br>
<span class=input>. form intday %d</span>
<br><br>
<span class=input>. </span>
<span class=input>. g ageMonths = (intday - bday)/(365/12)</span>
(16 missing values generated)
<br><br>
<span class=input>. </span>
<span class=input>. * Calculate z-scores using zscore06 package</span>
<span class=input>. zscore06, a(ageMonths) s(b1_01) h(w2_08) w(w2_07) measure(w2_09)</span>
<br><br>
<span class=result>Z-scores (haz06, waz06, bmiz06 and whz06) succesfully calculated</span>
<span class=result>*** note 1: 99 indicates that height, weight or age were out of the reference value range</span>
<span class=result>*** note 2: no zscores are calculated for children with missing age</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Remove scores that are implausible</span>
<span class=input>. replace haz06=. if haz06&lt;-6 | haz06&gt;6</span>
(18 real changes made, 18 to missing)
<br><br>
<span class=input>. replace waz06=. if waz06&lt;-6 | waz06&gt;5</span>
(4 real changes made, 4 to missing)
<br><br>
<span class=input>. replace whz06=. if whz06&lt;-5 | whz06&gt;5</span>
(18 real changes made, 18 to missing)
<br><br>
<span class=input>. replace bmiz06=. if bmiz06&lt;-5 | bmiz06&gt;5</span>
(17 real changes made, 17 to missing)
<br><br>
<span class=input>. </span>
<span class=input>. ren haz06 stunting</span>
<br><br>
<span class=input>. ren waz06 underweight</span>
<br><br>
<span class=input>. ren whz06 wasting</span>
<br><br>
<span class=input>. ren bmiz06 BMI</span>
<br><br>
<span class=input>. </span>
<span class=input>. la var stunting "Stunting: Length/height-for-age Z-score"</span>
<br><br>
<span class=input>. la var underweight "Underweight: Weight-for-age Z-score"</span>
<br><br>
<span class=input>. la var wasting "Wasting: Weight-for-length/height Z-score"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte stunted = stunting &lt; -2 if stunting != .</span>
(147 missing values generated)
<br><br>
<span class=input>. g byte underwgt = underweight &lt; -2 if underweight != . </span>
(101 missing values generated)
<br><br>
<span class=input>. g byte wasted = wasting &lt; -2 if wasting != . </span>
(147 missing values generated)
<br><br>
<span class=input>. g byte BMIed = BMI &lt;-2 if BMI ~= . </span>
(146 missing values generated)
<br><br>
<span class=input>. la var stunted "Child is stunting"</span>
<br><br>
<span class=input>. la var underwgt "Child is underweight for age"</span>
<br><br>
<span class=input>. la var wasted "Child is wasting"</span>
<br><br>
<span class=input>. </span>
<span class=input>. sum stunted underwgt wasted</span>
<br><br>
    Variable |       Obs        Mean    Std. Dev.       Min        Max
-------------+--------------------------------------------------------
     stunted |<span class=result>      2764    .4634588    .4987532          0          1</span>
    underwgt |<span class=result>      2810    .3419929    .4744617          0          1</span>
      wasted |<span class=result>      2764    .1230101    .3285083          0          1</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Values can be interpreted as standard deviations shorter/lower than</span>
<span class=input>&gt; the referene population. </span>
<span class=input>&gt; A child is considered to be malnourished if her relevant z-score </span>
<span class=input>&gt; is less than 2.0.*/</span>
<span class=input>. </span>
<span class=input>. la var bday "Birthday of hh member"</span>
<br><br>
<span class=input>. la var intday "Interview date"</span>
<br><br>
<span class=input>. la var ageMonth "Age of respondent in months"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Calculate those below 2 s.d. for each score at District, Upazila, Union</span>
<span class=input>. foreach x of varlist stunted underwgt wasted BMI {</span>
  2<span class=input>.         egen `x'Div = mean(`x'), by(div_name)</span>
  3<span class=input>.         copydesc `x' `x'Div</span>
  4<span class=input>.         egen `x'Dist = mean(`x'), by(District_Name)</span>
  5<span class=input>.         copydesc `x' `x'Dist </span>
  6<span class=input>.         egen `x'Upaz = mean(`x'), by(Upazila_Name)</span>
  7<span class=input>.         copydesc `x' `x'Upaz </span>
  8<span class=input>.         egen `x'Union = mean(`x'), by(Union_Name)</span>
  9<span class=input>.         copydesc `x' `x'Union </span>
 10<span class=input>. }</span>
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. * Those with scores of less than -2 are considered to be malnourished;</span>
<span class=input>. * use tab div_name, sum(stundedDiv) for summary stats</span>
<span class=input>. </span>
<span class=input>. clonevar height = w2_08</span>
(128 missing values generated)
<br><br>
<span class=input>. clonevar weight = w2_07</span>
(96 missing values generated)
<br><br>
<span class=input>. clonevar gender = b1_01</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Create summary statistics for use in R/</span>
<span class=input>. foreach x of varlist stunted underwgt wasted {</span>
  2<span class=input>.         ttest `x', by(gender)</span>
  3<span class=input>. }</span>
<br><br>
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
    male |<span class=result>    1382    .4797395    .0134436    .4997702    .4533674    .5061116</span>
<span class=result>  </span>female |<span class=result>    1382     .447178    .0133794     .497382    .4209319    .4734241</span>
---------+--------------------------------------------------------------------
combined |<span class=result>    2764    .4634588    .0094867    .4987532     .444857    .4820606</span>
---------+--------------------------------------------------------------------
    diff |<span class=result>            .0325615    .0189668                -.004629     .069752</span>
------------------------------------------------------------------------------
    diff = mean(<span class=result>male</span>) - mean(<span class=result>female</span>)                              t = <span class=result>  1.7168</span>
Ho: diff = 0                                     degrees of freedom = <span class=result>    2762</span>
<br><br>
<span class=result>    </span>Ha: diff &lt; 0                 Ha: diff != 0                 Ha: diff &gt; 0
 Pr(T &lt; t) = <span class=result>0.9569         </span>Pr(|T| &gt; |t|) = <span class=result>0.0861          </span>Pr(T &gt; t) = <span class=result>0.0431</span>
<br><br>
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
    male |<span class=result>    1403    .3385602    .0126383    .4733888    .3137682    .3633523</span>
<span class=result>  </span>female |<span class=result>    1407    .3454158    .0126812    .4756727    .3205396    .3702919</span>
---------+--------------------------------------------------------------------
combined |<span class=result>    2810    .3419929    .0089505    .4744617    .3244426    .3595431</span>
---------+--------------------------------------------------------------------
    diff |<span class=result>           -.0068556    .0179038               -.0419614    .0282503</span>
------------------------------------------------------------------------------
    diff = mean(<span class=result>male</span>) - mean(<span class=result>female</span>)                              t = <span class=result> -0.3829</span>
Ho: diff = 0                                     degrees of freedom = <span class=result>    2808</span>
<br><br>
<span class=result>    </span>Ha: diff &lt; 0                 Ha: diff != 0                 Ha: diff &gt; 0
 Pr(T &lt; t) = <span class=result>0.3509         </span>Pr(|T| &gt; |t|) = <span class=result>0.7018          </span>Pr(T &gt; t) = <span class=result>0.6491</span>
<br><br>
Two-sample t test with equal variances
------------------------------------------------------------------------------
   Group |     Obs        Mean    Std. Err.   Std. Dev.   [95% Conf. Interval]
---------+--------------------------------------------------------------------
    male |<span class=result>    1377    .1220044    .0088232    .3274097     .104696    .1393127</span>
<span class=result>  </span>female |<span class=result>    1387    .1240087    .0088531    .3297103    .1066418    .1413755</span>
---------+--------------------------------------------------------------------
combined |<span class=result>    2764    .1230101    .0062485    .3285083    .1107579    .1352624</span>
---------+--------------------------------------------------------------------
    diff |<span class=result>           -.0020043    .0124993               -.0265133    .0225047</span>
------------------------------------------------------------------------------
    diff = mean(<span class=result>male</span>) - mean(<span class=result>female</span>)                              t = <span class=result> -0.1604</span>
Ho: diff = 0                                     degrees of freedom = <span class=result>    2762</span>
<br><br>
<span class=result>    </span>Ha: diff &lt; 0                 Ha: diff != 0                 Ha: diff &gt; 0
 Pr(T &lt; t) = <span class=result>0.4363         </span>Pr(|T| &gt; |t|) = <span class=result>0.8726          </span>Pr(T &gt; t) = <span class=result>0.5637</span>
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. * Create an extract for making graphics in R</span>
<span class=input>. preserve</span>
<br><br>
<span class=input>. collapse stuntedDiv stuntedDist underwgtDiv underwgtDist wastedDiv wastedDist, by(District_Name div_name)</span>
<br><br>
<span class=input>. export delimited using "$pathexport/malnutrition.csv", replace</span>
file U:\Bangladesh\Export/malnutrition.csv saved
<br><br>
<span class=input>. restore</span>
<br><br>
<span class=input>. </span>
<span class=input>. compress</span>
<span class=result>  </span>w2_04 was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>b1_02 was <span class=result>int</span> now <span class=result>byte</span>
<span class=result>  </span>a01 was <span class=result>double</span> now <span class=result>int</span>
<span class=result>  </span>hh_type was <span class=result>double</span> now <span class=result>byte</span>
<span class=result>  </span>a16_dd was <span class=result>double</span> now <span class=result>byte</span>
<span class=result>  </span>a16_mm was <span class=result>double</span> now <span class=result>byte</span>
<span class=result>  </span>a16_yy was <span class=result>double</span> now <span class=result>int</span>
<span class=result>  </span>bday was <span class=result>double</span> now <span class=result>int</span>
<span class=result>  </span>intday was <span class=result>double</span> now <span class=result>int</span>
<span class=result>  </span>div_name was <span class=result>str244</span> now <span class=result>str10</span>
<span class=result>  </span>District_Name was <span class=result>str48</span> now <span class=result>str12</span>
<span class=result>  </span>Upazila_Name was <span class=result>str48</span> now <span class=result>str20</span>
<span class=result>  </span>Union_Name was <span class=result>str48</span> now <span class=result>str20</span>
  (1,091,625 bytes saved)
<br><br>
<span class=input>. save "$pathout/ChildHealth_indiv.dta", replace</span>
file U:\Bangladesh\Dataout/ChildHealth_indiv.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. * Collapse data down to household level</span>
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
<span class=input>. collapse (max) stunted underwgt wasted BMIed (mean) stunting height weight gender /*</span>
<span class=input>&gt; */ underweight wasting, by(a01 div_name District_Name Upazila_Name Union_Name)</span>
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
<span class=input>. save "$pathout/ChildHealth_hh.dta", replace</span>
file U:\Bangladesh\Dataout/ChildHealth_hh.dta saved
<br><br>
<span class=input>. </span>
</pre>
</body>
</html>
