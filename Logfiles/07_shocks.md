
<html>
<body>
<pre>
--------------------------------------------------------------------------------------------------------------------------------------------------
      name:  <span class=result>&lt;unnamed&gt;</span>
<span class=result>       </span>log:  <span class=result>U:\Bangladesh\Log/07_shocks.smcl</span>
<span class=result>  </span>log type:  <span class=result>smcl</span>
<span class=result> </span>opened on:  <span class=result>20 Nov 2014, 11:02:29</span>
<br><br>
<span class=input>. </span>
<span class=input>. set more off</span>
<br><br>
<span class=input>. * Load the data for negative shocks</span>
<span class=input>. use "$pathin\038_mod_t1_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Look at shock variables; For sorted tabulations (*ssc install tab_chi)</span>
<span class=input>. tabsort t1_02 t1_05 if inlist(t1_10, 1, 2), mi</span>
<br><br>
<span class=result>                      </span>|                          when did it happen? (year)
          shcoks code |      2011       2009       2010       2008       2007       2012       2006 |     Total
----------------------+-----------------------------------------------------------------------------+----------
medical expenses due  |<span class=result>       519        306        294        205        106          4         17 </span>|<span class=result>     1,451 </span>
increase in food pric |<span class=result>       377         10          7          3          3         47          1 </span>|<span class=result>       448 </span>
loss of productive as |<span class=result>        35         56         16         21        204          0          3 </span>|<span class=result>       335 </span>
loss of livestock due |<span class=result>        96         80         53         44         13          2          3 </span>|<span class=result>       291 </span>
loss of income due to |<span class=result>        90         55         43         44         15          5          3 </span>|<span class=result>       255 </span>
             others-1 |<span class=result>        62         45         40         47         25          0          5 </span>|<span class=result>       224 </span>
major loss of crops d |<span class=result>        55         62         48         20         14          0          0 </span>|<span class=result>       199 </span>
major loss of crops d |<span class=result>        67         37         51         10         11          2          0 </span>|<span class=result>       178 </span>
other costs of weddin |<span class=result>        45         36         38         28          9          2          0 </span>|<span class=result>       158 </span>
losses due to court c |<span class=result>        29         32         21         23         15          0          5 </span>|<span class=result>       125 </span>
        dowry payment |<span class=result>        28         23         35         21          9          0          0 </span>|<span class=result>       116 </span>
 death of main earner |<span class=result>        15         32         20         23         15          0          1 </span>|<span class=result>       106 </span>
failure or bankruptcy |<span class=result>        31         32         17         16          8          0          2 </span>|<span class=result>       106 </span>
   cost of court case |<span class=result>        32         21         18         15          8          0          6 </span>|<span class=result>       100 </span>
loss or destruction o |<span class=result>         8         10          7         16         34          0          3 </span>|<span class=result>        78 </span>
death of other than m |<span class=result>        29         13         10         11          7          1          2 </span>|<span class=result>        73 </span>
lost home due to rive |<span class=result>         4         17          5         12         15          0          0 </span>|<span class=result>        53 </span>
loss of productive as |<span class=result>        10          7          9          3         15          0          2 </span>|<span class=result>        46 </span>
loss of consumption a |<span class=result>         4         10          7          4         11          0          1 </span>|<span class=result>        37 </span>
loss of a regular job |<span class=result>         7         11         11          3          1          0          0 </span>|<span class=result>        33 </span>
loss of livestock due |<span class=result>         6          6          7          7          6          0          1 </span>|<span class=result>        33 </span>
divorce or abandonmen |<span class=result>         5          5          7          4          2          0          0 </span>|<span class=result>        23 </span>
     paid a big bribe |<span class=result>         5          2          3          6          3          0          0 </span>|<span class=result>        19 </span>
loss of livestock due |<span class=result>         3          6          4          1          3          0          0 </span>|<span class=result>        17 </span>
 extortion by mastans |<span class=result>         4          3          4          2          1          0          1 </span>|<span class=result>        15 </span>
             others-2 |<span class=result>         9          1          1          3          1          0          0 </span>|<span class=result>        15 </span>
eviction from previou |<span class=result>         2          4          2          1          2          0          0 </span>|<span class=result>        11 </span>
reparations for victi |<span class=result>         4          0          3          3          1          0          0 </span>|<span class=result>        11 </span>
division of fathers  |<span class=result>         2          3          2          2          0          0          1 </span>|<span class=result>        10 </span>
household member arre |<span class=result>         2          1          5          1          0          0          0 </span>|<span class=result>         9 </span>
cut-off or decrease o |<span class=result>         5          1          1          0          0          0          0 </span>|<span class=result>         7 </span>
increase in prices of |<span class=result>         4          1          0          1          0          0          0 </span>|<span class=result>         6 </span>
long duration hartals |<span class=result>         2          1          0          1          0          0          0 </span>|<span class=result>         4 </span>
family member put in  |<span class=result>         1          1          0          1          0          0          0 </span>|<span class=result>         3 </span>
withdrawal of ngo ass |<span class=result>         3          0          0          0          0          0          0 </span>|<span class=result>         3 </span>
----------------------+-----------------------------------------------------------------------------+----------
                Total |<span class=result>     1,600        930        789        602        557         63         57 </span>|<span class=result>     4,598 </span>
<br><br>
<br><br>
<span class=input>. </span>
<span class=input>. /* Major shocks are related to medical expenses due to illness or injury (30%); Food price</span>
<span class=input>&gt; shocks were common in 2011 and slightly in 2012. The 2007 floods appear to have</span>
<span class=input>&gt; affected about 207 households asset base. May be interesting to see how they've recovered.</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. * what is the timing of shocks? Most med expenses incurred in Feb through October</span>
<span class=input>. tab t1_02 t1_04 if inlist(t1_10, 1, 2) &amp; t1_05 == 2011</span>
<br><br>
<span class=result>                      </span>|                                          when did it happen? (month)
          shcoks code |         1          2          3          4          5          6          7          8          9         10 |     Total
----------------------+--------------------------------------------------------------------------------------------------------------+----------
death of main earner  |<span class=result>         1          1          5          0          0          2          0          1          1          0 </span>|<span class=result>        15 </span>
death of other than m |<span class=result>         2          1          4          0          3          2          2          4          2          3 </span>|<span class=result>        29 </span>
loss of income due to |<span class=result>         5         10         10          5          5         11          7          8         10         13 </span>|<span class=result>        90 </span>
medical expenses due  |<span class=result>        31         43         37         57         45         63         41         58         43         52 </span>|<span class=result>       519 </span>
loss of a regular job |<span class=result>         0          1          1          1          0          2          0          1          0          0 </span>|<span class=result>         7 </span>
lost home due to rive |<span class=result>         0          0          1          0          0          0          1          1          1          0 </span>|<span class=result>         4 </span>
eviction from previou |<span class=result>         1          0          0          0          0          0          0          1          0          0 </span>|<span class=result>         2 </span>
divorce or abandonmen |<span class=result>         1          1          0          1          0          1          0          1          0          0 </span>|<span class=result>         5 </span>
major loss of crops d |<span class=result>         0          0          1          2          2          7         13          9         11          7 </span>|<span class=result>        55 </span>
major loss of crops d |<span class=result>         2          2          7          6          1          6          3          7         16          8 </span>|<span class=result>        67 </span>
loss of livestock due |<span class=result>         0          1          0          0          0          1          1          0          0          0 </span>|<span class=result>         3 </span>
loss of livestock due |<span class=result>         4          5          7          8         10         18          6          8          9         11 </span>|<span class=result>        96 </span>
loss of livestock due |<span class=result>         1          0          1          1          0          1          1          0          0          0 </span>|<span class=result>         6 </span>
loss of productive as |<span class=result>         0          0          0          0          0          3          6          1          0          0 </span>|<span class=result>        10 </span>
loss of productive as |<span class=result>         2          6          2          3          3          3          2          4          1          2 </span>|<span class=result>        35 </span>
loss or destruction o |<span class=result>         1          0          0          0          1          0          3          1          0          1 </span>|<span class=result>         8 </span>
loss of consumption a |<span class=result>         0          2          0          0          0          1          0          0          1          0 </span>|<span class=result>         4 </span>
        dowry payment |<span class=result>         0          1          2          1          4          4          5          3          2          3 </span>|<span class=result>        28 </span>
other costs of weddin |<span class=result>         4          2          4          3          2          9          5          3          1          5 </span>|<span class=result>        45 </span>
division of fathers  |<span class=result>         0          0          0          0          2          0          0          0          0          0 </span>|<span class=result>         2 </span>
failure or bankruptcy |<span class=result>         2          1          4          2          2          3          4          5          3          2 </span>|<span class=result>        31 </span>
extortion by mastans  |<span class=result>         1          0          1          0          0          1          0          1          0          0 </span>|<span class=result>         4 </span>
family member put in  |<span class=result>         0          0          0          0          0          0          0          0          0          0 </span>|<span class=result>         1 </span>
household member arre |<span class=result>         0          0          0          1          0          0          1          0          0          0 </span>|<span class=result>         2 </span>
   paid a big bribe   |<span class=result>         0          0          0          0          0          0          0          1          1          0 </span>|<span class=result>         5 </span>
   cost of court case |<span class=result>         1          5          1          3          1          1          1          6          6          4 </span>|<span class=result>        32 </span>
losses due to court c |<span class=result>         1          1          2          3          2          3          2          6          2          3 </span>|<span class=result>        29 </span>
reparations for victi |<span class=result>         0          1          0          0          0          0          0          0          0          2 </span>|<span class=result>         4 </span>
long duration hartals |<span class=result>         0          0          0          0          0          0          0          1          0          0 </span>|<span class=result>         2 </span>
cut-off or decrease o |<span class=result>         0          0          1          0          1          1          0          1          1          0 </span>|<span class=result>         5 </span>
withdrawal of ngo ass |<span class=result>         0          1          0          1          0          0          0          0          0          0 </span>|<span class=result>         3 </span>
increase in food pric |<span class=result>         3          8         37         51         27         16         27         76         60         43 </span>|<span class=result>       377 </span>
increase in prices of |<span class=result>         1          0          1          0          0          0          0          1          0          1 </span>|<span class=result>         4 </span>
             others-1 |<span class=result>         3          7         10          6          2          5          6          9          7          3 </span>|<span class=result>        62 </span>
             others-2 |<span class=result>         0          0          1          1          3          2          1          1          0          0 </span>|<span class=result>         9 </span>
----------------------+--------------------------------------------------------------------------------------------------------------+----------
                Total |<span class=result>        67        100        140        156        116        166        138        219        178        163 </span>|<span class=result>     1,600 </span>
<br><br>
<br><br>
<span class=result>                      </span>|  when did it happen?
                      |        (month)
          shcoks code |        11         12 |     Total
----------------------+----------------------+----------
death of main earner  |<span class=result>         0          4 </span>|<span class=result>        15 </span>
death of other than m |<span class=result>         4          2 </span>|<span class=result>        29 </span>
loss of income due to |<span class=result>         5          1 </span>|<span class=result>        90 </span>
medical expenses due  |<span class=result>        27         22 </span>|<span class=result>       519 </span>
loss of a regular job |<span class=result>         1          0 </span>|<span class=result>         7 </span>
lost home due to rive |<span class=result>         0          0 </span>|<span class=result>         4 </span>
eviction from previou |<span class=result>         0          0 </span>|<span class=result>         2 </span>
divorce or abandonmen |<span class=result>         0          0 </span>|<span class=result>         5 </span>
major loss of crops d |<span class=result>         2          1 </span>|<span class=result>        55 </span>
major loss of crops d |<span class=result>         5          4 </span>|<span class=result>        67 </span>
loss of livestock due |<span class=result>         0          0 </span>|<span class=result>         3 </span>
loss of livestock due |<span class=result>         7          3 </span>|<span class=result>        96 </span>
loss of livestock due |<span class=result>         1          0 </span>|<span class=result>         6 </span>
loss of productive as |<span class=result>         0          0 </span>|<span class=result>        10 </span>
loss of productive as |<span class=result>         7          0 </span>|<span class=result>        35 </span>
loss or destruction o |<span class=result>         1          0 </span>|<span class=result>         8 </span>
loss of consumption a |<span class=result>         0          0 </span>|<span class=result>         4 </span>
        dowry payment |<span class=result>         2          1 </span>|<span class=result>        28 </span>
other costs of weddin |<span class=result>         2          5 </span>|<span class=result>        45 </span>
division of fathers  |<span class=result>         0          0 </span>|<span class=result>         2 </span>
failure or bankruptcy |<span class=result>         1          2 </span>|<span class=result>        31 </span>
extortion by mastans  |<span class=result>         0          0 </span>|<span class=result>         4 </span>
family member put in  |<span class=result>         1          0 </span>|<span class=result>         1 </span>
household member arre |<span class=result>         0          0 </span>|<span class=result>         2 </span>
   paid a big bribe   |<span class=result>         1          2 </span>|<span class=result>         5 </span>
   cost of court case |<span class=result>         0          3 </span>|<span class=result>        32 </span>
losses due to court c |<span class=result>         3          1 </span>|<span class=result>        29 </span>
reparations for victi |<span class=result>         1          0 </span>|<span class=result>         4 </span>
long duration hartals |<span class=result>         1          0 </span>|<span class=result>         2 </span>
cut-off or decrease o |<span class=result>         0          0 </span>|<span class=result>         5 </span>
withdrawal of ngo ass |<span class=result>         1          0 </span>|<span class=result>         3 </span>
increase in food pric |<span class=result>        20          9 </span>|<span class=result>       377 </span>
increase in prices of |<span class=result>         0          0 </span>|<span class=result>         4 </span>
             others-1 |<span class=result>         3          1 </span>|<span class=result>        62 </span>
             others-2 |<span class=result>         0          0 </span>|<span class=result>         9 </span>
----------------------+----------------------+----------
                Total |<span class=result>        96         61 </span>|<span class=result>     1,600 </span>
<br><br>
<br><br>
<span class=input>. </span>
<span class=input>. /* Create sub-aggregated shocks, criteria follow:</span>
<span class=input>&gt; 1) Shock must be listed as worst or 2nd worst</span>
<span class=input>&gt; 2) Shocks can have occured anytime in last 5 years or recent 3 years</span>
<span class=input>&gt; 3) Shocks are aggregated up to general categories to help w/ power</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. *Total shocks in past 5 years of any type</span>
<span class=input>. bys a01: g shkTot = _N</span>
<br><br>
<span class=input>. la var shkTot "Total shocks reported of all types"</span>
<br><br>
<span class=input>. </span>
<span class=input>. egen shkLossTot = total(t1_07), by(a01)</span>
<br><br>
<span class=input>. la var shkLossTot "Total value of loss due to shocks"</span>
<br><br>
<span class=input>. </span>
<span class=input>. egen shkLossTotR = total(t1_07) if inlist(t1_05, 2010, 2011, 2012), by(a01)</span>
(2256 missing values generated)
<br><br>
<span class=input>. *replace shkLossTotR = 0 if shkLossTotR==.</span>
<span class=input>. la var shkLossTot "Total value of loss due to shocks in last 5 years"</span>
<br><br>
<span class=input>. la var shkLossTotR "Total value of loss due to shocks in last 3 years"</span>
<br><br>
<span class=input>. </span>
<span class=input>. ** Please refer to crosswalk **</span>
<span class=input>. * Loss of income or medical expenses due to illness, injury, or death.</span>
<span class=input>. g byte healthshk = inlist(t1_02, 1, 2, 3, 4) &amp; inlist(t1_10, 1, 2)</span>
<br><br>
<span class=input>. g byte healthshkR = inlist(t1_02, 1, 2, 3, 4) &amp; inlist(t1_10, 1, 2) &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. la var healthshk "Loss of income or medical expenses due to illness or injury"</span>
<br><br>
<span class=input>. la var healthshkR "Loss of income or medical expenses due to illness or injury in last 3 years"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Because of frequency create annual health shock dummy</span>
<span class=input>. foreach x of numlist 2007(1)2011 {</span>
  2<span class=input>.         g byte healthshk`x' =inlist(t1_02, 1, 2, 3, 4) &amp; inlist(t1_10, 1, 2) &amp; t1_05 == `x'</span>
  3<span class=input>.         la var healthshk`x' "Health shock in `x'"</span>
  4<span class=input>.         }</span>
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. * See if health shocks are recurring in same HH</span>
<span class=input>. foreach x of numlist 2007(1)2012 {</span>
  2<span class=input>.         g tmpshk`x' = inlist(t1_02, 1, 2, 3, 4) &amp; inlist(t1_10, 1, 2) &amp; t1_05 == `x'</span>
  3<span class=input>. }       </span>
<br><br>
<span class=input>. *end</span>
<span class=input>. egen healthshkHist = rsum(tmpshk2007 tmpshk2008 tmpshk2009 tmpshk2010 tmpshk2011 tmpshk2012)</span>
<br><br>
<span class=input>. la var healthshkHist "Number of total health shocks in last 5 years"</span>
<br><br>
<span class=input>. drop tmpshk*</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Any flood related shock (includes loss of livestock and crops specifically due to flood)</span>
<span class=input>. g byte floodshk = inlist(t1_02, 6, 9, 11, 14, 16) &amp; inlist(t1_10, 1, 2)</span>
<br><br>
<span class=input>. g byte floodshkR = inlist(t1_02, 6, 9, 11, 14, 16) &amp; inlist(t1_10, 1, 2) &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. g byte floodshk2007 = inlist(t1_02, 6, 9, 11, 14, 16) &amp; inlist(t1_10, 1, 2) &amp; inlist(t1_05, 2007)</span>
<br><br>
<span class=input>. la var floodshk "Any flood related shock"</span>
<br><br>
<span class=input>. la var floodshkR "Any flood related shock in last 3 years"</span>
<br><br>
<span class=input>. la var floodshk2007 "Flood related shock in 2007 (Cyclone Sidr)"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Ag shocks for any reason (includes livestock and crops)</span>
<span class=input>. g byte agshk = inlist(t1_02, 9, 10, 11, 12, 13) &amp; inlist(t1_10, 1, 2) </span>
<br><br>
<span class=input>. g byte agshkR = inlist(t1_02, 9, 10, 11, 12, 13) &amp; inlist(t1_10, 1, 2) &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. la var agshk "Any type of agricultural shock"</span>
<br><br>
<span class=input>. la var agshkR "Any type of agricultural shock in last 3 years"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Asset shocks (loss of productivive and non-productive assets)</span>
<span class=input>. g byte assetshk = inlist(t1_02, 14, 15, 16, 17) &amp; inlist(t1_10, 1, 2) </span>
<br><br>
<span class=input>. g byte assetshkR = inlist(t1_02, 14, 15, 16, 17) &amp; inlist(t1_10, 1, 2) &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. la var assetshk "Loss of productive and non-productive assets"</span>
<br><br>
<span class=input>. la var assetshkR "Loss of productive and non-productive assets in last 3 years"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Financial shocks (dowry, wedding, bribes, extortion, bankruptcy, division of property, court)</span>
<span class=input>. g byte finshk = inlist(t1_02, 5, 18, 19, 20, 21, 22, 25, 26, 27, 28, 30, 31) &amp; inlist(t1_10, 1, 2) </span>
<br><br>
<span class=input>. g byte finshkR = inlist(t1_02, 5, 18, 19, 20, 21, 22, 25, 26, 27, 28, 30, 31) &amp; inlist(t1_10, 1, 2) &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. la var finshk "Any type of financial shock (dowry, wedding, bribes, extortion...etc)"</span>
<br><br>
<span class=input>. la var finshkR "Any type of financial shock (dowry, wedding, bribes, extortion...etc)"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Food price shock</span>
<span class=input>. g byte priceshk = inlist(t1_02, 32, 33) &amp; inlist(t1_10, 1, 2) </span>
<br><br>
<span class=input>. g byte priceshkR = inlist(t1_02, 32) &amp; inlist(t1_10, 1, 2) &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. la var priceshk "Price shock"</span>
<br><br>
<span class=input>. la var priceshkR "Price shock in last 3 years"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Other shocks</span>
<span class=input>. g byte othershk = inlist(t1_02, 7, 8, 23, 24, 29, 34, 35) &amp; inlist(t1_10, 1, 2) </span>
<br><br>
<span class=input>. g byte othershkR = inlist(t1_02, 7, 8, 23, 24, 29, 34, 35) &amp; inlist(t1_10, 1, 2) &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. la var othershk "Other shocks including eviction, divorce, arrested, prision, other"</span>
<br><br>
<span class=input>. la var othershkR "Other shocks including eviction, divorce, arrested, prision, other in last 3 years"</span>
note: label truncated to 80 characters
<br><br>
<span class=input>. </span>
<span class=input>. * Calculate total loss value of each type of shock &amp; coping strategy</span>
<span class=input>. foreach x of varlist healthshk floodshk agshk assetshk finshk priceshk {</span>
  2<span class=input>.         egen `x'Tot = total(t1_07) if `x' == 1, by(a01)</span>
  3<span class=input>.         la var `x'Tot "Total loss value of `x'"</span>
  4<span class=input>.         egen `x'RTot = total(t1_07) if `x'R == 1, by(a01)</span>
  5<span class=input>.         la var `x'RTot "Total loss value of `x'"</span>
  6<span class=input>. }</span>
(3012 missing values generated)
(3867 missing values generated)
(4504 missing values generated)
(4744 missing values generated)
(4179 missing values generated)
(4503 missing values generated)
(4401 missing values generated)
(4801 missing values generated)
(4194 missing values generated)
(4547 missing values generated)
(4443 missing values generated)
(4466 missing values generated)
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. /* Coping Mechanisms - What are good v. bad coping strategies? From (Heltberg et al., 2013)</span>
<span class=input>&gt;         http://siteresources.worldbank.org/EXTNWDR2013/Resources/8258024-1352909193861/</span>
<span class=input>&gt;         8936935-1356011448215/8986901-1380568255405/WDR15_bp_What_are_the_Sources_of_Risk_Oviedo.pdf</span>
<span class=input>&gt;         Good Coping:: use of savings, credit, asset sales, additional employment, </span>
<span class=input>&gt;                                         migration, and assistance</span>
<span class=input>&gt;         Bad Coping : increases vulnerabiliy* compromising health and edudcation </span>
<span class=input>&gt;                                 expenses, productive asset sales, conumsumption reductions </span>
<span class=input>&gt;         NOTE: Codebook pp 75 of survey has inconsistencies with the data.</span>
<span class=input>&gt;                                 */</span>
<span class=input>.                                 </span>
<span class=input>. g byte nocope =   t1_08a == 1</span>
<br><br>
<span class=input>. g byte goodcope = inlist(t1_08a, 6, 7, 8, 9, 13, 19, 20, 21, 22, 23, 24) </span>
<br><br>
<span class=input>. g byte badcope =  inlist(t1_08a, 2, 3, 4, 5, 10, 11, 12, 14, 15, 16, 17, 18) </span>
<br><br>
<span class=input>. g byte loancopeNGO = inlist(t1_08a, 9)</span>
<br><br>
<span class=input>. g byte loancopeMahajan = inlist(t1_08a, 9)</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte nocopeR =   t1_08a == 1 &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. g byte goodcopeR = inlist(t1_08a, 6, 7, 8, 9, 13, 19, 20, 21, 22, 23, 24)  &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. g byte badcopeR =  inlist(t1_08a, 2, 3, 4, 5, 10, 11, 12, 14, 15, 16, 17, 18) &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. g byte loancopeNGOR = inlist(t1_08a, 9) &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. g byte loancopeMahajanR = inlist(t1_08a, 9) &amp; inlist(t1_05, 2010, 2011, 2012)</span>
<br><br>
<span class=input>. </span>
<span class=input>. la var nocope "No coping strategy used by hh"</span>
<br><br>
<span class=input>. la var goodcope "Good coping strategy"</span>
<br><br>
<span class=input>. la var badcope "Bad coping strategy"</span>
<br><br>
<span class=input>. la var loancopeNGO "To cope take NGO loan"</span>
<br><br>
<span class=input>. la var loancopeMahajan "To cope take money lender loan"</span>
<br><br>
<span class=input>. </span>
<span class=input>. la var nocopeR "No coping strategy used by hh in last 3 years"</span>
<br><br>
<span class=input>. la var goodcopeR "Good coping strategy in last 3 years"</span>
<br><br>
<span class=input>. la var badcopeR "Bad coping strategy in last 3 years"</span>
<br><br>
<span class=input>. la var loancopeNGOR "To cope take NGO loan in last 3 years"</span>
<br><br>
<span class=input>. la var loancopeMahajanR "To cope take money lender loan in last 3 years"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Collapse data down to household level making everything wide</span>
<span class=input>. qui ds (t1*), not</span>
<br><br>
<span class=input>. keep `r(varlist)'</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Collapse down to hh</span>
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
<span class=input>. qui ds(a01 sample_type), not</span>
<br><br>
<span class=input>. collapse (max) `r(varlist)', by(a01)</span>
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
<span class=input>. * Save as negative shocks</span>
<span class=input>. save "$pathout/negshocks.dta", replace</span>
file U:\Bangladesh\Dataout/negshocks.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. ** Load positive shock data **</span>
<span class=input>. use "$pathin/039_mod_t2_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Create positive shock variables</span>
<span class=input>. g byte edshkpos = inlist(t2_02, 9, 10, 26) &amp; inlist(t2_07, 1, 2) &amp; t2_03 == 1</span>
<br><br>
<span class=input>. la var edshkpos "Positive educational income shock"</span>
<br><br>
<span class=input>. egen edshkTot = total(t2_06) if edshkpos == 1, by(a01)</span>
(76900 missing values generated)
<br><br>
<span class=input>. la var edshkTot "Total value of educational shock"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Replace zeros with stipend values listed in question (100 taka)</span>
<span class=input>. replace edshkTot = 100 if edshkTot == 0 &amp; inlist(t2_02, 9)</span>
(1124 real changes made)
<br><br>
<span class=input>. </span>
<span class=input>. g byte finshkpos = inlist(t2_02, 2, 3, 4, 5) &amp; inlist(t2_07, 1, 2) &amp; t2_03 == 1</span>
<br><br>
<span class=input>. la var finshkpos "Positive financial shock not employment related"</span>
<br><br>
<span class=input>. egen finshkTot = total(t2_06) if finshkpos == 1, by(a01)</span>
(78141 missing values generated)
<br><br>
<span class=input>. la var finshkTot "Total value of financial shock"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte bizshkpos = inlist(t2_02, 1, 6) &amp; inlist(t2_07, 1, 2) &amp; t2_03 == 1</span>
<br><br>
<span class=input>. la var bizshkpos "Positive income shock related to employment or business"</span>
<br><br>
<span class=input>. egen bizshkTot = total(t2_06) if bizshkpos == 1, by(a01)</span>
(78160 missing values generated)
<br><br>
<span class=input>. la var bizshkTot "Total value of business/employment shock"</span>
<br><br>
<span class=input>. </span>
<span class=input>. qui ds (t2*), not</span>
<br><br>
<span class=input>. keep `r(varlist)'</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Collapse down to hh</span>
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
<span class=input>. ds(a01 sample_type), not</span>
edshkpos   edshkTot   finshkpos  finshkTot  bizshkpos  bizshkTot
<br><br>
<span class=input>. collapse (max) `r(varlist)', by(a01)</span>
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
<span class=input>. * Merge with negative shock data</span>
<span class=input>. merge 1:1 a01 using "$pathout/negshocks.dta", gen(shock_merge)</span>
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>           2,976</span>
        from master          <span class=result>           2,976</span>  (shock_merge==1)
        from using           <span class=result>               0</span>  (shock_merge==2)
<br><br>
    matched                  <span class=result>           3,527</span>  (shock_merge==3)
    -----------------------------------------
<br><br>
<span class=input>. </span>
<span class=input>. * Merge collapsed data back with </span>
<span class=input>. * Merge in hh roster (just hhid) to compute zeros for missing households (are they missing at random?)</span>
<span class=input>. merge m:1 a01 using "$pathout\hhid.dta", gen(hhID_merge)</span>
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>               0</span>
    matched                  <span class=result>           6,503</span>  (hhID_merge==3)
    -----------------------------------------
<br><br>
<span class=input>. </span>
<span class=input>. </span>
<span class=input>. /* NOTE: Assuming that missing information is equivalent to zero; Validate for all vars */</span>
<span class=input>. * Note missingness in variables: Mostly related to asset losses</span>
<span class=input>. mdesc </span>
<br><br>
    Variable    |     Missing          Total     Percent Missing
----------------+-----------------------------------------------
            a01 | <span class=result>          0          6,503           0.00</span>
<span class=result>       </span>edshkpos | <span class=result>          0          6,503           0.00</span>
<span class=result>       </span>edshkTot | <span class=result>      5,102          6,503          78.46</span>
<span class=result>      </span>finshkpos | <span class=result>          0          6,503           0.00</span>
<span class=result>      </span>finshkTot | <span class=result>      6,271          6,503          96.43</span>
<span class=result>      </span>bizshkpos | <span class=result>          0          6,503           0.00</span>
<span class=result>      </span>bizshkTot | <span class=result>      6,288          6,503          96.69</span>
<span class=result>         </span>shkTot | <span class=result>      2,976          6,503          45.76</span>
<span class=result>     </span>shkLossTot | <span class=result>      2,976          6,503          45.76</span>
<span class=result>    </span>shkLossTotR | <span class=result>      4,361          6,503          67.06</span>
<span class=result>      </span>healthshk | <span class=result>      2,976          6,503          45.76</span>
<span class=result>     </span>healthshkR | <span class=result>      2,976          6,503          45.76</span>
<span class=result>   </span>healths~2007 | <span class=result>      2,976          6,503          45.76</span>
<span class=result>   </span>healths~2008 | <span class=result>      2,976          6,503          45.76</span>
<span class=result>   </span>healths~2009 | <span class=result>      2,976          6,503          45.76</span>
<span class=result>   </span>healths~2010 | <span class=result>      2,976          6,503          45.76</span>
<span class=result>   </span>healths~2011 | <span class=result>      2,976          6,503          45.76</span>
<span class=result>   </span>healthshkH~t | <span class=result>      2,976          6,503          45.76</span>
<span class=result>       </span>floodshk | <span class=result>      2,976          6,503          45.76</span>
<span class=result>      </span>floodshkR | <span class=result>      2,976          6,503          45.76</span>
<span class=result>   </span>floodshk2007 | <span class=result>      2,976          6,503          45.76</span>
<span class=result>          </span>agshk | <span class=result>      2,976          6,503          45.76</span>
<span class=result>         </span>agshkR | <span class=result>      2,976          6,503          45.76</span>
<span class=result>       </span>assetshk | <span class=result>      2,976          6,503          45.76</span>
<span class=result>      </span>assetshkR | <span class=result>      2,976          6,503          45.76</span>
<span class=result>         </span>finshk | <span class=result>      2,976          6,503          45.76</span>
<span class=result>        </span>finshkR | <span class=result>      2,976          6,503          45.76</span>
<span class=result>       </span>priceshk | <span class=result>      2,976          6,503          45.76</span>
<span class=result>      </span>priceshkR | <span class=result>      2,976          6,503          45.76</span>
<span class=result>       </span>othershk | <span class=result>      2,976          6,503          45.76</span>
<span class=result>      </span>othershkR | <span class=result>      2,976          6,503          45.76</span>
<span class=result>   </span>healthshkTot | <span class=result>      4,735          6,503          72.81</span>
<span class=result>   </span>healthshkR~t | <span class=result>      5,522          6,503          84.91</span>
<span class=result>    </span>floodshkTot | <span class=result>      6,131          6,503          94.28</span>
<span class=result>   </span>floodshkRTot | <span class=result>      6,356          6,503          97.74</span>
<span class=result>       </span>agshkTot | <span class=result>      5,826          6,503          89.59</span>
<span class=result>      </span>agshkRTot | <span class=result>      6,123          6,503          94.16</span>
<span class=result>    </span>assetshkTot | <span class=result>      6,012          6,503          92.45</span>
<span class=result>   </span>assetshkRTot | <span class=result>      6,407          6,503          98.52</span>
<span class=result>     </span>finshkRTot | <span class=result>      6,189          6,503          95.17</span>
<span class=result>    </span>priceshkTot | <span class=result>      6,049          6,503          93.02</span>
<span class=result>   </span>priceshkRTot | <span class=result>      6,072          6,503          93.37</span>
<span class=result>         </span>nocope | <span class=result>      2,976          6,503          45.76</span>
<span class=result>       </span>goodcope | <span class=result>      2,976          6,503          45.76</span>
<span class=result>        </span>badcope | <span class=result>      2,976          6,503          45.76</span>
<span class=result>    </span>loancopeNGO | <span class=result>      2,976          6,503          45.76</span>
<span class=result>   </span>loancopeMa~n | <span class=result>      2,976          6,503          45.76</span>
<span class=result>        </span>nocopeR | <span class=result>      2,976          6,503          45.76</span>
<span class=result>      </span>goodcopeR | <span class=result>      2,976          6,503          45.76</span>
<span class=result>       </span>badcopeR | <span class=result>      2,976          6,503          45.76</span>
<span class=result>   </span>loancopeNGOR | <span class=result>      2,976          6,503          45.76</span>
<span class=result>   </span>loancopeMa~R | <span class=result>      2,976          6,503          45.76</span>
<span class=result>    </span>shock_merge | <span class=result>          0          6,503           0.00</span>
<span class=result>     </span>hhID_merge | <span class=result>          0          6,503           0.00</span>
----------------+-----------------------------------------------
<br><br>
<span class=input>. </span>
<span class=input>. * Replace missing information with zeros noting potential introduction of bias here.</span>
<span class=input>. foreach x of varlist _all {</span>
  2<span class=input>.         replace `x' = 0 if `x' == .</span>
  3<span class=input>.         }</span>
(0 real changes made)
(0 real changes made)
(5102 real changes made)
(0 real changes made)
(6271 real changes made)
(0 real changes made)
(6288 real changes made)
(2976 real changes made)
(2976 real changes made)
(4361 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(4735 real changes made)
(5522 real changes made)
(6131 real changes made)
(6356 real changes made)
(5826 real changes made)
(6123 real changes made)
(6012 real changes made)
(6407 real changes made)
(6189 real changes made)
(6049 real changes made)
(6072 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(2976 real changes made)
(0 real changes made)
(0 real changes made)
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. * Add a note to dataset</span>
<span class=input>. notes: 2,976 were not included in shock module (unsure why). Setting to zero for now.</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Save</span>
<span class=input>. save "$pathout/shocks.dta", replace</span>
file U:\Bangladesh\Dataout/shocks.dta saved
<br><br>
</pre>
</body>
</html>
