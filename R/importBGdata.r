# -------------------------------------------------------------------------
# Function to import, clean, and load in useful things for analysis of
# Bangladesh Livelihoods.
# 
# Laura Hughes, lhughes@usaid.gov, September 2015
# -------------------------------------------------------------------------


# Import data -------------------------------------------------------------

source('~/GitHub/Bangladesh/R/setupFncnsBG.r')

# -- Read in data --
bg = read_dta('~/Documents/USAID/Bangladesh/Data/BGD_20150921_LAM.dta')

# Calculate rooms per capita
bg = bg %>% 
  mutate(roomsPC = totRooms / hhsize,
         educAdultM_cat012 = ifelse(femhead == 1, 'no education',
                                    ifelse(educAdultM_18 %in% c(0,1), 'no education',
                                           ifelse(educAdultM_18 == 2, 'primary',
                                                  ifelse(educAdultM_18 %in% c(3:6), 'secondary+',
                                                         NA)))),
         educAdultF_cat012 = ifelse(educAdultF_18 %in% c(0,1), 'no education',
                                    ifelse(educAdultF_18 == 2, 'primary',
                                           ifelse(educAdultF_18 %in% c(3:6), 'secondary+',
                                                  'no education')))
  )


child = read_dta('~/Documents/USAID/Bangladesh/Data/ChildHealth_ind.dta')



# Merge children with hh-level data ---------------------------------------------------------------

child = child %>% 
  mutate(stuntedBin = ifelse(stunted == 1, 1, 0), # Removing NAs to get an aggregate number
         underwgtBin = ifelse(underwgt == 1, 1, 0),
         wastedBin = ifelse(wasted == 1, 1, 0),
         malnourished = stuntedBin + underwgtBin + wastedBin)

recodeChildOrder = data.frame(key = 1:10, c('first born', 'second born', 'third born', 'fourth+ born', 'fourth+ born',
                                            'fourth+ born', 'fourth+ born', 'fourth+ born', 'fourth+ born', 'fourth+ born'))

child = code2Cat(df = child, dict = recodeChildOrder, 
                 newVar = 'childOrderCat', oldVar = 'childCount') # Categorical variable, lumping in all kids that are 4th or higher child.

# Should be 2911 unique children.

child = left_join(child, bg,  
                  c("a01", "div_name", "District_Name", "Upazila_Name", 
                    "Union_Name", "hh_type", "a16_dd", "a16_mm", "a16_yy"))


# merge children w/ illness (W4) data -------------------------------------

source('~/GitHub/Bangladesh/R/importOtherMods.R')

child = left_join(child, illness, by = c("a01", "mid"))


# merge children w/ food security (X3) data -------------------------------------

child = left_join(child, foodSec, by = c("a01"))


# merge children w/ micronutrient info (Y1) -------------------------------
child = left_join(child, micronut, by = c("a01", 'mid'))


# merge children w/ nutritional knowledge data (Y2) -----------------------
child = left_join(child, nutKnowl, by = c("a01"))



# merge children w/ knowledge about nutrition (Y3) ------------------------
child = left_join(child, feeding, by = c("a01"))


# merge children w/ prenatal care (Y5) ------------------------------------

child = left_join(child, prenatal, by = c("a01", "mid"))


# merge children w/ health pgrms (Y8) --------------------------------------
child = left_join(child, healthWorkers, by = c("a01"))


# merge children w/ fish production (L1) ----------------------------------
child = left_join(child, fish, by = c("a01"))

bg = left_join(bg, fish, by = c("a01"))

# !!! Assumes if not in mod L1, doesn't fish.
child = child %>% 
  mutate(fishes = ifelse(is.na(fishes), 0, 1),
         fishArea = ifelse(is.na(fishArea), 0, fishArea),
         fishOpenWater = ifelse(is.na(fishOpenWater), 0, 1),
         fishAreaDecile = ifelse(is.na(fishAreaDecile), 0, fishAreaDecile))



# merge children w/ fertilizer use ----------------------------------------
child = left_join(child, fertilizer, by = c("a01"))

ggplot(child, aes(x = totPesticides, y = stunted)) +
  stat_summary(fun.y = mean, geom = 'point', size = 5)+
  stat_smooth(method = "loess", size = 0.9, span = 0.5, fill = NA) +
  theme_jointplot()

# merge children w/ tobacco use ----------------------------------------
child = left_join(child, tobacco, by = c("a01"))
# UGH.  NO NAs.


# shocks by time, coping -----------------------------------------------------------------
# ! Note!  Using the .dta file, not the publicly available one, since that shock
# module does not include hh that didn't report a shock.

t1_raw = read_dta('~/Documents/USAID/Bangladesh/Data/male_mod_t1_002.dta')

nHH = length(unique(t1_raw$a01))

shk = removeAttributes(t1_raw) %>% 
  mutate(month = t1_04, year = t1_05, shkCode = t1_02,
         month = ifelse(month < 10, sprintf('%02d', month), month),
         time = ymd(paste0(year, month, '01')),
         shk = ifelse(t1_03 == 0, 0, 
                      ifelse(t1_03 > 0, 1, NA)),
         shkCat = 
           ifelse(shkCode %in% c(3,4), 'medexp',
                  ifelse(shkCode %in% c(9, 10, 11, 12, 13), 'ag',
                         ifelse(shkCode %in% c(14, 15, 16, 17), 'asset2',
                                ifelse(shkCode == 32, 'price', 
                                       ifelse(shkCode  %in% c(6, 9, 10, 11, 14, 16), 'hazard', 'other'))))),
         cope1 = t1_08a, cope2 = t1_08b, cop3 = t1_08c,
         goodCope = cope1 %in% c( 6, 7, 8, 9, 13, 19, 20, 21, 22, 23, 24),
         badCope = cope1 %in% c(2, 3, 4, 5, 10, 11, 12, 14, 15, 16, 17, 18),
         copeClass = ifelse(goodCope == 1, 'good',
                            ifelse(badCope == 1, 'bad',
                                   ifelse(cope1 == 1, 'none', NA))),
         shkValue = t1_07, shkLength = t1_09, shkValPerDay = shkValue / shkLength
  )

dict = data.frame(key = 1:25, value = c('none',
                                        'sold land',
                                        'mortgaged land',
                                        'sold productive asset',
                                        'mortgaged productive asset',
                                        'sold consumption asset',
                                        'mortgaged consumption asset',
                                        'took loan from NGO',
                                        'took loan from mahajan',
                                        'ate less food',
                                        'ate lower quality food',
                                        'removed kids from school',
                                        'transferred kids to cheaper school',
                                        'temporarily took different job',
                                        'sent hh member away permanently',
                                        'sent kids to relatives',
                                        'sent kids to domestic service',
                                        'sent kids to work',
                                        'sent wife and kids to family',
                                        'emergency receipt of remittance from family',
                                        'forced to change occupation',
                                        'moved to cheaper house',
                                        'non-working hh member took job',
                                        'took help from others',
                                        'other'
))

shk = code2Cat(shk, dict, 'cope1', 'cope1Cat')

# by freq. of coping mechanisms, sorted by good/bad shk
shk$cope1Cat = factor(shk$cope1Cat,
                      rev(c( 'took loan from mahajan',                      'took help from others',                      
                             'took loan from NGO',                          'sold consumption asset',                     
                             'emergency receipt of remittance from family', 'mortgaged consumption asset',                
                             'non-working hh member took job', 'forced to change occupation',                
                             'sent wife and kids to family',   
                             'none',
                             'ate less food',                   'mortgaged land',                  'sold productive asset',          
                             'sold land',                       'ate lower quality food',          'mortgaged productive asset',     
                             'temporarily took different job', ' removed kids from school',        'sent hh member away permanently',
                             'sent kids to work',               'sent kids to domestic service',   'sent kids to relatives')))

# Sorted by median for med shks, grouped by good/bad

shk$cope1Cat = factor(shk$cope1Cat,
                      c('forced to change occupation', 
                        'sold consumption asset', 
                        'mortgaged consumption asset', 
                        'emergency receipt of remittance from family', 
                        'non-working hh member took job', 
                        'took help from others', 
                        'took loan from NGO', 
                        'took loan from mahajan',
                        'none',
                        'sold land', 
                        'mortgaged land', 
                        'mortgaged productive asset', 
                        'sold productive asset', 
                        'ate less food', 
                        'ate lower quality food',  
                        'sent kids to relatives'))  

# Sorted by median for med shks
shk$cope1Cat = factor(shk$cope1Cat,
                      rev(c(                                    'sold land', 
                                                                
                                                                'sold consumption asset', 
                                                                'mortgaged land', 
                                                                'mortgaged consumption asset', 
                                                                'emergency receipt of remittance from family', 
                                                                'mortgaged productive asset', 
                                                                'non-working hh member took job', 
                                                                'sold productive asset', 
                                                                'took help from others ',
                                                                'took loan from NGO', 
                                                                'took loan from mahajan', 
                                                                'ate less food', 
                                                                'forced to change occupation',
                                                                'none', 
                                                                'ate lower quality food',  
                                                                'sent kids to relatives')))

# -- Merge in with interesting categories from the household set
shk = full_join(shk, bg, by = 'a01')

# Recent shocks in the past 2 y.
# ! Note: filters out hh without a shock.
shkR = shk %>% 
  filter(year > 2009) %>% 
  mutate(logShkVal = log10(shkValue))

