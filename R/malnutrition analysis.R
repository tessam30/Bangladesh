# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')

# Import plotting functions -----------------------------------------------
source('~/GitHub/Bangladesh/R/reusablePlots.r')






# model for stunting ------------------------------------------------------
# Overall procedue:
# 1. Initial logit model, throwing everything at it that is more or less complete in vars.
#    When there are options for 
# 2. Refine w/ stepAIC
# 3. Add back in demographic vars to control for regions, hhsize, intDate.
# 4. Re-run, clustering at th hh-level.
# 5. Try with some interesting variables that aren't complete datasets:
#    - hh-level disease
#    - under 2 subset + associated vars.
#    - female abuse.
#    - ag inputs.



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
                                                'Rangpur', 'Chittagong','Rajshahi', 'Sylhet')), # relative to Khulna, lowest male (and overall) stunting.
        occupHoh = factor(occupHoh, levels = c(8, 1:7, 9)), # relative to farming
         intDate = factor(intDate, levels = c(4, 1:3, 5,6)) # relative to January, most frequent in all sample
           ) 



# Define variables for models ---------------------------------------------
demogHH = c('religHoh', 'marriedHead', 'femhead', 'agehead',
            'hhsize', 'roomsPC',
            'sexRatio',   'femCount20_34' ,'femCount35_59',
            'under15Share', "femWork" , 
            # removed b/c missing data.
            # "divorceThreat",       "anotherWife",
            # "verbalAbuse", "physicalAbuse", 'femMoneyDecis',     
           # "femWorkMoney", 
           
           # Removed b/c redundant
           # 'depRatio', 'totChild', 'under24Share', 
           
            'mlabor', 'flabor', 'migration', 'occupHoh', 'farmOccupHoh',
           'occupSpouseHwife', 'occupSpouseChx', 'occupSpouseLvstk', 'singleHead')
# farmOccupHoh', 

edu = c('literateHead', 'educAdultM_cat012', 'educAdultF_cat012'
        # Removed b/c redundant and/or have too many blanks
        # 'educHoh', 
        # 'educSpouse', 
        # 'readOnlyHead'
        )

demogChild = c('gender', 'ageMonths',
               'firstBorn',
               # interesting, but only available for subset kids where sibling is < 5 y old.
               # 'birthGap24Mos',
               'childOrderCat')

shk = c('medexpshkR', 'priceshkR', 'agshkR', 'hazardshkR')

# Note: running either wealthIndex, or the components which are disaggregated (+ categorical waterSource instead of private water)
durGoods = c('mobile', 'kasteOwn', 'niraniOwn', 
             'trunk', 'bucket', 'bed', 'cabinet',
             'tableChairs', 'fan', 'iron', 'radio', 'cd', 'clock', 'tvclr',
             'bike', 'moto', 'saw', 'hammer', 'fishnet', 'spade', 'axe', 'shabol')


wealth = c('latrineSealed',  'ownHouse', 'houseAge', 'houseQual',
           'brickTinHome', 'mudHome', 'metalRoof', 'dfloor', 'electricity', 
            'gold',  'waterSource', 'privateWater' , 'waterAccess')

# wealth = 'wealthIndex'

assets = c(wealth,  
           'savings', 'loans',
           'TLUtotal_trim', 'landless', 'logland', 
           'fishes', 'fishAreaDecile', 'fishOpenWater')

# too few data pts.
           # , 'orgFert', 'pesticides') # Note: everyone uses some type of inorganic fertilizers somewhere.

geo = c('ftfzone', 'distHealth', 'distRoad', 'distMarket', 'div_name', 'intDate'
        )

nutrit = c('FCS', 'dietDiv', 'foodLack', 'sleepHungry', 'noFood'
           
           # Removing b/c almost no variation until hit 18 mo. 
           # At ages < 18 mo., breast feeding rates are > 90%.
           # 'breastFed', 
           )

health = c()
# Not available for all hh; will add in later.
# 'coughHH', 'rashHH',  'wtLoss', 'wtLossHH',
#                       'feverHH','throatHH', 'diarrheaHH')

varsYounguns = c('diarrhea', 'coughHH', 'rashHH',  'wtLoss', 'wtLossHH',
                 'feverHH','throatHH', 'diarrheaHH',
                 'fever',  'cough', 'throatInfect',
                 'rash',"useColostrum",         "giveWaterifHot",       "washHandsToilet",     
                 "washHandsPoopyBaby",   "washHandsEat",         "washHandsFeedKids",   
                 "washScore",            "BFwi1h",               "feedOnlyMilk",        
                 "feedEnoughFood",       "feedProtein",          "feedingScore",        
                 "antenatalCare",        "prenatFeedPgrm",       "tetVacWhilePreg",     
                 "ironWhilePreg",        "vitAafterPreg",           
                 "bornAtHome", 'healthWorkerCame', 'receivedNutAdvice', 'gotHealthAdvice'
           # Removed b/c too few obs., all same.
           # ,              "inorgFert",            "totInorg",            
           )



# Decide which of overlapping vars to include -----------------------------
# 1) wealth
# Decided to disintangle wealth variables into components of wealth, to probe 
# for the relative importance of those variables, including WASH variables and
# infrastructure.  Durable goods lumped together to give a general purchasing power
# (created through a PCA of durable goods)

# 2) hhsize / # children, etc.
# potentially redundant:             'hhsize', 'roomsPC',
# 'depRatio', 'sexRatio', 'fem10_19',  'femCount20_34' ,'femCount35_59',
# 'under24Share', 'under15Share', 'totChild'
x = child  %>% 
  filter(!is.na(stunted))  %>% 
  select(hhsize, roomsPC, depRatio, sexRatio, femCount20_34, 
         femCount35_59, under24Share, under15Share, totChild)

cor(x)
cov(x)

# childTotal and hhSize strongly correlated, and depRatio related to under24, under15, and childTotal
# Therefore... running hhsize and under15Ratio.  
# Other vars seem unique enough for first pass.

# 3) In initial model + refinement, all potentially redundant vars included at their most generic level.
#   a) waterAccess, waterSource, privateWater: running waterSource
#   b) fish: fishes (binary if fish or not); fishAreaDecile (doesn't include open water); fishesOpenWater
#   c) occupation of HoH: +/- ag, all categories, or grouped somehow?
#   d) first born or birth order

# 4) breast feeding: in prelim models, it was significant.  HOWEVER, there's little to no
# variation in breast feeding rates until the child is > 18 months, and breastFeeding is 
# strongly correlated with age.  So disregarding.



vars2test = c(demogHH, edu, demogChild, shk, assets, geo, nutrit, health, durGoods)
  
# vars2test = wealth
stunted = child %>% 
  filter(!is.na(stunted)) %>% 
  dplyr::select(one_of(c('stunted', 'a01', 'Union_Name',
                         'latitude', 'longitude', vars2test)))



# Check to make sure data are complete.
stunted = na.omit(stunted)
any(is.na(stunted))
print(paste0('number people removed: ', nrow(child) - nrow(stunted)))

# Creating durable goods index, based on PCA
durGoodsIdx = prcomp(stunted %>% dplyr::select(one_of(durGoods)),
                     center = TRUE, scale. = TRUE)

stunted = stunted %>% 
  mutate(durGoodsIdx = durGoodsIdx$x[,1]) %>% 
  select(-one_of(durGoods))


# MODEL 1: most generic form of redundant vars ----------------------------
stuntedRegr = glm(stunted ~ . 
                  - a01 - firstBorn - waterAccess - privateWater
                  - fishes - Union_Name
                  - latitude - longitude, data = stunted, family = binomial(link = "logit"))


broom::tidy(stuntedRegr) %>% 
  mutate(signif = p.value < 0.05)


# MODEL 2: MASS refinement of vars -------------------------------------------------
stuntedRegr2 = stepAIC(stuntedRegr, direction = 'both')


# MODEL 3: Cluster refinement of vars. ------------------------------------
stuntedRegr3 = glm(formula = stunted ~ marriedHead + femhead + hhsize + roomsPC + 
                     mlabor + flabor + gender + ageMonths + priceshkR + latrineSealed + 
                     brickTinHome + landless + fishAreaDecile + fishOpenWater + 
                     distMarket + intDate + FCS + durGoodsIdx +
                     intDate + hhsize + under15Share + div_name + educAdultM_cat012 + educAdultF_cat012, 
                   data = stunted, family = binomial(link = "logit"))
stuntedRegr3Cl = cl(stunted, stuntedRegr3, stunted$a01)

stuntedRegr3Clunion = cl(stunted, stuntedRegr3, stunted$Union_Name)

# MODEL 4: Sensitivity analysis: first-born -------------------------------
stuntedRegr4 = glm(formula = stunted ~ marriedHead + femhead + hhsize + roomsPC + 
                     mlabor + flabor + gender + ageMonths + priceshkR + latrineSealed + 
                     brickTinHome + landless + fishAreaDecile + fishOpenWater + 
                     distMarket + intDate + FCS + durGoodsIdx + 
                     firstBorn +
                     intDate + hhsize + under15Share + div_name + educAdultM_cat012 + educAdultF_cat012, 
                   data = stunted, family = binomial(link = "logit"))
stuntedRegr4Cl = cl(stunted, stuntedRegr4, stunted$a01)

# Not significant and incr. AIC

# MODEL 5: Sensitivity analysis: private water ----------------------------
stuntedRegr5 = glm(formula = stunted ~ marriedHead + femhead + hhsize + roomsPC + 
                     mlabor + flabor + gender + ageMonths + priceshkR + latrineSealed + 
                     brickTinHome + landless + fishAreaDecile + fishOpenWater + 
                     distMarket + intDate + FCS + durGoodsIdx + 
                     privateWater +
                     intDate + hhsize + under15Share + div_name + educAdultM_cat012 + educAdultF_cat012, 
                   data = stunted, family = binomial(link = "logit"))
stuntedRegr5Cl = cl(stunted, stuntedRegr5, stunted$a01)

# MODEL 6: Sensitivity analysis: occup HoH --------------------------------

stuntedRegr6 = glm(formula = stunted ~ marriedHead + femhead + hhsize + roomsPC + 
                     mlabor + flabor + gender + ageMonths + priceshkR + latrineSealed + 
                     brickTinHome + landless + fishAreaDecile + fishOpenWater + 
                     distMarket + intDate + FCS + durGoodsIdx + 
                     farmOccupHoh +
                     intDate + hhsize + under15Share + div_name + educAdultM_cat012 + educAdultF_cat012, 
                   data = stunted, family = binomial(link = "logit"))
stuntedRegr6Cl = cl(stunted, stuntedRegr6, stunted$a01)

# MODEL 7: Sensitivity analysis: fish -------------------------------------
stuntedRegr7 = glm(formula = stunted ~ marriedHead + femhead + hhsize + roomsPC + 
                     mlabor + flabor + gender + ageMonths + priceshkR + latrineSealed + 
                     brickTinHome + landless + fishes +
                     distMarket + intDate + FCS + durGoodsIdx + 
                     intDate + hhsize + under15Share + div_name + educAdultM_cat012 + educAdultF_cat012, 
                   data = stunted, family = binomial(link = "logit"))
stuntedRegr7Cl = cl(stunted, stuntedRegr7, stunted$a01)

# MODEL 8: recent illnesses -----------------------------------------------
varsHealth = c('coughHH', 'rashHH',  'wtLossHH',
                        'feverHH','throatHH', 'diarrheaHH')

for (i in 1:length(varsHealth)) {
  
  vars2test = c('marriedHead',  'femhead',  'hhsize',  'roomsPC',  
                  'mlabor',  'flabor',  'gender',  'ageMonths',  'priceshkR',  'latrineSealed',  
                  'brickTinHome',  'landless',  'fishAreaDecile', 'fishOpenWater', 
                  'distMarket',  'intDate',  'FCS',   
                  'intDate',  'hhsize',  'under15Share',  'div_name',  'educAdultM_cat012',  'educAdultF_cat012',
                durGoods,
                varsHealth[i])
  

stunted8 = child %>% 
  filter(!is.na(stunted)) %>% 
  dplyr::select(one_of(c('stunted', 'a01', 'latitude', 'longitude', vars2test)))



# Check to make sure data are complete.
stunted8 = na.omit(stunted8)
any(is.na(stunted8))
print(paste0('number people removed: ', nrow(child) - nrow(stunted8)))

# Creating durable goods index, based on PCA
durGoodsIdx = prcomp(stunted8 %>% dplyr::select(one_of(durGoods)),
                     center = TRUE, scale. = TRUE)

stunted8 = stunted8 %>% 
  mutate(durGoodsIdx = durGoodsIdx$x[,1]) %>% 
  select(-one_of(durGoods))


stunted8Regr = glm(stunted ~ . 
                  - a01
                  - latitude - longitude, data = stunted8, family = binomial(link = "logit"))

print(summary(stunted8Regr))
}

# All pretty similar; some slight differences in weighting due to using a subset of the data.
# Only major changes: female education b/c important, and fevers are bad.

# for fun... all the diseases.
vars2test = c('marriedHead',  'femhead',  'hhsize',  'roomsPC',  
              'mlabor',  'flabor',  'gender',  'ageMonths',  'priceshkR',  'latrineSealed',  
              'brickTinHome',  'landless',  'fishAreaDecile', 'fishOpenWater', 
              'distMarket',  'intDate',  'FCS',   
              'intDate',  'hhsize',  'under15Share',  'div_name',  'educAdultM_cat012',  'educAdultF_cat012',
              durGoods,
              varsHealth)


stunted8 = child %>% 
  filter(!is.na(stunted)) %>% 
  dplyr::select(one_of(c('stunted', 'a01', 'latitude', 'longitude', vars2test)))



# Check to make sure data are complete.
stunted8 = na.omit(stunted8)
any(is.na(stunted8))
print(paste0('number people removed: ', nrow(child) - nrow(stunted8)))

# Creating durable goods index, based on PCA
durGoodsIdx = prcomp(stunted8 %>% dplyr::select(one_of(durGoods)),
                     center = TRUE, scale. = TRUE)

stunted8 = stunted8 %>% 
  mutate(durGoodsIdx = durGoodsIdx$x[,1]) %>% 
  select(-one_of(durGoods))


stunted8Regr = glm(stunted ~ . 
                   - a01
                   - latitude - longitude, data = stunted8, family = binomial(link = "logit"))

stuntedRegr8Cl = cl(stunted8, stunted8Regr, stunted8$a01)

# MODEL 9: domestic issues ------------------------------------------------
varsFem  =  c("divorceThreat",       "anotherWife",
  "verbalAbuse", "physicalAbuse", 'femMoneyDecis',     
  "femWorkMoney")

for (i in 1:length(varsFem)) {
  
  vars2test = c('marriedHead',  'femhead',  'hhsize',  'roomsPC',  
                'mlabor',  'flabor',  'gender',  'ageMonths',  'priceshkR',  'latrineSealed',  
                'brickTinHome',  'landless',  'fishAreaDecile', 'fishOpenWater', 
                'distMarket',  'intDate',  'FCS',   
                'intDate',  'hhsize',  'under15Share',  'div_name',  'educAdultM_cat012',  'educAdultF_cat012',
                durGoods,
                varsFem[i])
  
  
  stunted9 = child %>% 
    filter(!is.na(stunted)) %>% 
    dplyr::select(one_of(c('stunted', 'a01', 'latitude', 'longitude', vars2test)))
  
  
  
  # Check to make sure data are complete.
  stunted9 = na.omit(stunted9)
  any(is.na(stunted9))
  print(paste0('number people removed: ', nrow(child) - nrow(stunted9)))
  
  # Creating durable goods index, based on PCA
  durGoodsIdx = prcomp(stunted9 %>% dplyr::select(one_of(durGoods)),
                       center = TRUE, scale. = TRUE)
  
  stunted9 = stunted9 %>% 
    mutate(durGoodsIdx = durGoodsIdx$x[,1]) %>% 
    select(-one_of(durGoods))
  
  
  stunted9Regr = glm(stunted ~ . 
                     - a01
                     - latitude - longitude, data = stunted9, family = binomial(link = "logit"))
  
  print(summary(stunted9Regr))
}


# those reporting physical abuse is lower... not sure what that means.

# Things that have shown up: 
# fcs, breast feeding, mobiles, priceshk, childCt, firstborn,
# age months, educ, flabor, domestic shit, # females, hhsize


# MODEL 10 stunting, under 2’s -----------------------------------------------------
vars2test = c('marriedHead',  'femhead',  'hhsize',  'roomsPC',  
              'mlabor',  'flabor',  'gender',  'ageMonths',  'priceshkR',  'latrineSealed',  
              'brickTinHome',  'landless',  'fishAreaDecile', 'fishOpenWater', 
              'distMarket',  'intDate',  'FCS',   
              'intDate',  'hhsize',  'under15Share',  'div_name',  'educAdultM_cat012',  'educAdultF_cat012',
              durGoods)


stunted10 = child %>% 
  filter(!is.na(stunted),
         ageMonths < 25) %>% 
  dplyr::select(one_of(c('stunted', 'a01', 'latitude', 'longitude', vars2test)))



# Check to make sure data are complete.
stunted10 = na.omit(stunted10)
any(is.na(stunted10))
print(paste0('number people removed: ', nrow(child) - nrow(stunted10)))

# Creating durable goods index, based on PCA
durGoodsIdx = prcomp(stunted10 %>% dplyr::select(one_of(durGoods)),
                     center = TRUE, scale. = TRUE)

stunted10 = stunted10 %>% 
  mutate(durGoodsIdx = durGoodsIdx$x[,1]) %>% 
  select(-one_of(durGoods))


stunted10Regr = glm(stunted ~ . 
                   - a01
                   - latitude - longitude, data = stunted10, family = binomial(link = "logit"))

stuntedRegr10Cl = cl(stunted10, stunted10Regr, stunted10$a01)


# MODEL 11: stunting under 2's + additional ------------------------------------------------

for (i in 1:length(varsYounguns)) {
  
  vars2test = c('marriedHead',  'femhead',  'hhsize',  'roomsPC',  
                'mlabor',  'flabor',  'gender',  'ageMonths',  'priceshkR',  'latrineSealed',  
                'brickTinHome',  'landless',  'fishAreaDecile', 'fishOpenWater', 
                'distMarket',  'intDate',  'FCS',   
                'intDate',  'hhsize',  'under15Share',  'div_name',  'educAdultM_cat012',  'educAdultF_cat012',
                durGoods,
                varsYounguns[i])
  
  
  stunted11 = child %>% 
    filter(!is.na(stunted),
           ageMonths < 25) %>% 
    dplyr::select(one_of(c('stunted', 'a01', 'latitude', 'longitude', vars2test)))
  
  
  
  # Check to make sure data are complete.
  stunted11 = na.omit(stunted11)
  any(is.na(stunted11))
  print(paste0('number people removed: ', nrow(child) - nrow(stunted11)))
  
  # Creating durable goods index, based on PCA
  durGoodsIdx = prcomp(stunted11 %>% dplyr::select(one_of(durGoods)),
                       center = TRUE, scale. = TRUE)
  
  stunted11 = stunted11 %>% 
    mutate(durGoodsIdx = durGoodsIdx$x[,1]) %>% 
    select(-one_of(durGoods))
  
  
  stunted11Regr = glm(stunted ~ . 
                     - a01
                     - latitude - longitude, data = stunted11, family = binomial(link = "logit"))
  
  print(summary(stunted11Regr))
}

# Plot the residuals. -----------------------------------------------------
# Residuals seem pretty evenly dispersed.
# ! Note-- need to pull out from the clustered model.
resid = data.frame(fitted = stuntedRegr3$fitted.values, 
                   resid = stuntedRegr3$residuals, 
                   stunted = stunted$stunted, 
                   lat = stunted$latitude, 
                   lon = stunted$longitude)

ggplot(resid, aes(x = lat, y = lon, colour = resid)) +
  geom_point(size = 4, alpha = 0.3) +
  scale_colour_gradientn(colours = brewer.pal(11, 'RdYlBu'),
                         limits = c(-5, 5)) +
  theme_blankLH() +
  theme(legend.position= 'left')











# wasting -----------------------------------------------------------------
wasted = child %>% 
  filter(!is.na(wasted)) %>% 
  dplyr::select(one_of(c('wasted', 'a01', 'latitude', 'longitude', vars2test)))



# Check to make sure data are complete.
wasted = na.omit(wasted)
any(is.na(wasted))
print(paste0('number people removed: ', nrow(child) - nrow(wasted)))

# Creating durable goods index, based on PCA
durGoodsIdx = prcomp(wasted %>% dplyr::select(one_of(durGoods)),
                     center = TRUE, scale. = TRUE)

wasted = wasted %>% 
  mutate(durGoodsIdx = durGoodsIdx$x[,1]) %>% 
  select(-one_of(durGoods))


# MODEL 1: most generic form of redundant vars ----------------------------
wastedRegr = glm(wasted ~ . 
                  - a01 - firstBorn - waterAccess - privateWater
                  - fishes
                  - latitude - longitude, data = wasted, family = binomial(link = "logit"))


broom::tidy(wastedRegr) %>% 
  mutate(signif = p.value < 0.05)


# MODEL 2: MASS refinement of vars -------------------------------------------------
wastedRegr2 = stepAIC(wastedRegr, direction = 'both')


# MODEL 3: clustering vars ------------------------------------------------
# literate Hoh showed up in the model, but removing since overlaps w/ educ vars.
wastedRegr3 = glm(formula = wasted ~   ageMonths + 
                     dfloor + savings +  FCS + noFood +
                     intDate + hhsize + under15Share + div_name + educAdultM_cat012 + educAdultF_cat012, 
                   data = wasted, family = binomial(link = "logit"))

wastedRegr3Cl = cl(wasted, wastedRegr3, wasted$a01)

# MODEL 4: using same vars as stunting ------------------------------------
vars2test = c('marriedHead',  'femhead',  'hhsize',  'roomsPC',  
              'mlabor',  'flabor',  'gender',  'ageMonths',  'priceshkR',  'latrineSealed',  
              'brickTinHome',  'landless',  'fishAreaDecile', 'fishOpenWater', 
              'distMarket',  'intDate',  'FCS',   
              'intDate',  'hhsize',  'under15Share',  'div_name',  'educAdultM_cat012',  'educAdultF_cat012',
              durGoods)


wasted4 = child %>% 
  filter(!is.na(wasted)) %>% 
  dplyr::select(one_of(c('wasted', 'a01', 'latitude', 'longitude', vars2test)))



# Check to make sure data are complete.
wasted4 = na.omit(wasted4)
any(is.na(wasted4))
print(paste0('number people removed: ', nrow(child) - nrow(wasted4)))

# Creating durable goods index, based on PCA
durGoodsIdx = prcomp(wasted4 %>% dplyr::select(one_of(durGoods)),
                     center = TRUE, scale. = TRUE)

wasted4 = wasted4 %>% 
  mutate(durGoodsIdx = durGoodsIdx$x[,1]) %>% 
  select(-one_of(durGoods))


wasted4Regr = glm(wasted ~ . 
                    - a01
                    - latitude - longitude, data = wasted4, family = binomial(link = "logit"))

wastedRegr4Cl = cl(wasted4, wasted4Regr, wasted4$a01)






# underweight -----------------------------------------------------------------
underwgt = child %>% 
  filter(!is.na(underwgt)) %>% 
  dplyr::select(one_of(c('underwgt', 'a01', 'latitude', 'longitude', vars2test)))



# Check to make sure data are complete.
underwgt = na.omit(underwgt)
any(is.na(underwgt))
print(paste0('number people removed: ', nrow(child) - nrow(underwgt)))

# Creating durable goods index, based on PCA
durGoodsIdx = prcomp(underwgt %>% dplyr::select(one_of(durGoods)),
                     center = TRUE, scale. = TRUE)

underwgt = underwgt %>% 
  mutate(durGoodsIdx = durGoodsIdx$x[,1]) %>% 
  select(-one_of(durGoods))


# MODEL 1: most generic form of redundant vars ----------------------------
underwgtRegr = glm(underwgt ~ . 
                 - a01 - firstBorn - waterAccess - privateWater
                 - fishes
                 - latitude - longitude, data = underwgt, family = binomial(link = "logit"))


broom::tidy(underwgtRegr) %>% 
  mutate(signif = p.value < 0.05)


# MODEL 2: MASS refinement of vars -------------------------------------------------
underwgtRegr2 = stepAIC(underwgtRegr, direction = 'both')


# MODEL 3: clustering vars ------------------------------------------------
# literate Hoh showed up in the model, but removing since overlaps w/ educ vars.
underwgtRegr3 = glm(formula = underwgt ~ roomsPC + femCount35_59 + femWork + 
                      mlabor + occupSpouseChx + ageMonths + dfloor + 
                      electricity + gold + landless + sleepHungry + durGoodsIdx +
                    intDate + hhsize + under15Share + div_name + educAdultM_cat012 + educAdultF_cat012, 
                  data = underwgt, family = binomial(link = "logit"))

underwgtRegr3Cl = cl(underwgt, underwgtRegr3, underwgt$a01)


# MODEL 4: using same vars as stunting ------------------------------------
vars2test = c('marriedHead',  'femhead',  'hhsize',  'roomsPC',  
              'mlabor',  'flabor',  'gender',  'ageMonths',  'priceshkR',  'latrineSealed',  
              'brickTinHome',  'landless',  'fishAreaDecile', 'fishOpenWater', 
              'distMarket',  'intDate',  'FCS',   
              'intDate',  'hhsize',  'under15Share',  'div_name',  'educAdultM_cat012',  'educAdultF_cat012',
              durGoods)


underwgt4 = child %>% 
  filter(!is.na(underwgt)) %>% 
  dplyr::select(one_of(c('underwgt', 'a01', 'latitude', 'longitude', vars2test)))



# Check to make sure data are complete.
underwgt4 = na.omit(underwgt4)
any(is.na(underwgt4))
print(paste0('number people removed: ', nrow(child) - nrow(underwgt4)))

# Creating durable goods index, based on PCA
durGoodsIdx = prcomp(underwgt4 %>% dplyr::select(one_of(durGoods)),
                     center = TRUE, scale. = TRUE)

underwgt4 = underwgt4 %>% 
  mutate(durGoodsIdx = durGoodsIdx$x[,1]) %>% 
  select(-one_of(durGoods))


underwgt4Regr = glm(underwgt ~ . 
                   - a01
                   - latitude - longitude, data = underwgt4, family = binomial(link = "logit"))

underwgtRegr4Cl = cl(underwgt4, underwgt4Regr, underwgt4$a01)



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
