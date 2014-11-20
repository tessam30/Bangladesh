
<html>
<body>
<pre>
--------------------------------------------------------------------------------------------------------------------------------------------------
      name:  <span class=result>&lt;unnamed&gt;</span>
<span class=result>       </span>log:  <span class=result>U:\Bangladesh\Log/01_hhchar.smcl</span>
<span class=result>  </span>log type:  <span class=result>smcl</span>
<span class=result> </span>opened on:  <span class=result>20 Nov 2014, 09:46:40</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Load household survey module of all individuals. Collapse down for hh totals.</span>
<span class=input>. use "$pathin\003_mod_b1_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Demographic list to calculate</span>
<span class=input>&gt; 1. household size</span>
<span class=input>&gt; 2. dependency ratio</span>
<span class=input>&gt; 3. hoh education</span>
<span class=input>&gt; 4. male hoh education</span>
<span class=input>&gt; 5. wife education</span>
<span class=input>&gt; 6. Gender ratio</span>
<span class=input>&gt; 7. Principal occupation of hoh</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. * Create head of household variable based on primary respondent and sex</span>
<span class=input>. g byte hoh = b1_03 == 1</span>
<br><br>
<span class=input>. la var hoh "Head of household"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte femhead = b1_01 == 2 &amp; b1_03 == 1</span>
<br><br>
<span class=input>. la var femhead "Female head of household"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g agehead = b1_02 if hoh == 1</span>
(20782 missing values generated)
<br><br>
<span class=input>. la var agehead "Age of head of household"</span>
<br><br>
<span class=input>. g ageheadsq = agehead^2</span>
(20782 missing values generated)
<br><br>
<span class=input>. la var ageheadsq "Squared age of the head (for non-linear effects)"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Relationship status</span>
<span class=input>. g byte marriedHead = b1_04 == 2 &amp; hoh==1</span>
<br><br>
<span class=input>. la var marriedHead "married HoH"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte widowHead = (b1_04 == 3 &amp; hoh==1)</span>
<br><br>
<span class=input>. la var widowHead "widowed HoH"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte widowFemhead = (b1_04 == 3 &amp; femhead)</span>
<br><br>
<span class=input>. la var widowFemhead "Widowed Female head of household"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte singleHead = (marriedHead==0 &amp; hoh==1)</span>
<br><br>
<span class=input>. la var singleHead "single HoH"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Create a migration network variable</span>
<span class=input>. g byte migration = b1_05 == 1</span>
<br><br>
<span class=input>. la var migration "Household has access to migration networks"</span>
<br><br>
<span class=input>. g byte migrationHoh = b1_05 == 1 &amp; hoh == 1</span>
<br><br>
<span class=input>. la var migrationHoh "Hoh has migrated in last 6 months"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Create household size variables</span>
<span class=input>. bysort a01: gen hhSize = _N </span>
<br><br>
<span class=input>. la var hhSize "Household size"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Create sex ratio for households</span>
<span class=input>. g byte male = b1_01 == 1</span>
<br><br>
<span class=input>. g byte female = b1_01 == 2</span>
<br><br>
<span class=input>. la var male "male hh members"</span>
<br><br>
<span class=input>. la var female "female hh members"</span>
<br><br>
<span class=input>. </span>
<span class=input>. egen msize = total(male), by(a01)</span>
<br><br>
<span class=input>. la var msize "number of males in hh"</span>
<br><br>
<span class=input>. </span>
<span class=input>. egen fsize = total(female), by(a01)</span>
<br><br>
<span class=input>. la var fsize "number of females in hh"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g sexRatio = msize/fsize</span>
(5 missing values generated)
<br><br>
<span class=input>. recode sexRatio (. = 0) if fsize==0</span>
(sexRatio: 5 changes made)
<br><br>
<span class=input>. la var sexRatio "Number of males divided by females in HH"</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Create intl. HH dependency ratio (age ranges appropriate for Bangladesh)</span>
<span class=input>&gt; # HH Dependecy Ratio = [(# people 0-14 + those 65+) / # people aged 15-64 ] * 100 # </span>
<span class=input>&gt; The dependency ratio is defined as the ratio of the number of members in the age groups </span>
<span class=input>&gt; of 014 years and above 60 years to the number of members of working age (1560 years). </span>
<span class=input>&gt; The ratio is normally expressed as a percentage (data below are multiplied by 100 for pcts.*/</span>
<span class=input>. g byte numDepRatio = (b1_02&lt;15 | b1_02&gt;60) </span>
<br><br>
<span class=input>. g byte demonDepRatio = numDepRatio!=1 </span>
<br><br>
<span class=input>. egen totNumDepRatio = total(numDepRatio), by(a01)</span>
<br><br>
<span class=input>. egen totDenomDepRatio = total(demonDepRatio), by(a01)</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Check that numbers add to hhsize</span>
<span class=input>. assert hhSize == totNumDepRatio+totDenomDepRatio</span>
<br><br>
<span class=input>. g depRatio = (totNumDepRatio/totDenomDepRatio)*100 if totDenomDepRatio!=.</span>
(203 missing values generated)
<br><br>
<span class=input>. recode depRatio (. = 0) if totDenomDepRatio==0</span>
(depRatio: 203 changes made)
<br><br>
<span class=input>. la var depRatio "Dependency Ratio"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Drop extra information</span>
<span class=input>. drop numDepRatio demonDepRatio totNumDepRatio totDenomDepRatio</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Household Labor Shares */</span>
<span class=input>. g byte hhLabort = (b1_02&gt;= 15 &amp; b1_02&lt;60)</span>
<br><br>
<span class=input>. egen hhlabor = total(hhLabort), by(a01)</span>
<br><br>
<span class=input>. la var hhlabor "hh labor age&gt;11 &amp; &lt; 60"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte mlabort = (b1_02&gt;= 15 &amp; b1_02&lt;60 &amp; b1_01 == 1)</span>
<br><br>
<span class=input>. egen mlabor = total(mlabort), by(a01)</span>
<br><br>
<span class=input>. la var mlabor "hh male labor age&gt;11 &amp; &lt;60"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte flabort = (b1_02&gt;= 15 &amp; b1_02&lt;60 &amp; b1_01 == 2)</span>
<br><br>
<span class=input>. egen flabor = total(flabort), by(a01)</span>
<br><br>
<span class=input>. la var flabor "hh female labor age&gt;11 &amp; &lt;60"</span>
<br><br>
<span class=input>. drop hhLabort mlabort flabort</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Male/Female labor share in hh</span>
<span class=input>. g mlaborShare = mlabor/hhlabor</span>
(353 missing values generated)
<br><br>
<span class=input>. recode mlaborShare (. = 0) if hhlabor == 0</span>
(mlaborShare: 353 changes made)
<br><br>
<span class=input>. la var mlaborShare "share of working age males in hh"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g flaborShare = flabor/hhlabor</span>
(353 missing values generated)
<br><br>
<span class=input>. recode flaborShare (. = 0) if hhlabor == 0</span>
(flaborShare: 353 changes made)
<br><br>
<span class=input>. la var flaborShare "share of working age females in hh"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Number of hh members under 15</span>
<span class=input>. g byte under15t = b1_02&lt;15</span>
<br><br>
<span class=input>. egen under15 = total(under15t), by(a01)</span>
<br><br>
<span class=input>. la var under15 "number of hh members under 15"</span>
<br><br>
<span class=input>. egen under15male = total(under15t) if male==1, by(a01)</span>
(14292 missing values generated)
<br><br>
<span class=input>. la var under15male "number of hh male members under 15"</span>
<br><br>
<span class=input>. recode under15male (. = 0) if under15male==.</span>
(under15male: 14292 changes made)
<br><br>
<span class=input>. </span>
<span class=input>. * Number of hh members under 24</span>
<span class=input>. g byte under24t = b1_02&lt;24</span>
<br><br>
<span class=input>. egen under24 = total(under24t), by(a01)</span>
<br><br>
<span class=input>. egen under24male = total(under24t) if male==1, by(a01)</span>
(14292 missing values generated)
<br><br>
<span class=input>. recode under24male (. = 0) if under24male==.</span>
(under24male: 14292 changes made)
<br><br>
<span class=input>. la var under24 "number of hh members under 24"</span>
<br><br>
<span class=input>. la var under24male "number of hh male members under 24"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * HH share of members under 15/24</span>
<span class=input>. g under15Share = under15/hhSize</span>
<br><br>
<span class=input>. la var under15Share "share of hh members under 15"</span>
<br><br>
<span class=input>. g under24Share = under24/hhSize</span>
<br><br>
<span class=input>. la var under24Share "share of hh members under 24"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * drop temp variables</span>
<span class=input>. drop under15t under24t</span>
<br><br>
<span class=input>. </span>
<span class=input>. **********************</span>
<span class=input>. * Education outcomes *</span>
<span class=input>. **********************</span>
<span class=input>. </span>
<span class=input>. * head of household literate</span>
<span class=input>. g byte literateHead = (b1_07 == 4 &amp; hoh == 1)</span>
<br><br>
<span class=input>. la var literateHead "HoH is literate"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * wife of hoh is literate</span>
<span class=input>. g byte spouseLit = (b1_04 == 2 &amp; b1_03 == 2 &amp; b1_07 ==4) </span>
<br><br>
<span class=input>. la var spouseLit "Spouse is literate"</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Education for individuals: </span>
<span class=input>&gt; http://en.wikipedia.org/wiki/Education_in_Bangladesh#mediaviewer/File:BangEduSys.png</span>
<span class=input>&gt; No education (0 years)</span>
<span class=input>&gt; PRe-primary (less than 1)</span>
<span class=input>&gt; Primary Level (years 1 to 4)</span>
<span class=input>&gt; Junior Level (years 5 to 8)</span>
<span class=input>&gt; Secondary Level (years 9 to 10)</span>
<span class=input>&gt; Higher Secondary Level (years 11 and 12)</span>
<span class=input>&gt; Tertiary Level (all above Secondary)</span>
<span class=input>&gt; Other</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. * No education listed (codebook pag 2 Module B)</span>
<span class=input>. g educ = .</span>
(27285 missing values generated)
<br><br>
<span class=input>. la var educ "Education levels"</span>
<br><br>
<span class=input>. * No education</span>
<span class=input>. replace educ = 0 if inlist(b1_08, 99)</span>
(11276 real changes made)
<br><br>
<span class=input>. * Pre-primary</span>
<span class=input>. replace educ = 1 if inlist(b1_08, 0, 66, 67)</span>
(1512 real changes made)
<br><br>
<span class=input>. * Primary</span>
<span class=input>. replace educ = 2 if inlist(b1_08, 1, 2, 3, 4, 5)</span>
(7956 real changes made)
<br><br>
<span class=input>. * Junior </span>
<span class=input>. replace educ = 3 if inlist(b1_08, 6, 7, 8)</span>
(3359 real changes made)
<br><br>
<span class=input>. * Secondary </span>
<span class=input>. replace educ = 4 if inlist(b1_08, 9, 10, 12, 33, 75, 11)</span>
(2784 real changes made)
<br><br>
<span class=input>. * Tertiary</span>
<span class=input>. replace educ = 5 if inlist(b1_08, 14, 15, 16, 22, 71, 72, 73, 74)</span>
(379 real changes made)
<br><br>
<span class=input>. * Other</span>
<span class=input>. replace educ = 6 if inlist(b1_08, 76)</span>
(19 real changes made)
<br><br>
<span class=input>. </span>
<span class=input>. * Create variable reflect the max education in the household for those 25+</span>
<span class=input>. egen educAdult = max(educ) if b1_02&gt;24, by(a01)</span>
(14215 missing values generated)
<br><br>
<span class=input>. </span>
<span class=input>. g educHoh = educ if hoh==1</span>
(20782 missing values generated)
<br><br>
<span class=input>. la var educAdult "Highest adult education in household"</span>
<br><br>
<span class=input>. la var educHoh "Education of Hoh"</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Main occupation of household head</span>
<span class=input>&gt; 1. Ag day laborer</span>
<span class=input>&gt; 2. Non-ag day laborer</span>
<span class=input>&gt; 3. Salaried</span>
<span class=input>&gt; 4. Self-employed</span>
<span class=input>&gt; 5. Rickshaw/van puller</span>
<span class=input>&gt; 6. Business/trade</span>
<span class=input>&gt; 7. Production business</span>
<span class=input>&gt; 8. Farming</span>
<span class=input>&gt; 9. Non-earning occupation</span>
<span class=input>&gt; */</span>
<span class=input>. g occupation = .</span>
(27285 missing values generated)
<br><br>
<span class=input>. la var occupation "Main occupation of hoh"</span>
<br><br>
<span class=input>. * Ag day</span>
<span class=input>. replace occupation = 1 if inlist(b1_10, 1) &amp; hoh == 1</span>
(776 real changes made)
<br><br>
<span class=input>. * Non-ag</span>
<span class=input>. replace occupation = 2 if inlist(b1_10, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11 ) &amp; hoh == 1</span>
(375 real changes made)
<br><br>
<span class=input>. * Salaried</span>
<span class=input>. replace occupation = 3 if inlist(b1_10, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21) &amp; hoh == 1</span>
(275 real changes made)
<br><br>
<span class=input>. * Self-employed</span>
<span class=input>. replace occupation = 4 if inlist(b1_10, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,  /*</span>
<span class=input>&gt; */ 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 72) &amp; hoh == 1</span>
(632 real changes made)
<br><br>
<span class=input>. * Rickshaw</span>
<span class=input>. replace occupation = 5 if inlist(b1_10, 22) &amp; hoh == 1</span>
(274 real changes made)
<br><br>
<span class=input>. * Trade</span>
<span class=input>. replace occupation = 6 if inlist(b1_10, 50, 51, 52, 53, 54) &amp; hoh == 1</span>
(709 real changes made)
<br><br>
<span class=input>. * Production</span>
<span class=input>. replace occupation = 7 if inlist(b1_10, 55, 56, 57) &amp; hoh == 1</span>
(48 real changes made)
<br><br>
<span class=input>. * Farming</span>
<span class=input>. replace occupation = 8 if inlist(b1_10, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71) &amp; hoh == 1</span>
(2612 real changes made)
<br><br>
<span class=input>. * Non-earning</span>
<span class=input>. replace occupation = 9 if inlist(b1_10, 81, 82, 83, 84, 85, 86) &amp; hoh == 1</span>
(801 real changes made)
<br><br>
<span class=input>. </span>
<span class=input>. * Collapse everything down to HH-level using max values for all vars</span>
<span class=input>. * Copy variable labels to reapply after collapse</span>
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
<span class=input>. </span>
<span class=input>. #delimit ;</span>
delimiter now ;
<span class=input>.         collapse (max) hoh femhead agehead ageheadsq marriedHead widowHead </span>
<span class=input>&gt;                 singleHead hhSize msize fsize sexRatio depRatio </span>
<span class=input>&gt;                 hhlabor mlabor flabor mlaborShare flaborShare under15 </span>
<span class=input>&gt;                 under15male under24 under24male under15Share under24Share </span>
<span class=input>&gt;                 literateHead spouseLit educ educAdult educHoh occupation</span>
<span class=input>&gt;                 widowFemhead</span>
<span class=input>&gt;                 sample_type, by(a01) fast;</span>
<br><br>
<span class=input>. #delimit cr</span>
delimiter now cr
<span class=input>. order a01</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Reapply variable lables &amp; value labels</span>
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
<span class=input>. * Create value labels for edu</span>
<span class=input>. la def ed 0 "No Education" 1 "Pre-primary" 2 "Primary" /*</span>
<span class=input>&gt;         */ 3 "Junior Secondary" 4 "Secondary" 5 "Tertiary" 6 "Other"</span>
<br><br>
<span class=input>. foreach x of varlist educ educAdult educHoh {</span>
  2<span class=input>.         label values `x' ed</span>
  3<span class=input>.         }</span>
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. la def occ 1 "Ag-day laborer" 2 "Non-ag day laborer" /*</span>
<span class=input>&gt;         */ 3 "Salaried" 4 "Self-employed" 5 "Rickshaw/van puller" /*</span>
<span class=input>&gt;         */ 6 "Business or trade" 7 "Production business" 8 "Farming" /*</span>
<span class=input>&gt;         */ 9 "Non-earning occupation"</span>
<br><br>
<span class=input>. la values occupation occ</span>
<br><br>
<span class=input>. * </span>
<span class=input>. la def sample 1 "ftf original" 2 "ftf additional" /*</span>
<span class=input>&gt;         */ 3 "national representative" </span>
<br><br>
<span class=input>. la values sample_type sample</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Add notes to variables if needed</span>
<span class=input>. notes educAdult: missing values indicate that no member of household was over 25</span>
<br><br>
<span class=input>. compress</span>
<span class=result>  </span>agehead was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ageheadsq was <span class=result>float</span> now <span class=result>int</span>
<span class=result>  </span>hhSize was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>msize was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>fsize was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>hhlabor was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>mlabor was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>flabor was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>under15 was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>under15male was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>under24 was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>under24male was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>educ was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>educAdult was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>educHoh was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>occupation was <span class=result>float</span> now <span class=result>byte</span>
  (305,641 bytes saved)
<br><br>
<span class=input>. </span>
<span class=input>. * Save</span>
<span class=input>. save "$pathout/hhchar.dta", replace</span>
file U:\Bangladesh\Dataout/hhchar.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. * Keep a master file of only household id's for missing var checks</span>
<span class=input>. keep a01</span>
<br><br>
<span class=input>. save "$pathout\hhid.dta", replace</span>
file U:\Bangladesh\Dataout\hhid.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. </span>
<span class=input>. * Create an html file of the log for internet sharability</span>
</pre>
</body>
</html>
