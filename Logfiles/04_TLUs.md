
<html>
<body>
<pre>
--------------------------------------------------------------------------------------------------------------------------------------------------
      name:  <span class=result>&lt;unnamed&gt;</span>
<span class=result>       </span>log:  <span class=result>U:\Bangladesh\Log/04_TLUs.smcl</span>
<span class=result>  </span>log type:  <span class=result>smcl</span>
<span class=result> </span>opened on:  <span class=result>20 Nov 2014, 10:09:46</span>
<br><br>
<span class=input>. set more off</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Load module with information on household assets. */</span>
<span class=input>. use "$pathin/023_mod_k1_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. * create vector of assets for which binary variables are created</span>
<span class=input>. #delimit ;</span>
delimiter now ;
<span class=input>. local lvstk bullock mcow buffalo goat sheep</span>
<span class=input>&gt;                 chicken duck othbirds other;</span>
<br><br>
<span class=input>. #delimit cr</span>
delimiter now cr
<span class=input>. </span>
<span class=input>. * Create three livestock variables all related to holdings in time.</span>
<span class=input>. local count = 1</span>
<br><br>
<span class=input>. foreach x of local lvstk {</span>
  2<span class=input>.         bys a01: g `x' = k1_04 if (livestock == `count')</span>
  3<span class=input>.         bys a01: g `x'2011beg = k1_02a if livestock == `count'</span>
  4<span class=input>.         bys a01: g `x'2011end = k1_03a if livestock == `count'</span>
  5<span class=input>.         </span>
<span class=input>.         replace `x' = 0 if `x' ==.</span>
  6<span class=input>.         replace `x'2011beg = 0 if `x'2011beg == .</span>
  7<span class=input>.         replace `x'2011end = 0 if `x'2011end == .       </span>
  8<span class=input>.         la var `x' "Total `x' owned by hh now "</span>
  9<span class=input>.         la var `x'2011beg "Total `x' owned in beg 2011"</span>
 10<span class=input>.         la var `x'2011end "Total `x' owned in end 2011"</span>
 11<span class=input>.         </span>
<span class=input>.         bys a01: g `x'diff = `x'2011end - `x'2011beg</span>
 12<span class=input>.         la var `x'diff "Change in `x' during 2011"</span>
 13<span class=input>.         </span>
<span class=input>.         * Check that asset matches order</span>
<span class=input>.         display in yellow "`x': `count' livestock code"</span>
 14<span class=input>.         local count = `count'+1</span>
 15<span class=input>.         }</span>
(9777 missing values generated)
(9777 missing values generated)
(9777 missing values generated)
(9777 real changes made)
(9777 real changes made)
(9777 real changes made)
<span class=result>bullock: 1 livestock code</span>
(10141 missing values generated)
(10141 missing values generated)
(10141 missing values generated)
(10141 real changes made)
(10141 real changes made)
(10141 real changes made)
<span class=result>mcow: 2 livestock code</span>
(11860 missing values generated)
(11860 missing values generated)
(11860 missing values generated)
(11860 real changes made)
(11860 real changes made)
(11860 real changes made)
<span class=result>buffalo: 3 livestock code</span>
(10612 missing values generated)
(10612 missing values generated)
(10612 missing values generated)
(10612 real changes made)
(10612 real changes made)
(10612 real changes made)
<span class=result>goat: 4 livestock code</span>
(11810 missing values generated)
(11810 missing values generated)
(11810 missing values generated)
(11810 real changes made)
(11810 real changes made)
(11810 real changes made)
<span class=result>sheep: 5 livestock code</span>
(7639 missing values generated)
(7639 missing values generated)
(7639 missing values generated)
(7639 real changes made)
(7639 real changes made)
(7639 real changes made)
<span class=result>chicken: 6 livestock code</span>
(11880 missing values generated)
(11880 missing values generated)
(11880 missing values generated)
(11880 real changes made)
(11880 real changes made)
(11880 real changes made)
<span class=result>duck: 7 livestock code</span>
(9710 missing values generated)
(9710 missing values generated)
(9710 missing values generated)
(9710 real changes made)
(9710 real changes made)
(9710 real changes made)
<span class=result>othbirds: 8 livestock code</span>
(11688 missing values generated)
(11688 missing values generated)
(11688 missing values generated)
(11688 real changes made)
(11688 real changes made)
(11688 real changes made)
<span class=result>other: 9 livestock code</span>
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. * Determine market unit price by taking total net value of sales / number sold</span>
<span class=input>. replace k1_18 =. if k1_18 == 0</span>
(0 real changes made)
<br><br>
<span class=input>. g unitprice = round(k1_18/ k1_16, 1)</span>
(9464 missing values generated)
<br><br>
<span class=input>. la var unitprice "Unit price of animal (based on sales)"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Calculate the median value of each animal in Bangladesh based on unit price</span>
<span class=input>. egen medvalanim = median(unitprice), by(livestock)</span>
<br><br>
<span class=input>. bys livestock: g valanim = k1_04 * medvalanim</span>
<br><br>
<span class=input>. la var valanim "Value of animal"</span>
<br><br>
<span class=input>. </span>
<span class=input>. *Calculate hh-level total</span>
<span class=input>. egen tvalanim = total(valanim), by(a01)</span>
<br><br>
<span class=input>. la var tvalanim "Total value of animals"</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Price summary of animals</span>
<span class=input>&gt; Livestock       Med. Val        Freq.</span>
<span class=input>&gt; bullock         18400   0       2103</span>
<span class=input>&gt; milk cow        14500   0       1739</span>
<span class=input>&gt; bufallo         15000   0       20</span>
<span class=input>&gt; goat            2200    0       1268</span>
<span class=input>&gt; sheep           1933.5  0       70</span>
<span class=input>&gt; chicken         170             0       4241</span>
<span class=input>&gt; duck            200             0       2170</span>
<span class=input>&gt; other bir       75              0       192</span>
<span class=input>&gt; others          60              0       77</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. * Collapse data down to household level (keep new vars and hh-id).</span>
<span class=input>. ds(k1* livestock), not</span>
a01           bullockdiff   buffalo       goat2011beg   sheep2011end  chickendiff   othbirds      other2011beg  valanim
sample_type   mcow          buffalo201~g  goat2011end   sheepdiff     duck          othbirds20~g  other2011end  tvalanim
bullock       mcow2011beg   buffalo201~d  goatdiff      chicken       duck2011beg   othbirds20~d  otherdiff
bullock201~g  mcow2011end   buffalodiff   sheep         chicken201~g  duck2011end   othbirdsdiff  unitprice
bullock201~d  mcowdiff      goat          sheep2011beg  chicken201~d  duckdiff      other         medvalanim
<br><br>
<span class=input>. keep `r(varlist)'</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Collapse to household level with usual pre/post labels</span>
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
<span class=input>. collapse (max) bullock-otherdiff tvalanim, by(a01) fast</span>
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
<span class=input>. * Merge in ag assets to get horse and mules</span>
<span class=input>. merge 1:1 a01 using "$pathout/hhpc.dta", gen(TLU_merge)</span>
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>           1,173</span>
        from master          <span class=result>               0</span>  (TLU_merge==1)
        from using           <span class=result>           1,173</span>  (TLU_merge==2)
<br><br>
    matched                  <span class=result>           5,330</span>  (TLU_merge==3)
    -----------------------------------------
<br><br>
<span class=input>. </span>
<span class=input>. /*Create TLU (based on values from http://www.fao.org/wairdocs/ilri/x5443e/x5443e04.htm)</span>
<span class=input>&gt; Notes: Sheep includes sheep and goats</span>
<span class=input>&gt; Horse includes all draught animals (donkey, horse, bullock)</span>
<span class=input>&gt; chxTLU includes all small animals (chicken, fowl, etc).*/</span>
<span class=input>. g cattleVal = 0.70</span>
<br><br>
<span class=input>. g sheepVal = 0.10</span>
<br><br>
<span class=input>. g horsesVal = 0.80</span>
<br><br>
<span class=input>. g mulesVal = 0.70</span>
<br><br>
<span class=input>. g assesVal = 0.50</span>
<br><br>
<span class=input>. g chxVal = 0.01</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Create TLU group values</span>
<span class=input>. g TLUcattle = (bullock + mcow + buffalo) * cattleVal</span>
(1173 missing values generated)
<br><br>
<span class=input>. g TLUsheep = (sheep + goat) * sheepVal</span>
(1173 missing values generated)
<br><br>
<span class=input>. g TLUhorses = (nhorse) * horsesVal</span>
<br><br>
<span class=input>. g TLUmules = (nmule) * mulesVal</span>
<br><br>
<span class=input>. g TLUasses = ndonkey * assesVal</span>
<br><br>
<span class=input>. g TLUchx = (chicken + duck + othbirds + other) * chxVal</span>
(1173 missing values generated)
<br><br>
<span class=input>. </span>
<span class=input>. * Generate overall TLUs</span>
<span class=input>. egen TLUtotal = rsum(TLUcattle TLUsheep TLUhorses TLUmules TLUasses TLUchx)</span>
<br><br>
<span class=input>. la var TLUtotal "Total tropical livestock units"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Clean up extra variables</span>
<span class=input>. drop cattleVal horsesVal mulesVal assesVal sheepVal chxVal TLUcattle TLUsheep TLUhorses TLUmules TLUasses TLUchx</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Compress &amp; save</span>
<span class=input>. save "$pathout/hhTLU_pc.dta", replace</span>
file U:\Bangladesh\Dataout/hhTLU_pc.dta saved
<br><br>
</pre>
</body>
</html>
