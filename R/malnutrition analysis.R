# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')

# Import plotting functions -----------------------------------------------
source('~/GitHub/Bangladesh/R/reusablePlots.r')






# model for stunting ------------------------------------------------------
# Initial model, throwing everything at it.

# To do: set levels categories of adult educ and other categorical vars; 
# convert tert ed to sec+
# Deal w/ first-borns
# totChild and hhsize redudant? under...
# ?? what's educ?
# calc rooms pc
# Underweight women
# ! pull out breastfeeding b/c redundant w/ age.  No variation.
#!!! Illness-- is it kosher to convert everything to 0s?  How deal w/ low #s of NAs?


# factor-ize variables ----------------------------------------------------

child = child %>% 
  mutate(gender = factor(gender, levels = c(0,1)), # relative to males
         ftfzone = factor(ftfzone, levels = c(0,1)), # relative to not FtF
         educAdultF_cat012 = factor(educAdultF_cat012, 
                                    levels = c('no education',
                                               'primary', 'secondary+')),
         educAdultM_cat012 = factor(educAdultM_cat012, 
                                    levels = c('no education',
                                               'primary', 'secondary+')),# relative to no ed
         houseQual = factor(houseQual, levels = 1:5), # relative to no damage
         houseAge = factor(houseAge, levels = 1:5), # relative to 0 - 5y
         religHoh = factor(religHoh, levels = c(0,1)), # relative to Muslim
         childOrderCat = factor(childOrderCat, 
                                levels = c('first born', 'second born', 'third born', 'fourth+ born')), # birth order, relative to first borns.
         waterSource = factor(waterSource, levels = c(3,1,2,4:11)),
         div_name = factor(div_name, levels = c('Khulna','Dhaka', 'Barisal',
                                                'Rangpur', 'Chittagong','Rajshahi', 'Sylhet')) # relative to Khulna, lowest male (and overall) stunting.
  ) 



# Define variables for models ---------------------------------------------
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
        # Removed b/c redundant and/or have too many blanks
        # 'educHoh', 
        # 'educSpouse', 
        # 'readOnlyHead'
        )

demogChild = c('gender', 'ageMonths',
               'totChild',  
               # Needs fixin'
               # 'birthGap24Mos',
               'childOrderCat')

shk = c('medexpshkR', 'priceshkR', 'agshkR', 'hazardshkR')


# Note: running either wealthIndex, or the components which are disaggregated (+ categorical waterSource instead of private water)
wealth = c('waterAccess', 'latrineSealed',  'ownHouse', 'houseAge', 'houseQual',
           'brickTinHome', 'mudHome', 'metalRoof', 'dfloor', 'electricity', 'mobile', 'kasteOwn', 'niraniOwn', 
           'trunk', 'bucket', 'bed', 'cabinet',
           'tableChairs', 'fan', 'iron', 'radio', 'cd', 'clock', 'tvclr', 'gold', 'bike' ,
           'moto', 'saw', 'hammer', 'fishnet', 'spade', 'axe', 'shabol', 'waterSource') # or 'privateWater')

# wealth = 'wealthIndex'

assets = c(wealth,  
           'savings', 'loans',
           'TLUtotal_trim', 'landless', 'logland', 
           'fishes', 'fishAreaDecile')

# too few data pts.
           # , 'orgFert', 'pesticides') # Note: everyone uses some type of inorganic fertilizers somewhere.

geo = c('ftfzone', 'distHealth', 'distRoad', 'distMarket', 'div_name', 'intDate'
        )

nutrit = c('breastFed', 'FCS', 'dietDiv', 'foodLack', 'sleepHungry', 'noFood')

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
           )





vars2test = c(demogHH, edu, demogChild, shk, assets, geo, nutrit)
  
# vars2test = wealth
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
              assets, geo, nutrit, varsYounguns)

stunted2y = child %>% 
  filter(!is.na(stunted),
         ageMonths < 25) %>% 
  select(one_of(c('stunted', vars2test)))

# Check to make sure data are complete.
stunted2y = na.omit(stunted2y)
any(is.na(stunted2y))

stunted2yRegr = glm(stunted ~ ., data = stunted2y, family = binomial(link = "logit"))

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



# -------------------------------------------------------------------------
# -------------------------------------------------------------------------

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
