
<html>
<body>
<pre>
--------------------------------------------------------------------------------------------------------------------------------------------------
      name:  <span class=result>&lt;unnamed&gt;</span>
<span class=result>       </span>log:  <span class=result>U:\Bangladesh\Log/03_hhpc.smcl</span>
<span class=result>  </span>log type:  <span class=result>smcl</span>
<span class=result> </span>opened on:  <span class=result>20 Nov 2014, 10:00:38</span>
<br><br>
<span class=input>. set more off</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Load module with information on household assets. */</span>
<span class=input>. use "$pathin/006_mod_d1_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Create variables reflecting ownership of different durable assets</span>
<span class=input>. /* Automate the process a bit to make processing easier*/</span>
<span class=input>. </span>
<span class=input>. * create vector of assets for which binary variables are created</span>
<span class=input>. #delimit ;</span>
delimiter now ;
<span class=input>. local assets trunk bucket stove cookpots bed cabinet </span>
<span class=input>&gt;         tableChairs hukka fan iron radio cd clock tvbw tvclr</span>
<span class=input>&gt;         gold sew bike rickshaw van boat elecboat moto </span>
<span class=input>&gt;         mobile landphone thresher mill randa saw hammer patkoa</span>
<span class=input>&gt;         fishnet spade axe shovel shabol daa horse mule</span>
<span class=input>&gt;         donkey;</span>
<br><br>
<span class=input>. #delimit cr</span>
delimiter now cr
<span class=input>. </span>
<span class=input>. * Loop over each asset in order, verifying code using output (p. 7, Module D)</span>
<span class=input>. local count = 1</span>
<br><br>
<span class=input>. foreach x of local assets {</span>
  2<span class=input>.         qui g byte `x' = (d1_02 == `count' &amp; d1_03 == 1)</span>
  3<span class=input>.         </span>
<span class=input>.         * Check that asset matches order</span>
<span class=input>.         display in yellow "`x': `count' asset code"</span>
  4<span class=input>.         local count = `count'+1</span>
  5<span class=input>.         }</span>
<span class=result>trunk: 1 asset code</span>
<span class=result>bucket: 2 asset code</span>
<span class=result>stove: 3 asset code</span>
<span class=result>cookpots: 4 asset code</span>
<span class=result>bed: 5 asset code</span>
<span class=result>cabinet: 6 asset code</span>
<span class=result>tableChairs: 7 asset code</span>
<span class=result>hukka: 8 asset code</span>
<span class=result>fan: 9 asset code</span>
<span class=result>iron: 10 asset code</span>
<span class=result>radio: 11 asset code</span>
<span class=result>cd: 12 asset code</span>
<span class=result>clock: 13 asset code</span>
<span class=result>tvbw: 14 asset code</span>
<span class=result>tvclr: 15 asset code</span>
<span class=result>gold: 16 asset code</span>
<span class=result>sew: 17 asset code</span>
<span class=result>bike: 18 asset code</span>
<span class=result>rickshaw: 19 asset code</span>
<span class=result>van: 20 asset code</span>
<span class=result>boat: 21 asset code</span>
<span class=result>elecboat: 22 asset code</span>
<span class=result>moto: 23 asset code</span>
<span class=result>mobile: 24 asset code</span>
<span class=result>landphone: 25 asset code</span>
<span class=result>thresher: 26 asset code</span>
<span class=result>mill: 27 asset code</span>
<span class=result>randa: 28 asset code</span>
<span class=result>saw: 29 asset code</span>
<span class=result>hammer: 30 asset code</span>
<span class=result>patkoa: 31 asset code</span>
<span class=result>fishnet: 32 asset code</span>
<span class=result>spade: 33 asset code</span>
<span class=result>axe: 34 asset code</span>
<span class=result>shovel: 35 asset code</span>
<span class=result>shabol: 36 asset code</span>
<span class=result>daa: 37 asset code</span>
<span class=result>horse: 38 asset code</span>
<span class=result>mule: 39 asset code</span>
<span class=result>donkey: 40 asset code</span>
<br><br>
<span class=input>. *end</span>
<span class=input>. foreach name of varlist trunk-donkey {</span>
  2<span class=input>.         la var `name' "No. `name's owned by hh"</span>
  3<span class=input>.         bys a01: egen n`name' = total(`name')</span>
  4<span class=input>.         la var n`name' "Total `name's owned by hh"</span>
  5<span class=input>. }</span>
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. bys a01: g nsolar = d1_04 if d1_02 == 43 &amp; d1_03 == 1</span>
(292451 missing values generated)
<br><br>
<span class=input>. la var nsolar "hh has solar energy panel"</span>
<br><br>
<span class=input>. </span>
<span class=input>. bys a01: g ngenerator = d1_04 if d1_02 == 44 &amp; d1_03 == 1</span>
(292702 missing values generated)
<br><br>
<span class=input>. la var ngenerator "hh has electricity generator"</span>
<br><br>
<span class=input>. </span>
<span class=input>. bys a01: g cashOnHand = d1_04 if d1_02 == 42 </span>
(287634 missing values generated)
<br><br>
<span class=input>. replace cashOnHand = 0 if cashOnHand == .</span>
(287634 real changes made)
<br><br>
<span class=input>. la var cashOnHand "Cash on hand at time of survey"</span>
<br><br>
<span class=input>. </span>
<span class=input>. bys a01: g jewelryVal = d1_10 if d1_02 == 16</span>
(287658 missing values generated)
<br><br>
<span class=input>. replace jewelryVal = 0 if jewelryVal == .</span>
(287658 real changes made)
<br><br>
<span class=input>. la var jewelryVal "Value of jewelry"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Exchange rate was about 0.014 dollars to Taka in 2011</span>
<span class=input>. * or about 71 Taka to dollars </span>
<span class=input>. * Calculate value of durables owned and check distribution</span>
<span class=input>. sort a01 d1_02</span>
<br><br>
<span class=input>. egen hhDurablesValue = sum(d1_10), by(a01 d1_02)</span>
<br><br>
<span class=input>. *tabstat hhDurablesValue, by(d1_02) stat(mean sd min max)</span>
<span class=input>. </span>
<span class=input>. * Another method for hhdurval</span>
<span class=input>. egen munitprice = median(d1_10), by(d1_02)</span>
(5075 missing values generated)
<br><br>
<span class=input>. la var munitprice "Median price of durable asset"</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Calculate total value of all durables (including gold and jewelry)</span>
<span class=input>. egen hhdurasset = total(d1_04 * munitprice), by(a01)</span>
<br><br>
<span class=input>. la var hhdurasset "Total value of all durable assets"</span>
<br><br>
<span class=input>. replace hhdurasset = . if hhdurasset ==0</span>
(88 real changes made, 88 to missing)
<br><br>
<span class=input>. </span>
<span class=input>. *Collapse process</span>
<span class=input>. ds (d1* munitprice), not</span>
a01           hukka         sew           thresher      shovel        ncookpots     nclock        nelecboat     npatkoa       ndonkey
sample_type   fan           bike          mill          shabol        nbed          ntvbw         nmoto         nfishnet      nsolar
trunk         iron          rickshaw      randa         daa           ncabinet      ntvclr        nmobile       nspade        ngenerator
bucket        radio         van           saw           horse         ntableChairs  ngold         nlandphone    naxe          cashOnHand
stove         cd            boat          hammer        mule          nhukka        nsew          nthresher     nshovel       jewelryVal
cookpots      clock         elecboat      patkoa        donkey        nfan          nbike         nmill         nshabol       hhDurables~e
bed           tvbw          moto          fishnet       ntrunk        niron         nrickshaw     nranda        ndaa          hhdurasset
cabinet       tvclr         mobile        spade         nbucket       nradio        nvan          nsaw          nhorse
tableChairs   gold          landphone     axe           nstove        ncd           nboat         nhammer       nmule
<br><br>
<span class=input>. keep `r(varlist)'</span>
<br><br>
<span class=input>. </span>
<span class=input>. *Order the variable list for ease</span>
<span class=input>. order a01 hhDurablesValue</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Collapse down to HH level</span>
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
<span class=input>. ds (a01 hhDurablesValue), not</span>
sample_type   fan           bike          mill          shabol        nbed          ntvbw         nmoto         nfishnet      nsolar
trunk         iron          rickshaw      randa         daa           ncabinet      ntvclr        nmobile       nspade        ngenerator
bucket        radio         van           saw           horse         ntableChairs  ngold         nlandphone    naxe          cashOnHand
stove         cd            boat          hammer        mule          nhukka        nsew          nthresher     nshovel       jewelryVal
cookpots      clock         elecboat      patkoa        donkey        nfan          nbike         nmill         nshabol       hhdurasset
bed           tvbw          moto          fishnet       ntrunk        niron         nrickshaw     nranda        ndaa
cabinet       tvclr         mobile        spade         nbucket       nradio        nvan          nsaw          nhorse
tableChairs   gold          landphone     axe           nstove        ncd           nboat         nhammer       nmule
hukka         sew           thresher      shovel        ncookpots     nclock        nelecboat     npatkoa       ndonkey
<br><br>
<span class=input>. collapse (sum) hhDurablesValue (max) `r(varlist)', by(a01)</span>
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
<span class=input>. * Run summary statistics on assets</span>
<span class=input>. tabstat ntrunk-ngenerator, stat(mean sd min max)</span>
<br><br>
   stats |    ntrunk   nbucket    nstove  ncookp~s      nbed  ncabinet  ntable~s    nhukka      nfan     niron    nradio       ncd    nclock
---------+----------------------------------------------------------------------------------------------------------------------------------
    mean | <span class=result> .6378594  .8385361  .0239889  .9647855  .9461787  .6421652  .7319699  .0038444  .3792096  .0544364  .0427495  .0645856  .3069353</span>
      sd | <span class=result> .4806561  .3679866  .1530263  .1843358  .2256821  .4794001  .4429674  .0618885  .4852277  .2268943  .2023074  .2458121  .4612578</span>
     min | <span class=result>        0         0         0         0         0         0         0         0         0         0         0         0         0</span>
     max | <span class=result>        1         1         1         1         1         1         1         1         1         1         1         1         1</span>
--------------------------------------------------------------------------------------------------------------------------------------------
<br><br>
   stats |     ntvbw    ntvclr     ngold      nsew     nbike  nricks~w      nvan     nboat  nelecb~t     nmoto   nmobile  nlandp~e  nthres~r
---------+----------------------------------------------------------------------------------------------------------------------------------
    mean | <span class=result> .1151776  .1440873  .7767184  .0432108  .2563432  .0199908   .047209  .0327541  .0055359  .0264493  .7270491  .0010764  .0387513</span>
      sd | <span class=result> .3192607  .3512053  .4164776   .203347  .4366471  .1399791  .2121019  .1780061  .0742031  .1604797  .4455101  .0327938  .1930166</span>
     min | <span class=result>        0         0         0         0         0         0         0         0         0         0         0         0         0</span>
     max | <span class=result>        1         1         1         1         1         1         1         1         1         1         1         1         1</span>
--------------------------------------------------------------------------------------------------------------------------------------------
<br><br>
   stats |     nmill    nranda      nsaw   nhammer   npatkoa  nfishnet    nspade      naxe   nshovel   nshabol      ndaa    nhorse     nmule
---------+----------------------------------------------------------------------------------------------------------------------------------
    mean | <span class=result> .0255267  .0147624  .0711979   .152545  .0023066    .22159  .6137167  .3361525  .0146086   .433646  .8675996   .002768  .0003076</span>
      sd | <span class=result> .1577304  .1206098  .2571749   .359576  .0479756  .4153486  .4869342  .4724281  .1199893  .4956157  .3389517  .0525425  .0175358</span>
     min | <span class=result>        0         0         0         0         0         0         0         0         0         0         0         0         0</span>
     max | <span class=result>        1         1         1         1         1         1         1         1         1         1         1         1         1</span>
--------------------------------------------------------------------------------------------------------------------------------------------
<br><br>
   stats |   ndonkey    nsolar  ngener~r
---------+------------------------------
    mean | <span class=result> .0001538  1.015504         1</span>
      sd | <span class=result> .0124006  .1237857         0</span>
     min | <span class=result>        0         1         1</span>
     max | <span class=result>        1         2         1</span>
----------------------------------------
<br><br>
<span class=input>. </span>
<span class=input>. * Winsorize the asset values (revisit this in QA/QC file</span>
<span class=input>. * winsor2 hhDurablesValue hhdurasset, replace cuts(1 99)</span>
<span class=input>. </span>
<span class=input>. * Create durable wealth index based on durable assets</span>
<span class=input>. #delimit ;</span>
delimiter now ;
<span class=input>.         qui factor trunk bucket stove cookpots bed cabinet tableChairs hukka </span>
<span class=input>&gt;         fan iron radio cd clock tvbw tvclr sew bike rickshaw van </span>
<span class=input>&gt;         boat elecboat moto mobile landphone, pcf;</span>
<br><br>
<span class=input>. #delimit cr</span>
delimiter now cr
<span class=input>. qui rotate</span>
<br><br>
<span class=input>. qui predict durwealth</span>
<br><br>
<span class=input>. </span>
<span class=input>. /* Check Cronbach's alpha for Scale reliability coefficent higher than 0.50;</span>
<span class=input>&gt;         Scale derived is reasonable b/c the estimated correlation between it and </span>
<span class=input>&gt;         underlying factor it is measuring is sqrt(0.69) = .8333 */</span>
<span class=input>. #delimit ;</span>
delimiter now ;
<span class=input>.         alpha trunk bucket stove cookpots bed cabinet tableChairs hukka </span>
<span class=input>&gt;         fan iron radio cd clock tvbw tvclr sew bike rickshaw van </span>
<span class=input>&gt;         boat elecboat moto mobile landphone;</span>
<br><br>
Test scale = mean(unstandardized items)
Reversed items: <span class=result> rickshaw van boat</span>
<br><br>
Average interitem covariance:    <span class=result> .0082524</span>
Number of items in the scale:    <span class=result>       24</span>
Scale reliability coefficient:   <span class=result>   0.6944</span>
<br><br>
<span class=input>. #delimit cr</span>
delimiter now cr
<span class=input>. </span>
<span class=input>. * Plot loadings for review</span>
<span class=input>. loadingplot, mlabs(small) mlabc(maroon) mc(maroon) /*</span>
<span class=input>&gt;         */ xline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*</span>
<span class=input>&gt;         */ yline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*</span>
<span class=input>&gt;         */ title(Household durable wealth index loadings)</span>
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
<br><br>
<span class=input>. graph export "$pathgraph/durwealthLoadings.png", as(png) replace</span>
(file U:\Bangladesh\Graph/durwealthLoadings.png written in PNG format)
<br><br>
<span class=input>. scree, title(Scree plot of durable wealth index)</span>
<br><br>
<span class=input>. graph export "$pathgragh/durwealthScree.png", as(png) replace</span>
(file /durwealthScree.png written in PNG format)
<br><br>
<span class=input>. </span>
<span class=input>. * Generate variable reflecting fungible wealth</span>
<span class=input>. g fungWealth = jewelryVal + cashOnHand</span>
<br><br>
<span class=input>. la var fungWealth "fungible wealth holdings"</span>
<br><br>
<span class=input>. </span>
<span class=input>. save "$pathout/hhdurables.dta", replace</span>
(note: file U:\Bangladesh\Dataout/hhdurables.dta not found)
file U:\Bangladesh\Dataout/hhdurables.dta saved
<br><br>
<span class=input>. </span>
<span class=input>. *************</span>
<span class=input>. * Ag Assets *</span>
<span class=input>. *************</span>
<span class=input>. </span>
<span class=input>. *load module</span>
<span class=input>. use "$pathin/007_mod_d2_male.dta", clear</span>
<br><br>
<span class=input>. </span>
<span class=input>. * create vector of assets for which binary variables are created</span>
<span class=input>. #delimit ;</span>
delimiter now ;
<span class=input>. local agassets kaste nirani ladder rake ploughYoke reaper sprayer wheelbarrow</span>
<span class=input>&gt;                 bullockCart pushCart;</span>
<br><br>
<span class=input>. #delimit cr</span>
delimiter now cr
<span class=input>. local count = 1</span>
<br><br>
<span class=input>. </span>
<span class=input>. foreach x of local agassets {</span>
  2<span class=input>.         bys a01: g `x' = d2_04 if (d2_02 == `count' &amp; d2_03 == 1)</span>
  3<span class=input>.         replace `x' = 0 if `x' ==.</span>
  4<span class=input>.         la var `x' "HH owns `x'"</span>
  5<span class=input>.         </span>
<span class=input>.         * Check that asset matches order</span>
<span class=input>.         display in yellow "`x': `count' asset code"</span>
  6<span class=input>.         local count = `count'+1</span>
  7<span class=input>.         }</span>
(210063 missing values generated)
(210063 real changes made)
<span class=result>kaste: 1 asset code</span>
(212315 missing values generated)
(212315 real changes made)
<span class=result>nirani: 2 asset code</span>
(213523 missing values generated)
(213523 real changes made)
<span class=result>ladder: 3 asset code</span>
(214558 missing values generated)
(214558 real changes made)
<span class=result>rake: 4 asset code</span>
(214005 missing values generated)
(214005 real changes made)
<span class=result>ploughYoke: 5 asset code</span>
(214498 missing values generated)
(214498 real changes made)
<span class=result>reaper: 6 asset code</span>
(214181 missing values generated)
(214181 real changes made)
<span class=result>sprayer: 7 asset code</span>
(214589 missing values generated)
(214589 real changes made)
<span class=result>wheelbarrow: 8 asset code</span>
(214580 missing values generated)
(214580 real changes made)
<span class=result>bullockCart: 9 asset code</span>
(214588 missing values generated)
(214588 real changes made)
<span class=result>pushCart: 10 asset code</span>
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. * create vector of assets for which binary variables are created</span>
<span class=input>. #delimit ;</span>
delimiter now ;
<span class=input>. local machines tractor tiller trolley thresher fodderMachine swingBasket</span>
<span class=input>&gt;                 Don handWell treadlePump rowerPump llp stubeWell dtubeWell</span>
<span class=input>&gt;                 elecPump dieselPump elecSprayer harvester;</span>
<br><br>
<span class=input>. #delimit cr</span>
delimiter now cr
<span class=input>. </span>
<span class=input>. </span>
<span class=input>. * Start count on Machinery assets (p. 10, Module D2)</span>
<span class=input>. local count = 12</span>
<br><br>
<span class=input>. foreach x of local machines {</span>
  2<span class=input>.         bys a01: g `x' = d2_04 if (d2_02 == `count' &amp; d2_03 == 1)</span>
  3<span class=input>.         replace `x' = 0 if `x' ==.</span>
  4<span class=input>.         la var `x' "HH owns `x'"</span>
  5<span class=input>.         </span>
<span class=input>.         * Check that asset matches order</span>
<span class=input>.         display in yellow "`x': `count' asset code"</span>
  6<span class=input>.         local count = `count'+1</span>
  7<span class=input>.         }</span>
(214593 missing values generated)
(214593 real changes made)
<span class=result>tractor: 12 asset code</span>
(214515 missing values generated)
(214515 real changes made)
<span class=result>tiller: 13 asset code</span>
(214585 missing values generated)
(214585 real changes made)
<span class=result>trolley: 14 asset code</span>
(214547 missing values generated)
(214547 real changes made)
<span class=result>thresher: 15 asset code</span>
(214582 missing values generated)
(214582 real changes made)
<span class=result>fodderMachine: 16 asset code</span>
(214548 missing values generated)
(214548 real changes made)
<span class=result>swingBasket: 17 asset code</span>
(214578 missing values generated)
(214578 real changes made)
<span class=result>Don: 18 asset code</span>
(213092 missing values generated)
(213092 real changes made)
<span class=result>handWell: 19 asset code</span>
(214591 missing values generated)
(214591 real changes made)
<span class=result>treadlePump: 20 asset code</span>
(214595 missing values generated)
(214595 real changes made)
<span class=result>rowerPump: 21 asset code</span>
(214532 missing values generated)
(214532 real changes made)
<span class=result>llp: 22 asset code</span>
(214226 missing values generated)
(214226 real changes made)
<span class=result>stubeWell: 23 asset code</span>
(214568 missing values generated)
(214568 real changes made)
<span class=result>dtubeWell: 24 asset code</span>
(214472 missing values generated)
(214472 real changes made)
<span class=result>elecPump: 25 asset code</span>
(214550 missing values generated)
(214550 real changes made)
<span class=result>dieselPump: 26 asset code</span>
(214581 missing values generated)
(214581 real changes made)
<span class=result>elecSprayer: 27 asset code</span>
(214597 missing values generated)
(214597 real changes made)
<span class=result>harvester: 28 asset code</span>
<br><br>
<span class=input>. *end</span>
<span class=input>. </span>
<span class=input>. * Calculate the median value of each asset group</span>
<span class=input>. * For example: for tractors, take the median value of all tractors listed</span>
<span class=input>. * Then multiply that number by the number of tractors owned by a hh </span>
<span class=input>. egen munitprice = median(d2_10), by(d2_02)</span>
<br><br>
<span class=input>. la var munitprice "Median price of ag assets"</span>
<br><br>
<span class=input>. </span>
<span class=input>. egen hhagasset = total(d2_04 * munitprice), by(a01)</span>
<br><br>
<span class=input>. la var hhagasset "Total value of all ag assets"</span>
<br><br>
<span class=input>. * Question here: do we assumed if a hh does not own an asset it's value is missing</span>
<span class=input>. * or zero? To be revisited before analysis (can do w/ and w/out).</span>
<span class=input>. replace hhagasset = . if hhagasset ==0</span>
(47355 real changes made, 47355 to missing)
<br><br>
<span class=input>. </span>
<span class=input>. * What is median price of assets?</span>
<span class=input>. tab d2_02, sum(munitprice) mi</span>
<br><br>
<span class=result>            </span>|    Summary of Median price of ag
 asset name |               assets
   and code |        Mean   Std. Dev.       Freq.
------------+------------------------------------
      kaste |  <span class=result>        30           0        6503</span>
<span class=result>  </span>   nirani |  <span class=result>        30           0        6503</span>
<span class=result>  </span>   ladder |  <span class=result>       100           0        6503</span>
<span class=result>  </span>     rake |  <span class=result>       100           0        6503</span>
<span class=result>  </span>plough &amp;  |  <span class=result>       200           0        6503</span>
<span class=result>  </span>reaper/si |  <span class=result>        30           0        6503</span>
<span class=result>  </span>manual sp |  <span class=result>       500           0        6503</span>
<span class=result>  </span>wheelbarr |  <span class=result>      4000           0        6503</span>
<span class=result>  </span>bullock c |  <span class=result>      3000           0        6503</span>
<span class=result>  </span>push cart |  <span class=result>      1500           0        6503</span>
<span class=result>  </span>other lig |  <span class=result>      1800           0        6503</span>
<span class=result>  </span>   tracto |  <span class=result>     30000           0        6503</span>
<span class=result>  </span>power til |  <span class=result>     40000           0        6503</span>
<span class=result>  </span>trolley/t |  <span class=result>     18000           0        6503</span>
<span class=result>  </span> thresher |  <span class=result>      2500           0        6503</span>
<span class=result>  </span>fodder cu |  <span class=result>        80           0        6503</span>
<span class=result>  </span>swing bas |  <span class=result>        40           0        6503</span>
<span class=result>  </span>      don |  <span class=result>       170           0        6503</span>
<span class=result>  </span>hand tube |  <span class=result>      2000           0        6503</span>
<span class=result>  </span>treadle p |  <span class=result>      1500           0        6503</span>
<span class=result>  </span>rower pum |  <span class=result>      2250           0        6503</span>
<span class=result>  </span>low lift  |  <span class=result>      8000           0        6503</span>
<span class=result>  </span>shallow t |  <span class=result>      8000           0        6503</span>
<span class=result>  </span>deep tube |  <span class=result>      4000           0        6503</span>
<span class=result>  </span>electric  |  <span class=result>      4500           0        6503</span>
<span class=result>  </span>diesel mo |  <span class=result>      8000           0        6503</span>
<span class=result>  </span>spraying  |  <span class=result>       600           0        6503</span>
<span class=result>  </span>harvester |  <span class=result>     16500           0        6503</span>
<span class=result>  </span>other hea |  <span class=result>      5000           0        6503</span>
<span class=result>  </span>masons eq |  <span class=result>       775           0        6503</span>
<span class=result>  </span>potters c |  <span class=result>       500           0        6503</span>
<span class=result>  </span>blacksmit |  <span class=result>       500           0        6503</span>
<span class=result>  </span>   charka |  <span class=result>       200           0        6503</span>
------------+------------------------------------
      Total |  <span class=result> 4981.9697   8842.6549      214599</span>
<br><br>
<span class=input>. </span>
<span class=input>. *Collapse</span>
<span class=input>. ds(d2*), not</span>
a01           ladder        sprayer       tractor       fodderMach~e  treadlePump   dtubeWell     harvester
sample_type   rake          wheelbarrow   tiller        swingBasket   rowerPump     elecPump      munitprice
kaste         ploughYoke    bullockCart   trolley       Don           llp           dieselPump    hhagasset
nirani        reaper        pushCart      thresher      handWell      stubeWell     elecSprayer
<br><br>
<span class=input>. keep `r(varlist)'</span>
<br><br>
<span class=input>. </span>
<span class=input>. * copy variable labels to reapply</span>
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
<span class=input>. * Collapse data down to HH level</span>
<span class=input>. ds(a01 munitprice), not</span>
sample_type   ladder        reaper        bullockCart   tiller        fodderMach~e  handWell      llp           elecPump      harvester
kaste         rake          sprayer       pushCart      trolley       swingBasket   treadlePump   stubeWell     dieselPump    hhagasset
nirani        ploughYoke    wheelbarrow   tractor       thresher      Don           rowerPump     dtubeWell     elecSprayer
<br><br>
<span class=input>. #delimit ;</span>
delimiter now ;
<span class=input>.         qui collapse (max) `r(varlist)',</span>
<span class=input>&gt;         by(a01) fast;</span>
<br><br>
<span class=input>. #delimit cr</span>
delimiter now cr
<span class=input>. </span>
<span class=input>. * Reapply variable lables and save a copy</span>
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
<span class=input>. *Run factor analysis to create ag wealth index</span>
<span class=input>. qui ds(a01 sample_type hhagasset), not</span>
<br><br>
<span class=input>. qui factor kaste-harvester, pcf</span>
<br><br>
<span class=input>. rotate</span>
<br><br>
Factor analysis/correlation                        Number of obs    = <span class=result>    6503</span>
<span class=result>    </span>Method: principal-component factors            Retained factors = <span class=result>      12</span>
<span class=result>    </span>Rotation: orthogonal varimax (Kaiser off)      Number of params = <span class=result>     258</span>
<br><br>
    --------------------------------------------------------------------------
         Factor  |     Variance   Difference        Proportion   Cumulative
    -------------+------------------------------------------------------------
        Factor1  |<span class=result>      2.28163      0.99073            0.0845       0.0845</span>
        Factor2  |<span class=result>      1.29091      0.06791            0.0478       0.1323</span>
        Factor3  |<span class=result>      1.22300      0.04630            0.0453       0.1776</span>
        Factor4  |<span class=result>      1.17670      0.00516            0.0436       0.2212</span>
        Factor5  |<span class=result>      1.17155      0.04950            0.0434       0.2646</span>
        Factor6  |<span class=result>      1.12204      0.00204            0.0416       0.3061</span>
        Factor7  |<span class=result>      1.12000      0.00825            0.0415       0.3476</span>
        Factor8  |<span class=result>      1.11176      0.02138            0.0412       0.3888</span>
        Factor9  |<span class=result>      1.09038      0.02154            0.0404       0.4292</span>
       Factor10  |<span class=result>      1.06885      0.00606            0.0396       0.4688</span>
       Factor11  |<span class=result>      1.06279      0.04889            0.0394       0.5081</span>
       Factor12  |<span class=result>      1.01390            .            0.0376       0.5457</span>
    --------------------------------------------------------------------------
    LR test: independent vs. saturated: chi2(<span class=result>351</span>) =<span class=result> 8538.91</span> Prob&gt;chi2 =<span class=result> 0.0000</span>
<br><br>
Rotated factor loadings (pattern matrix) and unique variances
<br><br>
    --------------------------------------------------------------------------------------------------------------------------------------
        Variable |  Factor1   Factor2   Factor3   Factor4   Factor5   Factor6   Factor7   Factor8   Factor9  Factor10  Factor11  Factor12 
    -------------+------------------------------------------------------------------------------------------------------------------------
           kaste | <span class=result>  0.7051</span>  <span class=result>  0.1035</span>  <span class=result>  0.0984</span>  <span class=result> -0.0471</span>  <span class=result>  0.0006</span>  <span class=result> -0.0478</span>  <span class=result> -0.0646</span>  <span class=result> -0.0042</span>  <span class=result> -0.0280</span>  <span class=result> -0.0385</span>  <span class=result>  0.0216</span>  <span class=result>  0.0763</span> 
          nirani | <span class=result>  0.6501</span>  <span class=result>  0.1223</span>  <span class=result>  0.1209</span>  <span class=result>  0.0168</span>  <span class=result> -0.1362</span>  <span class=result> -0.2138</span>  <span class=result> -0.1073</span>  <span class=result>  0.0437</span>  <span class=result> -0.0819</span>  <span class=result> -0.0933</span>  <span class=result> -0.1021</span>  <span class=result>  0.0667</span> 
          ladder | <span class=result>  0.7028</span>  <span class=result> -0.0270</span>  <span class=result>  0.0127</span>  <span class=result>  0.0971</span>  <span class=result>  0.1030</span>  <span class=result>  0.1639</span>  <span class=result>  0.1283</span>  <span class=result> -0.0152</span>  <span class=result>  0.1261</span>  <span class=result>  0.0302</span>  <span class=result>  0.0762</span>  <span class=result> -0.1237</span> 
            rake | <span class=result>  0.1658</span>  <span class=result>  0.0500</span>  <span class=result> -0.1148</span>  <span class=result>  0.0113</span>  <span class=result> -0.0324</span>  <span class=result>  0.0741</span>  <span class=result>  0.3320</span>  <span class=result> -0.4756</span>  <span class=result>  0.0416</span>  <span class=result>  0.0381</span>  <span class=result> -0.0482</span>  <span class=result>  0.2961</span> 
      ploughYoke | <span class=result>  0.6475</span>  <span class=result> -0.1846</span>  <span class=result> -0.0403</span>  <span class=result>  0.0969</span>  <span class=result>  0.1897</span>  <span class=result>  0.2353</span>  <span class=result>  0.0393</span>  <span class=result> -0.0657</span>  <span class=result>  0.0964</span>  <span class=result>  0.0598</span>  <span class=result>  0.1910</span>  <span class=result> -0.0953</span> 
          reaper | <span class=result>  0.0279</span>  <span class=result> -0.1412</span>  <span class=result>  0.6324</span>  <span class=result> -0.0869</span>  <span class=result>  0.0782</span>  <span class=result>  0.2880</span>  <span class=result>  0.0140</span>  <span class=result>  0.1101</span>  <span class=result>  0.0136</span>  <span class=result> -0.1256</span>  <span class=result>  0.0172</span>  <span class=result> -0.0449</span> 
         sprayer | <span class=result>  0.4390</span>  <span class=result>  0.1889</span>  <span class=result> -0.0221</span>  <span class=result>  0.1580</span>  <span class=result> -0.2003</span>  <span class=result> -0.0648</span>  <span class=result>  0.2698</span>  <span class=result>  0.2762</span>  <span class=result>  0.0899</span>  <span class=result>  0.1453</span>  <span class=result> -0.1325</span>  <span class=result> -0.0480</span> 
     wheelbarrow | <span class=result>  0.0658</span>  <span class=result> -0.0127</span>  <span class=result> -0.0078</span>  <span class=result> -0.0230</span>  <span class=result>  0.6340</span>  <span class=result>  0.0465</span>  <span class=result> -0.1124</span>  <span class=result>  0.1348</span>  <span class=result> -0.0546</span>  <span class=result> -0.0090</span>  <span class=result> -0.0183</span>  <span class=result> -0.0556</span> 
     bullockCart | <span class=result>  0.1012</span>  <span class=result> -0.0988</span>  <span class=result>  0.0059</span>  <span class=result>  0.7400</span>  <span class=result>  0.0875</span>  <span class=result> -0.0355</span>  <span class=result> -0.0417</span>  <span class=result> -0.1503</span>  <span class=result>  0.1066</span>  <span class=result> -0.0247</span>  <span class=result>  0.0006</span>  <span class=result>  0.0666</span> 
        pushCart | <span class=result>  0.0070</span>  <span class=result>  0.1089</span>  <span class=result> -0.0230</span>  <span class=result>  0.1245</span>  <span class=result>  0.6388</span>  <span class=result> -0.0572</span>  <span class=result>  0.1742</span>  <span class=result> -0.1106</span>  <span class=result>  0.0798</span>  <span class=result> -0.0808</span>  <span class=result> -0.0940</span>  <span class=result>  0.0795</span> 
         tractor | <span class=result> -0.0255</span>  <span class=result> -0.0359</span>  <span class=result>  0.0078</span>  <span class=result>  0.2006</span>  <span class=result> -0.0975</span>  <span class=result>  0.0538</span>  <span class=result> -0.2341</span>  <span class=result> -0.0461</span>  <span class=result>  0.6770</span>  <span class=result>  0.0701</span>  <span class=result>  0.0042</span>  <span class=result>  0.0284</span> 
          tiller | <span class=result>  0.0664</span>  <span class=result>  0.6789</span>  <span class=result> -0.0054</span>  <span class=result> -0.0517</span>  <span class=result>  0.1375</span>  <span class=result>  0.1737</span>  <span class=result>  0.0440</span>  <span class=result>  0.1670</span>  <span class=result>  0.1125</span>  <span class=result> -0.0072</span>  <span class=result> -0.1052</span>  <span class=result> -0.0067</span> 
         trolley | <span class=result> -0.0274</span>  <span class=result>  0.6680</span>  <span class=result>  0.0008</span>  <span class=result>  0.0008</span>  <span class=result> -0.0514</span>  <span class=result> -0.0178</span>  <span class=result> -0.1062</span>  <span class=result> -0.1990</span>  <span class=result> -0.0505</span>  <span class=result> -0.0273</span>  <span class=result>  0.2218</span>  <span class=result>  0.0028</span> 
        thresher | <span class=result>  0.0409</span>  <span class=result>  0.1739</span>  <span class=result>  0.1509</span>  <span class=result>  0.0642</span>  <span class=result> -0.0025</span>  <span class=result>  0.6985</span>  <span class=result> -0.0482</span>  <span class=result>  0.0160</span>  <span class=result>  0.0327</span>  <span class=result> -0.0047</span>  <span class=result>  0.1293</span>  <span class=result> -0.0677</span> 
    fodderMach~e | <span class=result>  0.1359</span>  <span class=result> -0.0119</span>  <span class=result> -0.2059</span>  <span class=result> -0.1528</span>  <span class=result> -0.1189</span>  <span class=result>  0.4951</span>  <span class=result>  0.0208</span>  <span class=result> -0.1383</span>  <span class=result> -0.0976</span>  <span class=result>  0.0055</span>  <span class=result> -0.2808</span>  <span class=result>  0.2521</span> 
     swingBasket | <span class=result>  0.1627</span>  <span class=result>  0.0338</span>  <span class=result>  0.0221</span>  <span class=result> -0.1089</span>  <span class=result>  0.4056</span>  <span class=result> -0.1290</span>  <span class=result> -0.0847</span>  <span class=result> -0.0563</span>  <span class=result> -0.1012</span>  <span class=result>  0.4656</span>  <span class=result>  0.0461</span>  <span class=result>  0.1221</span> 
             Don | <span class=result>  0.0986</span>  <span class=result>  0.0454</span>  <span class=result> -0.0688</span>  <span class=result> -0.0095</span>  <span class=result> -0.0571</span>  <span class=result>  0.0564</span>  <span class=result> -0.0119</span>  <span class=result>  0.0327</span>  <span class=result> -0.0369</span>  <span class=result>  0.0034</span>  <span class=result>  0.7757</span>  <span class=result>  0.0903</span> 
        handWell | <span class=result>  0.1780</span>  <span class=result>  0.0698</span>  <span class=result>  0.6531</span>  <span class=result> -0.0145</span>  <span class=result> -0.0606</span>  <span class=result> -0.1725</span>  <span class=result> -0.1221</span>  <span class=result> -0.0704</span>  <span class=result>  0.0254</span>  <span class=result>  0.0066</span>  <span class=result> -0.1547</span>  <span class=result>  0.1658</span> 
     treadlePump | <span class=result>  0.0678</span>  <span class=result> -0.0031</span>  <span class=result> -0.0826</span>  <span class=result> -0.0628</span>  <span class=result> -0.0339</span>  <span class=result>  0.0205</span>  <span class=result>  0.0140</span>  <span class=result> -0.0159</span>  <span class=result> -0.0217</span>  <span class=result>  0.0289</span>  <span class=result> -0.1016</span>  <span class=result> -0.7855</span> 
       rowerPump | <span class=result> -0.0299</span>  <span class=result> -0.0214</span>  <span class=result> -0.0118</span>  <span class=result> -0.0054</span>  <span class=result> -0.0545</span>  <span class=result>  0.0149</span>  <span class=result> -0.0100</span>  <span class=result>  0.0150</span>  <span class=result>  0.0287</span>  <span class=result>  0.8350</span>  <span class=result> -0.0109</span>  <span class=result> -0.0388</span> 
             llp | <span class=result>  0.1292</span>  <span class=result>  0.0882</span>  <span class=result>  0.0091</span>  <span class=result> -0.1505</span>  <span class=result>  0.0875</span>  <span class=result> -0.0412</span>  <span class=result>  0.1783</span>  <span class=result>  0.0623</span>  <span class=result>  0.7010</span>  <span class=result> -0.0447</span>  <span class=result> -0.0433</span>  <span class=result>  0.0043</span> 
       stubeWell | <span class=result>  0.3028</span>  <span class=result>  0.3563</span>  <span class=result>  0.0366</span>  <span class=result>  0.2135</span>  <span class=result>  0.0160</span>  <span class=result>  0.1220</span>  <span class=result>  0.0335</span>  <span class=result>  0.3271</span>  <span class=result> -0.0108</span>  <span class=result>  0.0906</span>  <span class=result> -0.2934</span>  <span class=result> -0.0149</span> 
       dtubeWell | <span class=result>  0.0083</span>  <span class=result> -0.0618</span>  <span class=result> -0.0035</span>  <span class=result> -0.0070</span>  <span class=result>  0.0316</span>  <span class=result> -0.0329</span>  <span class=result>  0.7445</span>  <span class=result>  0.0089</span>  <span class=result> -0.0245</span>  <span class=result> -0.0443</span>  <span class=result> -0.0084</span>  <span class=result> -0.0315</span> 
        elecPump | <span class=result> -0.0164</span>  <span class=result>  0.1245</span>  <span class=result>  0.5035</span>  <span class=result>  0.1444</span>  <span class=result> -0.0824</span>  <span class=result>  0.1188</span>  <span class=result>  0.3170</span>  <span class=result> -0.0208</span>  <span class=result> -0.0418</span>  <span class=result>  0.2706</span>  <span class=result>  0.0470</span>  <span class=result> -0.0035</span> 
      dieselPump | <span class=result>  0.0464</span>  <span class=result>  0.1382</span>  <span class=result> -0.0457</span>  <span class=result>  0.6124</span>  <span class=result> -0.0697</span>  <span class=result>  0.0766</span>  <span class=result>  0.0819</span>  <span class=result>  0.2693</span>  <span class=result> -0.1648</span>  <span class=result> -0.0117</span>  <span class=result> -0.0243</span>  <span class=result> -0.0016</span> 
     elecSprayer | <span class=result>  0.0503</span>  <span class=result>  0.0703</span>  <span class=result>  0.0344</span>  <span class=result> -0.0703</span>  <span class=result>  0.0012</span>  <span class=result> -0.1257</span>  <span class=result>  0.2481</span>  <span class=result>  0.5139</span>  <span class=result>  0.0905</span>  <span class=result> -0.0165</span>  <span class=result>  0.2788</span>  <span class=result>  0.1285</span> 
       harvester | <span class=result>  0.0142</span>  <span class=result> -0.1582</span>  <span class=result> -0.1433</span>  <span class=result> -0.0588</span>  <span class=result> -0.0080</span>  <span class=result>  0.1498</span>  <span class=result> -0.0956</span>  <span class=result>  0.4370</span>  <span class=result> -0.0024</span>  <span class=result>  0.0463</span>  <span class=result> -0.1326</span>  <span class=result>  0.3428</span> 
    --------------------------------------------------------------------------------------------------------------------------------------
<br><br>
    ----------------------------
        Variable |   Uniqueness 
    -------------+--------------
           kaste |  <span class=result>    0.4651</span>  
          nirani |  <span class=result>    0.4395</span>  
          ladder |  <span class=result>    0.4036</span>  
            rake |  <span class=result>    0.5205</span>  
      ploughYoke |  <span class=result>    0.3801</span>  
          reaper |  <span class=result>    0.4522</span>  
         sprayer |  <span class=result>    0.5036</span>  
     wheelbarrow |  <span class=result>    0.5534</span>  
     bullockCart |  <span class=result>    0.3827</span>  
        pushCart |  <span class=result>    0.4901</span>  
         tractor |  <span class=result>    0.4243</span>  
          tiller |  <span class=result>    0.4293</span>  
         trolley |  <span class=result>    0.4467</span>  
        thresher |  <span class=result>    0.4283</span>  
    fodderMach~e |  <span class=result>    0.4848</span>  
     swingBasket |  <span class=result>    0.5245</span>  
             Don |  <span class=result>    0.3645</span>  
        handWell |  <span class=result>    0.4313</span>  
     treadlePump |  <span class=result>    0.3540</span>  
       rowerPump |  <span class=result>    0.2953</span>  
             llp |  <span class=result>    0.4125</span>  
       stubeWell |  <span class=result>    0.5165</span>  
       dtubeWell |  <span class=result>    0.4360</span>  
        elecPump |  <span class=result>    0.5109</span>  
      dieselPump |  <span class=result>    0.4837</span>  
     elecSprayer |  <span class=result>    0.5422</span>  
       harvester |  <span class=result>    0.5909</span>  
    ----------------------------
<br><br>
Factor rotation matrix
<br><br>
    --------------------------------------------------------------------------------------------------------------------------
                 | Factor1  Factor2  Factor3  Factor4  Factor5  Factor6  Factor7  Factor8  Factor9  Fact~10  Fact~11  Fact~12 
    -------------+------------------------------------------------------------------------------------------------------------
         Factor1 | <span class=result> 0.8756</span>  <span class=result> 0.2520</span>  <span class=result> 0.1710</span>  <span class=result> 0.2121</span>  <span class=result> 0.0880</span>  <span class=result> 0.1450</span>  <span class=result> 0.1528</span>  <span class=result> 0.1322</span>  <span class=result> 0.1350</span>  <span class=result> 0.0831</span>  <span class=result>-0.0272</span>  <span class=result> 0.0155</span> 
         Factor2 | <span class=result>-0.3511</span>  <span class=result> 0.6537</span>  <span class=result> 0.3238</span>  <span class=result> 0.1331</span>  <span class=result>-0.3369</span>  <span class=result> 0.1928</span>  <span class=result> 0.0834</span>  <span class=result> 0.3887</span>  <span class=result>-0.0647</span>  <span class=result> 0.0290</span>  <span class=result>-0.1142</span>  <span class=result>-0.0056</span> 
         Factor3 | <span class=result>-0.1554</span>  <span class=result> 0.2918</span>  <span class=result>-0.7194</span>  <span class=result> 0.3114</span>  <span class=result> 0.3917</span>  <span class=result>-0.0011</span>  <span class=result> 0.2649</span>  <span class=result> 0.1477</span>  <span class=result> 0.1385</span>  <span class=result> 0.0743</span>  <span class=result>-0.0465</span>  <span class=result>-0.0620</span> 
         Factor4 | <span class=result>-0.1189</span>  <span class=result> 0.3092</span>  <span class=result> 0.2838</span>  <span class=result>-0.4488</span>  <span class=result> 0.7017</span>  <span class=result> 0.1923</span>  <span class=result>-0.1120</span>  <span class=result>-0.1538</span>  <span class=result> 0.0540</span>  <span class=result> 0.1736</span>  <span class=result> 0.0764</span>  <span class=result> 0.0620</span> 
         Factor5 | <span class=result>-0.1594</span>  <span class=result>-0.2751</span>  <span class=result> 0.4096</span>  <span class=result> 0.2448</span>  <span class=result> 0.2523</span>  <span class=result>-0.4837</span>  <span class=result> 0.3232</span>  <span class=result> 0.1978</span>  <span class=result> 0.1802</span>  <span class=result> 0.3094</span>  <span class=result>-0.3158</span>  <span class=result> 0.0468</span> 
         Factor6 | <span class=result>-0.1866</span>  <span class=result>-0.1442</span>  <span class=result> 0.1981</span>  <span class=result> 0.5077</span>  <span class=result> 0.0773</span>  <span class=result> 0.4787</span>  <span class=result>-0.1386</span>  <span class=result>-0.3407</span>  <span class=result> 0.4702</span>  <span class=result>-0.2139</span>  <span class=result>-0.0995</span>  <span class=result>-0.0139</span> 
         Factor7 | <span class=result>-0.0906</span>  <span class=result>-0.1449</span>  <span class=result> 0.0834</span>  <span class=result>-0.1544</span>  <span class=result>-0.1181</span>  <span class=result> 0.2521</span>  <span class=result> 0.7728</span>  <span class=result>-0.0875</span>  <span class=result> 0.0955</span>  <span class=result> 0.0254</span>  <span class=result> 0.4977</span>  <span class=result> 0.0147</span> 
         Factor8 | <span class=result>-0.0160</span>  <span class=result>-0.1438</span>  <span class=result>-0.0361</span>  <span class=result> 0.2291</span>  <span class=result>-0.0208</span>  <span class=result> 0.3774</span>  <span class=result> 0.0166</span>  <span class=result>-0.2147</span>  <span class=result>-0.5593</span>  <span class=result> 0.6322</span>  <span class=result>-0.1515</span>  <span class=result>-0.0239</span> 
         Factor9 | <span class=result>-0.0472</span>  <span class=result> 0.1471</span>  <span class=result> 0.1172</span>  <span class=result> 0.4225</span>  <span class=result> 0.0463</span>  <span class=result>-0.3218</span>  <span class=result>-0.2814</span>  <span class=result>-0.0766</span>  <span class=result>-0.0498</span>  <span class=result> 0.1964</span>  <span class=result> 0.7411</span>  <span class=result> 0.0534</span> 
        Factor10 | <span class=result>-0.0072</span>  <span class=result>-0.1570</span>  <span class=result>-0.1151</span>  <span class=result>-0.2234</span>  <span class=result>-0.1919</span>  <span class=result> 0.1565</span>  <span class=result>-0.2548</span>  <span class=result> 0.3159</span>  <span class=result> 0.5159</span>  <span class=result> 0.5227</span>  <span class=result> 0.1146</span>  <span class=result>-0.3655</span> 
        Factor11 | <span class=result> 0.0098</span>  <span class=result> 0.2277</span>  <span class=result>-0.1522</span>  <span class=result>-0.1240</span>  <span class=result>-0.3033</span>  <span class=result>-0.1531</span>  <span class=result> 0.0201</span>  <span class=result>-0.3965</span>  <span class=result> 0.3299</span>  <span class=result> 0.3173</span>  <span class=result>-0.1386</span>  <span class=result> 0.6385</span> 
        Factor12 | <span class=result>-0.0276</span>  <span class=result>-0.3035</span>  <span class=result>-0.0491</span>  <span class=result> 0.0343</span>  <span class=result> 0.1337</span>  <span class=result> 0.2903</span>  <span class=result>-0.1463</span>  <span class=result> 0.5605</span>  <span class=result>-0.0500</span>  <span class=result>-0.0480</span>  <span class=result> 0.1281</span>  <span class=result> 0.6668</span> 
    --------------------------------------------------------------------------------------------------------------------------
<br><br>
<span class=input>. predict agAssetWealth</span>
(regression scoring assumed)
<br><br>
Scoring coefficients (method = regression; based on varimax rotated factors)
<br><br>
    --------------------------------------------------------------------------------------------------------------------------------------
        Variable |  Factor1   Factor2   Factor3   Factor4   Factor5   Factor6   Factor7   Factor8   Factor9  Factor10  Factor11  Factor12 
    -------------+------------------------------------------------------------------------------------------------------------------------
           kaste | <span class=result> 0.34139</span>  <span class=result> 0.03540</span>  <span class=result> 0.03255</span>  <span class=result>-0.10296</span>  <span class=result>-0.03095</span>  <span class=result>-0.09012</span>  <span class=result>-0.10306</span>  <span class=result>-0.03709</span>  <span class=result>-0.06929</span>  <span class=result>-0.06245</span>  <span class=result> 0.02295</span>  <span class=result> 0.06719</span> 
          nirani | <span class=result> 0.32827</span>  <span class=result> 0.05899</span>  <span class=result> 0.05422</span>  <span class=result>-0.04116</span>  <span class=result>-0.14063</span>  <span class=result>-0.23955</span>  <span class=result>-0.13806</span>  <span class=result> 0.00095</span>  <span class=result>-0.11254</span>  <span class=result>-0.11099</span>  <span class=result>-0.09078</span>  <span class=result> 0.05825</span> 
          ladder | <span class=result> 0.30390</span>  <span class=result>-0.09152</span>  <span class=result>-0.03615</span>  <span class=result> 0.01455</span>  <span class=result> 0.04922</span>  <span class=result> 0.10511</span>  <span class=result> 0.06582</span>  <span class=result>-0.04471</span>  <span class=result> 0.06346</span>  <span class=result>-0.00023</span>  <span class=result> 0.07514</span>  <span class=result>-0.12805</span> 
            rake | <span class=result> 0.07209</span>  <span class=result> 0.05447</span>  <span class=result>-0.10653</span>  <span class=result>-0.00616</span>  <span class=result>-0.05720</span>  <span class=result> 0.05466</span>  <span class=result> 0.30429</span>  <span class=result>-0.45769</span>  <span class=result> 0.02427</span>  <span class=result> 0.03132</span>  <span class=result>-0.05512</span>  <span class=result> 0.28779</span> 
      ploughYoke | <span class=result> 0.29233</span>  <span class=result>-0.20995</span>  <span class=result>-0.06761</span>  <span class=result> 0.03283</span>  <span class=result> 0.12528</span>  <span class=result> 0.18500</span>  <span class=result>-0.00683</span>  <span class=result>-0.06715</span>  <span class=result> 0.04036</span>  <span class=result> 0.03390</span>  <span class=result> 0.17955</span>  <span class=result>-0.09827</span> 
          reaper | <span class=result>-0.03196</span>  <span class=result>-0.16423</span>  <span class=result> 0.52707</span>  <span class=result>-0.08120</span>  <span class=result> 0.08641</span>  <span class=result> 0.25442</span>  <span class=result> 0.01197</span>  <span class=result> 0.10351</span>  <span class=result> 0.00144</span>  <span class=result>-0.12991</span>  <span class=result> 0.02082</span>  <span class=result>-0.05003</span> 
         sprayer | <span class=result> 0.16166</span>  <span class=result> 0.08449</span>  <span class=result>-0.07002</span>  <span class=result> 0.06627</span>  <span class=result>-0.19568</span>  <span class=result>-0.10104</span>  <span class=result> 0.19619</span>  <span class=result> 0.19690</span>  <span class=result> 0.05045</span>  <span class=result> 0.11285</span>  <span class=result>-0.11093</span>  <span class=result>-0.04973</span> 
     wheelbarrow | <span class=result> 0.00696</span>  <span class=result>-0.02435</span>  <span class=result> 0.00147</span>  <span class=result>-0.01996</span>  <span class=result> 0.54983</span>  <span class=result> 0.04301</span>  <span class=result>-0.11505</span>  <span class=result> 0.14348</span>  <span class=result>-0.07257</span>  <span class=result>-0.02661</span>  <span class=result>-0.01614</span>  <span class=result>-0.05551</span> 
     bullockCart | <span class=result>-0.01022</span>  <span class=result>-0.10210</span>  <span class=result> 0.00761</span>  <span class=result> 0.65122</span>  <span class=result> 0.07108</span>  <span class=result>-0.04743</span>  <span class=result>-0.06361</span>  <span class=result>-0.15436</span>  <span class=result> 0.06866</span>  <span class=result>-0.03192</span>  <span class=result> 0.01385</span>  <span class=result> 0.06638</span> 
        pushCart | <span class=result>-0.05266</span>  <span class=result> 0.09015</span>  <span class=result>-0.00728</span>  <span class=result> 0.10593</span>  <span class=result> 0.54591</span>  <span class=result>-0.06138</span>  <span class=result> 0.14897</span>  <span class=result>-0.10445</span>  <span class=result> 0.04634</span>  <span class=result>-0.09772</span>  <span class=result>-0.08773</span>  <span class=result> 0.07553</span> 
         tractor | <span class=result>-0.05495</span>  <span class=result>-0.03653</span>  <span class=result>-0.00057</span>  <span class=result> 0.16486</span>  <span class=result>-0.10220</span>  <span class=result> 0.04135</span>  <span class=result>-0.22955</span>  <span class=result>-0.04320</span>  <span class=result> 0.63396</span>  <span class=result> 0.07695</span>  <span class=result> 0.01037</span>  <span class=result> 0.02904</span> 
          tiller | <span class=result>-0.04644</span>  <span class=result> 0.52113</span>  <span class=result>-0.04456</span>  <span class=result>-0.09279</span>  <span class=result> 0.11523</span>  <span class=result> 0.11310</span>  <span class=result> 0.00758</span>  <span class=result> 0.09724</span>  <span class=result> 0.08678</span>  <span class=result>-0.02718</span>  <span class=result>-0.08919</span>  <span class=result>-0.00879</span> 
         trolley | <span class=result>-0.04052</span>  <span class=result> 0.56893</span>  <span class=result>-0.01737</span>  <span class=result>-0.00567</span>  <span class=result>-0.04568</span>  <span class=result>-0.05481</span>  <span class=result>-0.10560</span>  <span class=result>-0.22933</span>  <span class=result>-0.04727</span>  <span class=result>-0.02871</span>  <span class=result> 0.21249</span>  <span class=result>-0.00092</span> 
        thresher | <span class=result>-0.04709</span>  <span class=result> 0.08879</span>  <span class=result> 0.10045</span>  <span class=result> 0.03530</span>  <span class=result> 0.00131</span>  <span class=result> 0.61611</span>  <span class=result>-0.06072</span>  <span class=result>-0.00178</span>  <span class=result> 0.01484</span>  <span class=result>-0.01060</span>  <span class=result> 0.12559</span>  <span class=result>-0.06624</span> 
    fodderMach~e | <span class=result> 0.07927</span>  <span class=result>-0.02797</span>  <span class=result>-0.19842</span>  <span class=result>-0.15564</span>  <span class=result>-0.11589</span>  <span class=result> 0.45362</span>  <span class=result> 0.01941</span>  <span class=result>-0.12835</span>  <span class=result>-0.09601</span>  <span class=result> 0.00635</span>  <span class=result>-0.27513</span>  <span class=result> 0.25076</span> 
     swingBasket | <span class=result> 0.06838</span>  <span class=result> 0.02627</span>  <span class=result> 0.01306</span>  <span class=result>-0.10082</span>  <span class=result> 0.33092</span>  <span class=result>-0.12429</span>  <span class=result>-0.09273</span>  <span class=result>-0.04897</span>  <span class=result>-0.10759</span>  <span class=result> 0.42493</span>  <span class=result> 0.04420</span>  <span class=result> 0.11560</span> 
             Don | <span class=result> 0.05207</span>  <span class=result> 0.03608</span>  <span class=result>-0.06066</span>  <span class=result>-0.00192</span>  <span class=result>-0.05472</span>  <span class=result> 0.04331</span>  <span class=result>-0.01857</span>  <span class=result> 0.04042</span>  <span class=result>-0.03603</span>  <span class=result> 0.00708</span>  <span class=result> 0.73157</span>  <span class=result> 0.09019</span> 
        handWell | <span class=result> 0.05847</span>  <span class=result> 0.03381</span>  <span class=result> 0.53157</span>  <span class=result>-0.02575</span>  <span class=result>-0.04835</span>  <span class=result>-0.18564</span>  <span class=result>-0.12188</span>  <span class=result>-0.09233</span>  <span class=result> 0.01159</span>  <span class=result>-0.00774</span>  <span class=result>-0.13751</span>  <span class=result> 0.15259</span> 
     treadlePump | <span class=result> 0.05162</span>  <span class=result>-0.00012</span>  <span class=result>-0.06616</span>  <span class=result>-0.06678</span>  <span class=result>-0.03356</span>  <span class=result> 0.01523</span>  <span class=result> 0.01315</span>  <span class=result>-0.02304</span>  <span class=result>-0.02065</span>  <span class=result> 0.02825</span>  <span class=result>-0.09897</span>  <span class=result>-0.77505</span> 
       rowerPump | <span class=result>-0.04025</span>  <span class=result>-0.03089</span>  <span class=result>-0.02218</span>  <span class=result>-0.01251</span>  <span class=result>-0.06747</span>  <span class=result> 0.01546</span>  <span class=result>-0.02287</span>  <span class=result> 0.00389</span>  <span class=result> 0.03586</span>  <span class=result> 0.78999</span>  <span class=result>-0.00398</span>  <span class=result>-0.03900</span> 
             llp | <span class=result> 0.01071</span>  <span class=result> 0.05228</span>  <span class=result>-0.01054</span>  <span class=result>-0.17748</span>  <span class=result> 0.04730</span>  <span class=result>-0.05734</span>  <span class=result> 0.14188</span>  <span class=result> 0.04264</span>  <span class=result> 0.64330</span>  <span class=result>-0.04912</span>  <span class=result>-0.03918</span>  <span class=result> 0.00133</span> 
       stubeWell | <span class=result> 0.07320</span>  <span class=result> 0.21732</span>  <span class=result>-0.01958</span>  <span class=result> 0.12581</span>  <span class=result> 0.00790</span>  <span class=result> 0.06814</span>  <span class=result>-0.01986</span>  <span class=result> 0.24441</span>  <span class=result>-0.04491</span>  <span class=result> 0.05778</span>  <span class=result>-0.25938</span>  <span class=result>-0.01594</span> 
       dtubeWell | <span class=result>-0.03385</span>  <span class=result>-0.06977</span>  <span class=result> 0.00000</span>  <span class=result>-0.02809</span>  <span class=result> 0.02179</span>  <span class=result>-0.03217</span>  <span class=result> 0.68075</span>  <span class=result>-0.01108</span>  <span class=result>-0.03736</span>  <span class=result>-0.05605</span>  <span class=result>-0.00914</span>  <span class=result>-0.03254</span> 
        elecPump | <span class=result>-0.09206</span>  <span class=result> 0.05767</span>  <span class=result> 0.40834</span>  <span class=result> 0.11036</span>  <span class=result>-0.06618</span>  <span class=result> 0.08302</span>  <span class=result> 0.27636</span>  <span class=result>-0.06065</span>  <span class=result>-0.05224</span>  <span class=result> 0.24018</span>  <span class=result> 0.05645</span>  <span class=result>-0.01010</span> 
      dieselPump | <span class=result>-0.04527</span>  <span class=result> 0.05983</span>  <span class=result>-0.05530</span>  <span class=result> 0.52110</span>  <span class=result>-0.04619</span>  <span class=result> 0.04960</span>  <span class=result> 0.04123</span>  <span class=result> 0.21196</span>  <span class=result>-0.17949</span>  <span class=result>-0.02568</span>  <span class=result>-0.00300</span>  <span class=result> 0.00284</span> 
     elecSprayer | <span class=result>-0.01123</span>  <span class=result> 0.01506</span>  <span class=result> 0.01417</span>  <span class=result>-0.08759</span>  <span class=result> 0.00641</span>  <span class=result>-0.12335</span>  <span class=result> 0.20489</span>  <span class=result> 0.46501</span>  <span class=result> 0.07803</span>  <span class=result>-0.02754</span>  <span class=result> 0.27395</span>  <span class=result> 0.12861</span> 
       harvester | <span class=result> 0.00933</span>  <span class=result>-0.16726</span>  <span class=result>-0.13480</span>  <span class=result>-0.06311</span>  <span class=result>-0.00070</span>  <span class=result> 0.15309</span>  <span class=result>-0.09872</span>  <span class=result> 0.42274</span>  <span class=result>-0.00019</span>  <span class=result> 0.04283</span>  <span class=result>-0.12071</span>  <span class=result> 0.34455</span> 
    --------------------------------------------------------------------------------------------------------------------------------------
<br><br>
<br><br>
<span class=input>. alpha kaste-harvester</span>
<br><br>
Test scale = mean(unstandardized items)
<br><br>
Average interitem covariance:    <span class=result> .0046155</span>
Number of items in the scale:    <span class=result>       27</span>
Scale reliability coefficient:   <span class=result>   0.5754</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Plot loadings for review</span>
<span class=input>. qui loadingplot, mlabs(small) mlabc(maroon) mc(maroon) /*</span>
<span class=input>&gt;         */ xline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*</span>
<span class=input>&gt;         */ yline(0, lwidth(med) lpattern(tight_dot) lcolor(gs10)) /*</span>
<span class=input>&gt;         */ title(Household wealth ag index loadings)</span>
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
(note:  named style med not found in class linewidth, default attributes used)
(note:  linewidth not found in scheme, default attributes used)
<br><br>
<span class=input>. qui graph export "$pathgraph/agwealthLoadings.png", as(png) replace</span>
<br><br>
<span class=input>. qui scree, title(Scree plot of ag wealth index)</span>
<br><br>
<span class=input>. qui graph export "$pathgragh/agwealthScree.png", as(png) replace</span>
<br><br>
<span class=input>. </span>
<span class=input>. * Merge durables with agricultural implement assets</span>
<span class=input>. merge 1:1 a01  using "$pathout/hhdurables.dta", gen(assets)</span>
<br><br>
    Result                           # of obs.
    -----------------------------------------
    not matched              <span class=result>               0</span>
    matched                  <span class=result>           6,503</span>  (assets==3)
    -----------------------------------------
<br><br>
<span class=input>. </span>
<span class=input>. compress</span>
<span class=result>  </span>kaste was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nirani was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ladder was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>rake was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ploughYoke was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>reaper was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>sprayer was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>wheelbarrow was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>bullockCart was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>pushCart was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>tractor was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>tiller was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>trolley was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>thresher was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>fodderMachine was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>swingBasket was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>Don was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>handWell was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>treadlePump was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>rowerPump was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>llp was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>stubeWell was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>dtubeWell was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>elecPump was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>dieselPump was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>elecSprayer was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>harvester was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ntrunk was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nbucket was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nstove was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ncookpots was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nbed was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ncabinet was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ntableChairs was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nhukka was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nfan was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>niron was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nradio was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ncd was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nclock was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ntvbw was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ntvclr was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ngold was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nsew was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nbike was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nrickshaw was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nvan was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nboat was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nelecboat was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nmoto was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nmobile was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nlandphone was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nthresher was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nmill was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nranda was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nsaw was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nhammer was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>npatkoa was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nfishnet was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nspade was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>naxe was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nshovel was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nshabol was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ndaa was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nhorse was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nmule was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ndonkey was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>nsolar was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>ngenerator was <span class=result>float</span> now <span class=result>byte</span>
<span class=result>  </span>hhDurablesValue was <span class=result>double</span> now <span class=result>long</span>
  (1,372,133 bytes saved)
<br><br>
<span class=input>. save "$pathout/hhpc.dta", replace</span>
file U:\Bangladesh\Dataout/hhpc.dta saved
<br><br>
<span class=input>. erase "$pathout/hhdurables.dta"</span>
<br><br>
</pre>
</body>
</html>
