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
# Underweight women
# ! pull out breastfeeding b/c redundant w/ age.  No variation.
#!!! Illness-- is it kosher to convert everything to 0s?  How deal w/ low #s of NAs?


# Define variables within model
demogHH = c('farmOccupHoh', 'religHoh', 'marriedHead', 'femhead', 'agehead',
            'hhsize', 'depRatio', 'roomsPC',
            'sexRatio', 'fem10_19',  'femCount20_34' ,'femCount35_59',
            'under24Share', 'under15Share', 
            "femWork" , 
            
            # removed b/c missing data.
            # "divorceThreat",       "anotherWife",
            # "verbalAbuse", "physicalAbuse", 'femMoneyDecis',     
           # "femWorkMoney", 
           
            'mlabor', 'flabor', 'migration', 'occupSpouseHwife', 'singleHead')
edu = c('literateHead', 'educAdultM_cat012', 'educAdultF_cat012'
        # Removed b/c redundant
        # 'educHoh', 
        # 'educSpouse', 
        # 'readOnlyHead'
        )

demogChild = c('gender', 'ageMonths', 'firstBorn', 
               'totChild', 'notFirstBorn', 'birthGap24Mos',
               'childCount')

shk = c('medexpshkR', 'priceshkR', 'agshkR', 'hazardshkR')

assets = c('dfloor', 'electricity',  'mobile', 'wealthIndex', 
           'savings', 'loans',
           'TLUtotal', 'landless', 'logland', 
           'fishes')
           # , 'orgFert', 'pesticides') # Note: everyone uses some type of inorganic fertilizers somewhere.

geo = c('ftfzone', 'distHealth', 'distRoad', 'distMarket', 'div_name', 'intDate'
        )

nutrit = c('breastFed', 'FCS', 'dietDiv', 'foodLack', 'sleepHungry', 'noFood')

health = c('latrineSealed', 'treatWater',  "waterSource",
           "privateWater", "publicWater", "treatWater",
           "garbage")

varsYounguns = c('diarrhea', 
           'fever',  'cough', 'throatInfect',
           'rash',"useColostrum",         "giveWaterifHot",       "washHandsToilet",     
           "washHandsPoopyBaby",   "washHandsEat",         "washHandsFeedKids",   
           "washScore",            "BFwi1h",               "feedOnlyMilk",        
           "feedEnoughFood",       "feedProtein",          "feedingScore",        
           "antenatalCare",        "prenatFeedPgrm",       "tetVacWhilePreg",     
           "ironWhilePreg",        "vitAafterPreg",           
           "bornAtHome"
           # Removed b/c too few obs.
           # 'coughHH', 'rashHH',  'wtLoss', 'wtLossHH',
#            'feverHH','throatHH', 'diarrheaHH',
#            ,              "inorgFert",            "totInorg",            
#            "orgFert",              "totPesticides",        "pesticides" 
           )


child = child %>% 
  mutate(gender = factor(gender, levels = c(0,1)), # relative to males
         ftfzone = factor(ftfzone, levels = c(0,1)), # relative to not FtF
         educAdultF_cat012 = factor(educAdultF_cat012, 
                                    levels = c('no education',
                                               'primary', 'secondary+')),
         educAdultM_cat012 = factor(educAdultM_cat012, 
                                    levels = c('no education',
                                               'primary', 'secondary+')),# relative to no ed
         religHoh = factor(religHoh, levels = c(0,1)), # relative to Muslim
         div_name = factor(div_name, levels = c('Khulna','Dhaka', 'Barisal',
                                                'Rangpur', 'Chittagong','Rajshahi', 'Sylhet')) # relative to Khulna, lowest male (and overall) stunting.
  ) 



vars2test = c(demogHH, edu, demogChild, shk, assets, geo, nutrit, health)
  
# vars2test = assets
stunted = child %>% 
  filter(!is.na(stunted)) %>% 
  dplyr::select(one_of(c('stunted', vars2test)))


#? wlth index cont?  factor?

# Check to make sure data are complete.
stunted = na.omit(stunted)
any(is.na(stunted))

stuntedRegr = glm(stunted ~ ., data = stunted, family = binomial)


stuntedRegr = glm(stunted ~ ., data = stunted, family = binomial(link = "logit"))


broom::tidy(stuntedRegr) %>% 
  mutate(signif = p.value < 0.05)


# MASS refinement of vars -------------------------------------------------
stuntedRegr2 = stepAIC(stuntedRegr, direction = 'both')

# starting 3227.1


# coefplot(stuntedRegr)

# Things that have shown up: 
# fcs, breast feeding, mobiles, priceshk, childCt, firstborn,
# age months, educ, flabor, domestic shit, # females, hhsize


# stunting, under 2’s -----------------------------------------------------
vars2test = c(demogHH, edu, demogChild, shk, 
              assets, geo, nutrit, health, varsYounguns)

stunted2y = child %>% 
  filter(!is.na(stunted),
         ageMonths < 25) %>% 
  select(one_of(c('stunted', vars2test)))

# Check to make sure data are complete.
stunted2y = na.omit(stunted2y)
any(is.na(stunted2y))

stunted2yRegr = glm(stunted ~ ., data = stunted2y, family = binomial(link = "logit"))

library(MASS)
stunted2yRegr2 = stepAIC(stunted2yRegr, direction = 'both')


broom::tidy(stuntedRegr) %>% 
  mutate(signif = p.value < 0.05)

# wasting -----------------------------------------------------------------

wasted = child %>% 
  filter(!is.na(wasted),
         ageMonths< 25) %>% 
  select(one_of(c('wasted',vars2test)))

# Check to make sure data are complete.
wasted = na.omit(wasted)
any(is.na(wasted))

wastedRegr = glm(wasted ~ ., data = wasted, family = binomial)

wastedRegr = glm(wasted ~ ., data = wasted, family = binomial(link = "logit"))

summary(wastedRegr)

broom::tidy(wastedRegr) %>% 
  mutate(signif = p.value < 0.05)
# Prelim: ftf, firstborn, eduF, domestic shit

wastedRegr2 = stepAIC(wastedRegr, direction = 'both')

# underweight -----------------------------------------------------------------

underwgt = child %>% 
  filter(!is.na(underwgt)) %>% 
  select(one_of(c('underwgt',vars2test)))

# Check to make sure data are complete.
underwgt = na.omit(underwgt)
any(is.na(underwgt))

underwgtRegr = glm(underwgt ~ ., data = underwgt, family = binomial)

underwgtRegr = glm(underwgt ~ ., data = underwgt, family = binomial(link = "logit"))


broom::tidy(underwgtRegr) %>% 
  mutate(signif = p.value < 0.05)
# Prelim: dirt, priceshk, childct, childtot, age, eduSp, flabor

underwgtRegr2 = stepAIC(underwgtRegr, direction = 'both')