
<html>
<head>
<meta http-equiv="Content-type" content="text/html; charset=iso-8859-1">
<meta http-equiv="Content-Style-Type" content="text/css">
<style type="text/css">
BODY{background-color: ffffff;
    font-family: monaco, "courier new", monospace;
     color: #000000}
.input {color: #CC6600}
.result{color: #000099}
.error{color: #dd0000}
</style>
</head>
<body>
<pre>
---------------------------------------------------------------------------------------------------------------------------------------------------------------
      name:  <span class=result>&lt;unnamed&gt;</span>
<span class=result>       </span>log:  <span class=result>U:\Bangladesh\Log/hhinfra.smcl</span>
<span class=result>  </span>log type:  <span class=result>smcl</span>
<span class=result> </span>opened on:  <span class=result>19 Nov 2014, 16:07:28</span>
<br><br>
<span class=input>. set more off</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Load module with information on household quality. */</span>
<span class=input>. use "$pathin/035_mod_q_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte ownHouse = inlist(q_01, 1)</span>
<br><br>
<span class=input>. la var ownHouse "HH owns dwelling"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g houseAge = .</span>
(6503 missing values generated)
<br><br>
<span class=input>. replace houseAge = 1 if inlist(q_04, 0, 1, 2, 3, 4, 5)</span>
(1240 real changes made)
<br><br>
<span class=input>. replace houseAge = 2 if inlist(q_04, 6, 7, 8, 9, 10)</span>
(1308 real changes made)
<br><br>
<span class=input>. replace houseAge = 3 if inlist(q_04, 11, 12, 13, 14, 15)</span>
(1036 real changes made)
<br><br>
<span class=input>. replace houseAge = 4 if q_04 &gt;15 &amp; q_04&lt;9999</span>
(2391 real changes made)
<br><br>
<span class=input>. replace houseAge = 5 if q_04 == 9999</span>
(528 real changes made)
<br><br>
<span class=input>. la var houseAge "Age of household"</span>
<br><br>
<span class=input>. lab def home 1 "0-5 years" 2 "6-10 years" 3 "11-15" /*</span>
<span class=input>&gt; */ 4 "15 +" 5 "unknown"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte newHome = houseAge ==1</span>
<br><br>
<span class=input>. la var newHome "House is less than 5 years old"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Dwelling quality</span>
<span class=input>. clonevar houseSize = q_12</span>
<br><br>
<span class=input>. clonevar houseQual = q_06</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte brickTinHome = inlist(q_07, 1, 2)</span>
<br><br>
<span class=input>. la var brickTinHome "Dwelling primarily brick or tin"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte mudHome = inlist(q_07, 4)</span>
<br><br>
<span class=input>. la var mudHome "Dwelling entirely made of mud"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte metalRoof = inlist(q_08, 1, 2)</span>
<br><br>
<span class=input>. la var metalRoof "Roof primarily of tin/contrete" </span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte dfloor = inlist(q_09, 4)</span>
<br><br>
<span class=input>. la var dfloor "Dirt floor"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte singleRoom = inlist(q_10, 1)</span>
<br><br>
<span class=input>. la var singleRoom "Dwelling is single room"</span>
<br><br>
<span class=input>. </span>
<span class=input>. clonevar electricity = q_13</span>
<br><br>
<span class=input>. recode electricity (2=0) </span>
(electricity: 3462 changes made)
<br><br>
<span class=input>. clonevar elecQual = q_14</span>
(3462 missing values generated)
<br><br>
<span class=input>. </span>
<span class=input>. * Cooking fuel source</span>
<span class=input>. g cookFuel = .</span>
(6503 missing values generated)
<br><br>
<span class=input>. replace cookFuel = 1 if inlist(q_16, 1)</span>
(120 real changes made)
<br><br>
<span class=input>. replace cookFuel = 2 if inlist(q_16, 2, 3, 4)</span>
(97 real changes made)
<br><br>
<span class=input>. replace cookFuel = 3 if inlist(q_16, 5, 8, 9)</span>
(4746 real changes made)
<br><br>
<span class=input>. replace cookFuel = 4 if inlist(q_16, 6)</span>
(1338 real changes made)
<br><br>
<span class=input>. replace cookFuel = 5 if inlist(q_16, 10, 7)</span>
(202 real changes made)
<br><br>
<span class=input>. la def fuel 1 "electric" 2 "gas" 3 "firewood/natural" 4 "dung" 5 "other"</span>
<br><br>
<span class=input>. la values cookFuel fuel</span>
<br><br>
<span class=input>. la var cookFuel "Fuel used for cooking"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Binary for electric fuel sources </span>
<span class=input>. g byte electFuel = q_16 == 1</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Lighting fuel</span>
<span class=input>. g byte lightFuel = inlist(q_18, 1, 2, 3)</span>
<br><br>
<span class=input>. la var lightFuel "HH uses electricity for lighting"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte mobile = q_20 &gt; 0</span>
<br><br>
<span class=input>. la var mobile "HH owns at least on mobile phone"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * keep relevant variables and save dataset for merging w/ other assets</span>
<span class=input>. #delimit ;</span>
delimiter now ;
<span class=input>.         keep a01 ownHouse houseAge newHome houseSize houseQual </span>
<span class=input>&gt;                 brickTinHome mudHome metalRoof dfloor singleRoom </span>
<span class=input>&gt;                 electricity elecQual cookFuel lightFuel mobile</span>
<span class=input>&gt;                 sample_type;</span>
<br><br>
<span class=input>. #delimit cr</span>
delimiter now cr
<span class=input>. </span>
<span class=input>. * Save house infrastructure data</span>
<span class=input>. save "$pathout/houseinfra.dta", replace</span>
file U:\Bangladesh\Dataout/houseinfra.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. **************</span>
<span class=input>. * Sanitation *</span>
<span class=input>. **************</span>
<span class=input>. use "$pathin/036_mod_r_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte latrineSealed = inlist(r01, 4, 5)</span>
<br><br>
<span class=input>. la var latrineSealed "Water sealed latrine"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte waterAccess = r02 == 1</span>
<br><br>
<span class=input>. la var waterAccess "HH has access to water supply"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte privateWater = inlist(r03, 1, 2, 3)</span>
<br><br>
<span class=input>. la var privateWater "Water source is private (tube well or piped)"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte publicWater = inlist(r03, 4, 5, 6, 7, 8)</span>
<br><br>
<span class=input>. la var publicWater "Water source is public or open (community tubewell)"</span>
<br><br>
<span class=input>. </span>
<span class=input>. g byte garbage = inlist(r10, 1, 2, 3 4)</span>
<br><br>
<span class=input>. la var garbage "Garbage pit or collection"</span>
<br><br>
<span class=input>. </span>
<span class=input>. keep latrineSealed waterAccess privateWater publicWater garbage a01</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Merge in household infrastructure and create factor analysis/PCA</span>
<span class=input>.  merge 1:1 a01 using "$pathout/houseinfra.dta"</span>
(label sample_type already defined)
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>               0</span>
    matched                  <span class=result>           6,503</span>  (_merge==3)
    -----------------------------------------
<br><br>
<span class=input>.  drop _merge</span>
<br><br>
<span class=input>.  save "$pathout/houseinfra.dta", replace</span>
file U:\Bangladesh\Dataout/houseinfra.dta saved
<br><br>
<span class=input>.  </span>
<span class=input>. **********************</span>
<span class=input>. * Community Services *</span>
<span class=input>. **********************</span>
<span class=input>. use "$pathin/037_mod_s_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. g distHealth = s_04 if inlist(s_01, 1)</span>
(84795 missing values generated)
<br><br>
<span class=input>. g distRoad = s_04 if inlist(s_01, 3)</span>
(84687 missing values generated)
<br><br>
<span class=input>. g distTown = s_04 if inlist(s_01, 7)</span>
(84815 missing values generated)
<br><br>
<span class=input>. g distMarket = s_04 if inlist(s_01, 6)</span>
(84631 missing values generated)
<br><br>
<span class=input>. </span>
<span class=input>. collapse (max) distHealth distRoad distTown distMarket, by(a01)</span>
<br><br>
<span class=input>. </span>
<span class=input>. la var distHealth "Distance to nearest health center"</span>
<br><br>
<span class=input>. la var distRoad "Distance to nearest road"</span>
<br><br>
<span class=input>. la var distTown "Distance to nearest town"</span>
<br><br>
<span class=input>. la var distMarket "Distance to nearest market"</span>
<br><br>
<span class=input>. </span>
<span class=input>. merge 1:1 a01 using "$pathout/houseinfra.dta"</span>
(label sample_type already defined)
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>               0</span>
    matched                  <span class=result>           6,503</span>  (_merge==3)
    -----------------------------------------
<br><br>
<span class=input>. drop _merge</span>
<br><br>
<span class=input>. </span>
<span class=input>.  </span>
<span class=input>. * Run factor analysis to develop infrastructure index for households</span>
<span class=input>. /* NOTES: Create Infrastructure indices </span>
<span class=input>&gt;  Keeping only first factor to simplify;</span>
<span class=input>&gt;  Use polychoric correlation matrix because of binary variables</span>
<span class=input>&gt;  http://www.ats.ucla.edu/stat/stata/faq/efa_categorical.htm</span>
<span class=input>&gt; */</span>
<span class=input>. </span>
<span class=input>. * Set global vector of variables to include in analysis</span>
<span class=input>. #delimit ;</span>
delimiter now ;
<span class=input>.         local infra brickTinHome dfloor distHealth distMarket distRoad </span>
<span class=input>&gt;         distTown electricity garbage newHome latrineSealed lightFuel </span>
<span class=input>&gt;         metalRoof mobile ownHouse privateWater singleRoom waterAccess</span>
<span class=input>&gt;          ;</span>
<br><br>
<span class=input>. #delimit cr</span>
delimiter now cr
<span class=input>. </span>
<span class=input>. * Standardize vector of data for use in PCA; Replace missing values with mean values</span>
<span class=input>. foreach x of local infra {</span>
  2<span class=input>.         egen mean`x' = mean(`x')</span>
  3<span class=input>.         replace `x' = mean`x' if `x' ==.</span>
  4<span class=input>.         *egen `x'_std = std(`x')</span>
<span class=input>.         drop mean`x'</span>
  5<span class=input>. }</span>
(0 real changes made)
(0 real changes made)
(256 real changes made)
(92 real changes made)
(148 real changes made)
(276 real changes made)
(0 real changes made)
(0 real changes made)
(0 real changes made)
(0 real changes made)
(0 real changes made)
(0 real changes made)
(0 real changes made)
(0 real changes made)
(0 real changes made)
(0 real changes made)
(0 real changes made)
<br><br>
<span class=input>. *</span>
<span class=input>. </span>
<span class=input>. *Now run factor analysis retaining only principal component factors</span>
<span class=input>. factor brickTinHome dfloor electricity garbage newHome /* </span>
<span class=input>&gt; */ latrineSealed lightFuel metalRoof mobile ownHouse /* </span>
<span class=input>&gt; */ privateWater singleRoom waterAccess, pcf</span>
(obs=6503)
<br><br>
Factor analysis/correlation                        Number of obs    = <span class=result>    6503</span>
<span class=result>    </span>Method: principal-component factors            Retained factors = <span class=result>       5</span>
<span class=result>    </span>Rotation: (unrotated)                          Number of params = <span class=result>      55</span>
<br><br>
    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |<span class=result>      2.78942      1.44285            0.2146       0.2146</span>
        Factor2  |<span class=result>      1.34657      0.17726            0.1036       0.3182</span>
        Factor3  |<span class=result>      1.16931      0.11820            0.0899       0.4081</span>
        Factor4  |<span class=result>      1.05111      0.02314            0.0809       0.4890</span>
        Factor5  |<span class=result>      1.02797      0.04740            0.0791       0.5680</span>
        Factor6  |<span class=result>      0.98057      0.01415            0.0754       0.6435</span>
        Factor7  |<span class=result>      0.96643      0.06278            0.0743       0.7178</span>
        Factor8  |<span class=result>      0.90364      0.10085            0.0695       0.7873</span>
        Factor9  |<span class=result>      0.80279      0.03836            0.0618       0.8491</span>
       Factor10  |<span class=result>      0.76444      0.12722            0.0588       0.9079</span>
       Factor11  |<span class=result>      0.63721      0.16972            0.0490       0.9569</span>
       Factor12  |<span class=result>      0.46749      0.37445            0.0360       0.9928</span>
       Factor13  |<span class=result>      0.09304            .            0.0072       1.0000</span>
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(<span class=result>78</span>) =<span class=result> 1.7e+04</span> Prob&gt;chi2 =<span class=result> 0.0000</span>
<br><br>
Factor loadings (pattern matrix) and unique variances
<br><br>
    -------------------------------------------------------------------------------
        Variable |  Factor1   Factor2   Factor3   Factor4   Factor5 |   Uniqueness 
    -------------+--------------------------------------------------+--------------
    brickTinHome | <span class=result>  0.4322</span>  <span class=result> -0.1652</span>  <span class=result>  0.5913</span>  <span class=result>  0.1876</span>  <span class=result>  0.0338</span> |  <span class=result>    0.4000</span>  
          dfloor | <span class=result> -0.4976</span>  <span class=result>  0.0136</span>  <span class=result> -0.3653</span>  <span class=result>  0.3985</span>  <span class=result> -0.1179</span> |  <span class=result>    0.4461</span>  
     electricity | <span class=result>  0.7684</span>  <span class=result> -0.4537</span>  <span class=result> -0.3419</span>  <span class=result>  0.0115</span>  <span class=result>  0.0576</span> |  <span class=result>    0.0834</span>  
         garbage | <span class=result>  0.0114</span>  <span class=result>  0.0206</span>  <span class=result> -0.0052</span>  <span class=result>  0.2463</span>  <span class=result>  0.7192</span> |  <span class=result>    0.4215</span>  
         newHome | <span class=result> -0.1692</span>  <span class=result> -0.1429</span>  <span class=result>  0.3857</span>  <span class=result> -0.2240</span>  <span class=result> -0.0462</span> |  <span class=result>    0.7498</span>  
    latrineSea~d | <span class=result>  0.4039</span>  <span class=result>  0.1031</span>  <span class=result>  0.2406</span>  <span class=result> -0.4775</span>  <span class=result> -0.0872</span> |  <span class=result>    0.5328</span>  
       lightFuel | <span class=result>  0.7903</span>  <span class=result> -0.4545</span>  <span class=result> -0.2980</span>  <span class=result>  0.0206</span>  <span class=result>  0.0467</span> |  <span class=result>    0.0775</span>  
       metalRoof | <span class=result>  0.2868</span>  <span class=result> -0.0284</span>  <span class=result>  0.4975</span>  <span class=result>  0.5561</span>  <span class=result>  0.0285</span> |  <span class=result>    0.3593</span>  
          mobile | <span class=result>  0.5051</span>  <span class=result>  0.0013</span>  <span class=result>  0.0104</span>  <span class=result>  0.0315</span>  <span class=result> -0.2687</span> |  <span class=result>    0.6715</span>  
        ownHouse | <span class=result>  0.2135</span>  <span class=result>  0.2469</span>  <span class=result> -0.0853</span>  <span class=result>  0.4377</span>  <span class=result> -0.2896</span> |  <span class=result>    0.6108</span>  
    privateWater | <span class=result>  0.5178</span>  <span class=result>  0.6351</span>  <span class=result> -0.0806</span>  <span class=result> -0.0329</span>  <span class=result>  0.1392</span> |  <span class=result>    0.3016</span>  
      singleRoom | <span class=result> -0.2516</span>  <span class=result> -0.2169</span>  <span class=result>  0.0252</span>  <span class=result> -0.1010</span>  <span class=result>  0.5035</span> |  <span class=result>    0.6252</span>  
     waterAccess | <span class=result>  0.4835</span>  <span class=result>  0.6025</span>  <span class=result> -0.1089</span>  <span class=result> -0.0682</span>  <span class=result>  0.2250</span> |  <span class=result>    0.3361</span>  
    -------------------------------------------------------------------------------
<br><br>
<span class=input>. rotate  </span>
<br><br>
Factor analysis/correlation                        Number of obs    = <span class=result>    6503</span>
<span class=result>    </span>Method: principal-component factors            Retained factors = <span class=result>       5</span>
<span class=result>    </span>Rotation: orthogonal varimax (Kaiser off)      Number of params = <span class=result>      55</span>
<br><br>
    --------------------------------------------------------------------------
         Factor  |     Variance   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |<span class=result>      2.12478      0.43905            0.1634       0.1634</span>
        Factor2  |<span class=result>      1.68573      0.39383            0.1297       0.2931</span>
        Factor3  |<span class=result>      1.29190      0.08493            0.0994       0.3925</span>
        Factor4  |<span class=result>      1.20696      0.13195            0.0928       0.4853</span>
        Factor5  |<span class=result>      1.07501            .            0.0827       0.5680</span>
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(<span class=result>78</span>) =<span class=result> 1.7e+04</span> Prob&gt;chi2 =<span class=result> 0.0000</span>
<br><br>
Rotated factor loadings (pattern matrix) and unique variances
<br><br>
    -------------------------------------------------------------------------------
        Variable |  Factor1   Factor2   Factor3   Factor4   Factor5 |   Uniqueness 
    -------------+--------------------------------------------------+--------------
    brickTinHome | <span class=result>  0.1803</span>  <span class=result> -0.0067</span>  <span class=result>  0.6852</span>  <span class=result>  0.3129</span>  <span class=result>  0.0073</span> |  <span class=result>    0.4000</span>  
          dfloor | <span class=result> -0.2276</span>  <span class=result> -0.2060</span>  <span class=result> -0.1716</span>  <span class=result> -0.6559</span>  <span class=result> -0.0034</span> |  <span class=result>    0.4461</span>  
     electricity | <span class=result>  0.9535</span>  <span class=result>  0.0653</span>  <span class=result>  0.0342</span>  <span class=result>  0.0449</span>  <span class=result> -0.0002</span> |  <span class=result>    0.0834</span>  
         garbage | <span class=result>  0.0374</span>  <span class=result>  0.1604</span>  <span class=result>  0.1390</span>  <span class=result> -0.1186</span>  <span class=result>  0.7197</span> |  <span class=result>    0.4215</span>  
         newHome | <span class=result> -0.2136</span>  <span class=result> -0.2682</span>  <span class=result>  0.0899</span>  <span class=result>  0.3522</span>  <span class=result> -0.0209</span> |  <span class=result>    0.7498</span>  
    latrineSea~d | <span class=result>  0.1350</span>  <span class=result>  0.2366</span>  <span class=result>  0.0009</span>  <span class=result>  0.5924</span>  <span class=result> -0.2053</span> |  <span class=result>    0.5328</span>  
       lightFuel | <span class=result>  0.9525</span>  <span class=result>  0.0668</span>  <span class=result>  0.0785</span>  <span class=result>  0.0669</span>  <span class=result> -0.0132</span> |  <span class=result>    0.0775</span>  
       metalRoof | <span class=result>  0.0467</span>  <span class=result>  0.0457</span>  <span class=result>  0.7931</span>  <span class=result> -0.0757</span>  <span class=result>  0.0407</span> |  <span class=result>    0.3593</span>  
          mobile | <span class=result>  0.3623</span>  <span class=result>  0.1981</span>  <span class=result>  0.1942</span>  <span class=result>  0.0845</span>  <span class=result> -0.3364</span> |  <span class=result>    0.6715</span>  
        ownHouse | <span class=result>  0.0630</span>  <span class=result>  0.2657</span>  <span class=result>  0.2714</span>  <span class=result> -0.3834</span>  <span class=result> -0.3066</span> |  <span class=result>    0.6108</span>  
    privateWater | <span class=result>  0.0900</span>  <span class=result>  0.8252</span>  <span class=result>  0.0519</span>  <span class=result>  0.0759</span>  <span class=result> -0.0312</span> |  <span class=result>    0.3016</span>  
      singleRoom | <span class=result> -0.0649</span>  <span class=result> -0.2118</span>  <span class=result> -0.1229</span>  <span class=result>  0.0979</span>  <span class=result>  0.5486</span> |  <span class=result>    0.6252</span>  
     waterAccess | <span class=result>  0.0957</span>  <span class=result>  0.8020</span>  <span class=result> -0.0010</span>  <span class=result>  0.0904</span>  <span class=result>  0.0586</span> |  <span class=result>    0.3361</span>  
    -------------------------------------------------------------------------------
<br><br>
Factor rotation matrix
<br><br>
    -----------------------------------------------------------
                 | Factor1  Factor2  Factor3  Factor4  Factor5 
    -------------+---------------------------------------------
         Factor1 | <span class=result> 0.7481</span>  <span class=result> 0.4960</span>  <span class=result> 0.3217</span>  <span class=result> 0.2599</span>  <span class=result>-0.1529</span> 
         Factor2 | <span class=result>-0.5270</span>  <span class=result> 0.8333</span>  <span class=result>-0.0541</span>  <span class=result>-0.0847</span>  <span class=result>-0.1332</span> 
         Factor3 | <span class=result>-0.4001</span>  <span class=result>-0.1500</span>  <span class=result> 0.7126</span>  <span class=result> 0.5565</span>  <span class=result> 0.0011</span> 
         Factor4 | <span class=result> 0.0269</span>  <span class=result>-0.0067</span>  <span class=result> 0.6209</span>  <span class=result>-0.7777</span>  <span class=result> 0.0944</span> 
         Factor5 | <span class=result> 0.0432</span>  <span class=result> 0.1925</span>  <span class=result>-0.0178</span>  <span class=result> 0.1038</span>  <span class=result> 0.9747</span> 
    -----------------------------------------------------------
<br><br>
<span class=input>. predict infraindex</span>
(regression scoring assumed)
<br><br>
Scoring coefficients (method = regression; based on varimax rotated factors)
<br><br>
    ----------------------------------------------------------------
        Variable |  Factor1   Factor2   Factor3   Factor4   Factor5 
    -------------+--------------------------------------------------
    brickTinHome | <span class=result>-0.01553</span>  <span class=result>-0.09610</span>  <span class=result> 0.52705</span>  <span class=result> 0.19664</span>  <span class=result> 0.04214</span> 
          dfloor | <span class=result>-0.00855</span>  <span class=result>-0.05782</span>  <span class=result>-0.04310</span>  <span class=result>-0.52779</span>  <span class=result>-0.05040</span> 
     electricity | <span class=result> 0.50333</span>  <span class=result>-0.08958</span>  <span class=result>-0.09571</span>  <span class=result>-0.06522</span>  <span class=result> 0.05806</span> 
         garbage | <span class=result> 0.03327</span>  <span class=result> 0.14854</span>  <span class=result> 0.13038</span>  <span class=result>-0.11231</span>  <span class=result> 0.70133</span> 
         newHome | <span class=result>-0.12909</span>  <span class=result>-0.17521</span>  <span class=result> 0.08977</span>  <span class=result> 0.33790</span>  <span class=result>-0.04018</span> 
    latrineSea~d | <span class=result>-0.03020</span>  <span class=result> 0.09146</span>  <span class=result>-0.09147</span>  <span class=result> 0.49009</span>  <span class=result>-0.15768</span> 
       lightFuel | <span class=result> 0.49426</span>  <span class=result>-0.09393</span>  <span class=result>-0.06083</span>  <span class=result>-0.05007</span>  <span class=result> 0.04744</span> 
       metalRoof | <span class=result>-0.06679</span>  <span class=result>-0.02860</span>  <span class=result> 0.66541</span>  <span class=result>-0.14328</span>  <span class=result> 0.06450</span> 
          mobile | <span class=result> 0.12092</span>  <span class=result> 0.03875</span>  <span class=result> 0.08780</span>  <span class=result> 0.00147</span>  <span class=result>-0.27979</span> 
        ownHouse | <span class=result>-0.01117</span>  <span class=result> 0.14467</span>  <span class=result> 0.22626</span>  <span class=result>-0.38932</span>  <span class=result>-0.27152</span> 
    privateWater | <span class=result>-0.07714</span>  <span class=result> 0.52172</span>  <span class=result>-0.03673</span>  <span class=result> 0.00830</span>  <span class=result> 0.03780</span> 
      singleRoom | <span class=result> 0.02739</span>  <span class=result>-0.08730</span>  <span class=result>-0.07335</span>  <span class=result> 0.12784</span>  <span class=result> 0.50363</span> 
     waterAccess | <span class=result>-0.06114</span>  <span class=result> 0.51535</span>  <span class=result>-0.07903</span>  <span class=result> 0.02848</span>  <span class=result> 0.12102</span> 
    ----------------------------------------------------------------
<br><br>
<br><br>
<span class=input>. la var infraindex "infrastructure index"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Plot loadings for review</span>
<span class=input>. loadingplot, mlabs(small) mlabc(maroon) mc(maroon) /*</span>
<span class=input>&gt;         */ xline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*</span>
<span class=input>&gt;         */ yline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*</span>
<span class=input>&gt;         */ title(Household infrastructure index loadings)</span>
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
<br><br>
<span class=input>. graph export "$pathgraph/infraLoadings.png", as(png) replace</span>
(file U:\Bangladesh\Graph/infraLoadings.png written in PNG format)
<br><br>
<span class=input>. scree, title(Scree plot of infra index)</span>
<br><br>
<span class=input>. graph export "$pathgragh/infraScree.png", as(png) replace</span>
(file /infraScree.png written in PNG format)
<br><br>
<span class=input>.         </span>
<span class=input>. *Now run factor analysis retaining only principal component factors</span>
<span class=input>. factor distHealth distMarket distRoad distTown, pcf     </span>
(obs=6503)
<br><br>
Factor analysis/correlation                        Number of obs    = <span class=result>    6503</span>
<span class=result>    </span>Method: principal-component factors            Retained factors = <span class=result>       1</span>
<span class=result>    </span>Rotation: (unrotated)                          Number of params = <span class=result>       4</span>
<br><br>
    --------------------------------------------------------------------------
         Factor  |   Eigenvalue   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |<span class=result>      1.53789      0.56161            0.3845       0.3845</span>
        Factor2  |<span class=result>      0.97629      0.20735            0.2441       0.6285</span>
        Factor3  |<span class=result>      0.76893      0.05205            0.1922       0.8208</span>
        Factor4  |<span class=result>      0.71689            .            0.1792       1.0000</span>
    --------------------------------------------------------------------------
    LR test: independent vs. saturated:  chi2(<span class=result>6</span>)  =<span class=result> 1229.78</span> Prob&gt;chi2 =<span class=result> 0.0000</span>
<br><br>
Factor loadings (pattern matrix) and unique variances
<br><br>
    ---------------------------------------
        Variable |  Factor1 |   Uniqueness 
    -------------+----------+--------------
      distHealth | <span class=result>  0.7272</span> |  <span class=result>    0.4712</span>  
      distMarket | <span class=result>  0.3154</span> |  <span class=result>    0.9005</span>  
        distRoad | <span class=result>  0.6762</span> |  <span class=result>    0.5427</span>  
        distTown | <span class=result>  0.6725</span> |  <span class=result>    0.5477</span>  
    ---------------------------------------
<br><br>
<span class=input>. predict accessindex</span>
(regression scoring assumed)
<br><br>
Scoring coefficients (method = regression)
<br><br>
    ------------------------
        Variable |  Factor1 
    -------------+----------
      distHealth | <span class=result> 0.47285</span> 
      distMarket | <span class=result> 0.20509</span> 
        distRoad | <span class=result> 0.43971</span> 
        distTown | <span class=result> 0.43732</span> 
    ------------------------
<br><br>
<br><br>
<span class=input>. la var infraindex "accessiblity index"</span>
<br><br>
<span class=input>.         </span>
<span class=input>. *loadingplot, mlabs(small) mlabc(maroon) mc(maroon) /*</span>
<span class=input>&gt; *       */ xline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*</span>
<span class=input>&gt; *       */ yline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*</span>
<span class=input>&gt; *       */ title(Household Accessibility Index Loadings)</span>
<span class=input>. *graph export "$pathgraph\assessabilityLoadings.png", as(png) replace</span>
<span class=input>. * Only one factor retained so there is no two-way graph.        </span>
<span class=input>. scree, title(Scree plot of assessibility index)</span>
<br><br>
<span class=input>. graph export "$pathgragh/infraScree.png", as(png) replace</span>
(file /infraScree.png written in PNG format)
<br><br>
<span class=input>. </span>
<span class=input>. * Save the hhinfra dataset</span>
<span class=input>. save "$pathout/hhinfra.dta", replace</span>
file U:\Bangladesh\Dataout/hhinfra.dta saved
<br><br>
</pre>
</body>
</html>
