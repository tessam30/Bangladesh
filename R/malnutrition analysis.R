# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')

# Import plotting functions -----------------------------------------------
source('~/GitHub/Bangladesh/R/reusablePlots.r')

# FtF t-tests  ------------------------------------------------------------

ctrl = child %>% 
  filter(hh_type == 2, !is.na(stunted)) %>%
  select(stunted)

# stunted -----------------------------------------------------------------


ftf = child %>% 
  filter(hh_type == 1, !is.na(stunted)) %>% 
  select(stunted)

ftf = as.matrix(ftf)

ctrl = as.matrix(ctrl)

s = broom::tidy(t.test(ctrl, ftf))





# wasted ------------------------------------------------------------------
ctrl = child %>% 
  filter(hh_type == 2, !is.na(wasted)) %>%
  select(wasted)

ftf = child %>% 
  filter(hh_type == 1, !is.na(wasted)) %>% 
  select(wasted)

ftf = as.matrix(ftf)

ctrl = as.matrix(ctrl)

w = broom::tidy(t.test(ctrl, ftf))


# underwgt ------------------------------------------------------------------
ctrl = child %>% 
  filter(hh_type == 2, !is.na(underwgt)) %>%
  select(underwgt)

ftf = child %>% 
  filter(hh_type == 1, !is.na(underwgt)) %>% 
  select(underwgt)

ftf = as.matrix(ftf)

ctrl = as.matrix(ctrl)

u = broom::tidy(t.test(ctrl, ftf))




# model for stunting ------------------------------------------------------
# Initial model, throwing everything at it.

# To do: set levels categories of adult educ and other categorical vars; 
# import in TLU-trimmed
# convert tert ed to sec+
# Deal w/ first-borns
# totChild and hhsize redudant? under...
# ?? what's educ?
# calc rooms pc
# Pull in: HFIAS, (X3)
# health: infections, diahrrhea, etc. (W4)
# fertilizer use. (H3)
# Eliminate vars w/ low variation.
# Underweight women
# Y1_01: where child delivered
# Y1_04: more breastfeeding info (first 3 days)
# Y1_05: formula
# Y1_06: still breastfeeding
# Y1_07: age stop breastfeeding
# Y1_09: age introduce foods
# Y1_10: amt breastfed
# Y1_11: milk prods
# Y1_12: amt ate
# Y1_13: food kid recall
# Y1_18: sprinkles, 20, 21
# 30, 35: who used micronutrient mixes
# Y2: nutrition knowledge, health !**!!
# Y4: immunizations
# Y5_01: antenatal sessions, 04: feeding pgrm when pregn.
# Y5_06: weeks addit food, preg. behavior + others
# Y8-- health advice
# Z3-01: used birth ctrl


# Define variables within model
demogHH = c('stunted', 'farmOccupHoh', 'religHoh', 'marriedHead', 'femhead', 'agehead',
            'hhsize', 'depRatio', 'sexRatio', 'fem10_19',  'femCount20_34' ,'femCount35_59',
            'under24Share', 'under15Share', "divorceThreat",       "anotherWife",
            "verbalAbuse", "physicalAbuse", 'femMoneyDecis',     
           "femWork" ,  "femWorkMoney", 
            'mlabor', 'flabor', 'migration', 'occupSpouseHwife', 'singleHead')
edu = c('literateHead', 'educAdultM_cat', 'educAdultF_cat', 
        'educHoh', 'educSpouse', 'readOnlyHead')
demogChild = c('gender', 'ageMonths', 'firstBorn', 'totChild', 'notFirstBorn', 'birthGap24Mos',
               'childCount')
shk = c('medexpshkR', 'priceshkR', 'agshkR', 'hazardshkR')
assets = c('dfloor', 'electricity',  'mobile', 'wealthIndex', 'TLUtotal', 'landless', 'logland')
geo = c('ftfzone', 'distHealth', 'distRoad', 'distMarket', 'divName', 'intDate',
        'savings', 'loans')
nutrit = c('breastFed', 'FCS', 'dietDiv')
health = c('latrineSealed', 'treatWater',  "waterSource",
           "privateWater",     "publicWater",      "treatWater",
           "waterArsenicTest", "garbage")

vars2test = c(demogHH, edu, demogChild, shk, assets, geo, nutrit, health)
  

stunted = child %>% 
  filter(!is.na(stunted)) %>% 
  select(one_of(vars2test))

# Check to make sure data are complete.
any(is.na(stunted))

stuntedRegr = glm(stunted ~ ., data = stunted, family = binomial)

stuntedRegr = glm(stunted ~ ., data = stunted, family = binomial(link = "logit"))


broom::tidy(stuntedRegr) %>% 
  mutate(signif = p.value < 0.05)


# coefplot(stuntedRegr)

# Things that have shown up: 
# fcs, breast feeding, mobiles, priceshk, childCt, firstborn,
# age months, educ, flabor, domestic shit, # females, hhsize
