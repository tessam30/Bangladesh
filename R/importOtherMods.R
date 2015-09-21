# Import module W4: illness -----------------------------------------------

illness = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/048_mod_w4_female.CSV')

illness = illness %>% 
  mutate_(.dots= setNames(list(convert01('w4_04')), 'wtLoss')) %>% 
  mutate_(.dots= setNames(list(convert01('w4_05')), 'fever')) %>% 
  mutate_(.dots= setNames(list(convert01('w4_07')), 'diarrhea')) %>% 
  mutate_(.dots= setNames(list(convert01('w4_09')), 'cough')) %>% 
  mutate_(.dots= setNames(list(convert01('w4_11')), 'rash')) %>% 
  mutate_(.dots= setNames(list(convert01('w4_13')), 'throatInfect')) %>% 
  select(a01, mid, 
         wtLoss, fever,feverLen = w4_06, 
         diarrhea, diarrheaLen = w4_08,
         cough, coughLen = w4_10, 
         rash, rashLen = w4_12,
         throatInfect, throatLen = w4_14)


illnessHH = illness %>% 
  group_by(a01) %>% 
  summarise(wtLossHH = any(wtLoss == 1),
            feverHH = any(fever == 1),
            diarrheaHH = any(diarrhea == 1),
            coughHH = any(cough == 1),
            rashHH = any(rash == 1),
            throatHH = any(throatInfect == 1))

illness = full_join(illness, illnessHH, by = 'a01')


# food security -----------------------------------------------------------
foodSec = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/051_mod_x3_female.CSV')

foodSec = foodSec %>% 
  select(a01, x3_01, x3_03, x3_05) %>% 
  group_by(a01) %>% 
  summarise(foodLackLH = any(x3_01 == 1),
            sleepHungry = any(x3_03 == 1),
            noFood = any(x3_05 == 1))


# micronutrients ----------------------------------------------------------
micronut = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/052_mod_y1_female.CSV')

micronut = micronut %>% 
  filter(y1_00 == 1) %>% 
  mutate_(.dots= setNames(list(convert01('y1_18')), 'sprinkles')) %>% 
  mutate_(.dots= setNames(list(convert01('y1_31')), 'purchVitamin')) %>% 
  mutate(breastFedinit = ifelse(y1_04_1 == 7 | y1_04_2 == 7 | y1_04_3 == 7, 1,
                                ifelse((is.na(y1_04_1) & is.na(y1_04_2) & is.na(y1_04_3)), NA, 0))) %>% 
  select(a01, mid = child_id_y1,
         whereBorn = y1_01, whoBirthed1 = y1_02_1,
         whoBirthed2 = y1_02_2, whoBirthed3 = y1_02_3, whoBirthed4 = y1_02_4,
         whoAteVitamin1 = y1_35_1, whoAteVitamin2 = y1_35_2, whoAteVitamin3 = y1_35_3, 
         whoAteVitamin4 = y1_35_4, 
         breastFedinit)



# nutrition knowledge  (module Y2) -----------------------------------------------------
nutKnowl = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/053_mod_y2_female.CSV')

nutKnowl = nutKnowl %>% 
  mutate(useColostrum = ifelse(y2_02 == 2, 1,
                               ifelse(is.na(y2_02), NA, 0
                               )),
         giveWaterifHot = ifelse(y2_05 == 1, 1, 
                                 ifelse(y2_05 == 2, 0,
                                        ifelse(y2_05 == 88, -1, NA))),
         washHandsToilet = ifelse(y2_12_1 == 2 | y2_12_2 == 2 | y2_12_3 == 2, 1,
                                  ifelse((is.na(y2_12_1) & is.na(y2_12_2) & is.na(y2_12_3)), NA, 0)),
         washHandsPoopyBaby = ifelse(y2_12_1 == 4 | y2_12_2 == 4 | y2_12_3 == 4, 1,
                                     ifelse((is.na(y2_12_1) & is.na(y2_12_2) & is.na(y2_12_3)), NA, 0)),
         washHandsEat = ifelse(y2_12_1 == 1 | y2_12_2 == 1 | y2_12_3 == 1, 1,
                               ifelse((is.na(y2_12_1) & is.na(y2_12_2) & is.na(y2_12_3)), NA, 0)),
         washHandsFeedKids = ifelse(y2_12_1 == 3 | y2_12_2 == 3 | y2_12_3 == 3, 1,
                                    ifelse((is.na(y2_12_1) & is.na(y2_12_2) & is.na(y2_12_3)), NA, 0))) %>% 
  rowwise() %>% 
  mutate(washScore = 
           ifelse((is.na(washHandsToilet) & is.na(washHandsEat)) &
                    (is.na(washHandsFeedKids) & is.na(washHandsPoopyBaby)), NA_real_,
                  sum(washHandsEat, washHandsPoopyBaby, washHandsToilet, washHandsFeedKids, na.rm = TRUE)))




# awareness of impt feeding principles (module Y3) ------------------------
feeding = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/054_mod_y3_female.CSV')

feeding = feeding %>% 
  mutate_(.dots= setNames(list(convert01('y3_01_c')), 'BFwi1h')) %>% 
  mutate_(.dots= setNames(list(convert01('y3_02_c')), 'feedOnlyMilk')) %>% 
  mutate_(.dots= setNames(list(convert01('y3_03_c')), 'feedEnoughFood')) %>% 
  mutate_(.dots= setNames(list(convert01('y3_04_c')), 'feedProtein')) %>% 
  select(a01, BFwi1h, feedOnlyMilk, feedEnoughFood, feedProtein) %>% 
  rowwise() %>% 
  mutate(feedingScore = ifelse(any(!is.na(BFwi1h), !is.na(feedOnlyMilk), 
                                   !is.na(feedEnoughFood), !is.na(feedProtein)),
                               sum(BFwi1h , feedOnlyMilk , 
                                   feedEnoughFood , feedProtein, na.rm = TRUE), NA_real_))


# immunization (module Y4) ------------------------------------------------------------
immuniz = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/055_mod_y4_female.CSV')

imm = immuniz %>% 
  select(a01, mid = child_id_y4, ageMonths = y4_01, 
         gender = y4_02, birthOrder = y4_03, vitA = y4_04,
         contains('y4_05')) %>% 
  gather(immunizQ, immunized, -a01, -mid, -ageMonths, -gender, -birthOrder, -vitA)

x = imm %>% group_by(a01, mid, ageMonths, gender, birthOrder, vitA) %>% 
  summarize(imm = any(immunized == 1))
# Everyone seems to have at least _some_ immunization-- > 1,000 out of ~ 1,200 kids < 2 y.  
# Only NAs, not 0's for responses.


# prenatal care (module Y5) -----------------------------------------------
prenatal = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/056_mod_y5_female.CSV')

prenatal = prenatal %>% 
  mutate_(.dots= setNames(list(convert01('y5_04')), 'prenatFeedPgrm')) %>% 
  mutate(antenatalCare = ifelse(y5_01 == 0, 0,
                                ifelse(is.na(y5_01), NA, 1)),
         tetVacWhilePreg = ifelse(is.na(y5_13) | y5_13 == 8, NA,
                                  ifelse(y5_13 == 0, 0, 1)),
         ironWhilePreg = ifelse(is.na(y5_14)| y5_14 == 8, NA,
                                ifelse(y5_14 == 1, 1, 0)),
         vitAafterPreg = ifelse(is.na(y5_19)| y5_19 == 88, NA,
                                ifelse(y5_19 == 1, 1, 0)),
         bornAtHome = ifelse(is.na(y5_20) | y5_20 == 88| y5_20 == 99, NA,
                             ifelse(y5_20 == 8, 1, 0))
  ) %>% 
  select(a01, mid = child_id_y5, antenatalCare, prenatFeedPgrm, 
         tetVacWhilePreg, ironWhilePreg, vitAafterPreg,
         whereBorn = y5_20, bornAtHome)



# nutrition pgrms (modules Y6, Y7, Y8) ----------------------------------------
y6 = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/057_mod_y6_female.CSV')
y7 = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/058_mod_y7_female.CSV')
y8 = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/059_mod_y8_female.CSV')

# Ignoring Y6-- only 16 (!) hh report using community nutrition centres.
y6 %>% 
  group_by(y6_01) %>% 
  summarise(n())

# Ditto for Y7-- 31 hh went to growth monitoring service in NNP services; 11 in feeding pgrm
y7 %>% 
  group_by(y7_01, sample_type) %>% 
  summarise(n())

y7 %>% 
  group_by(y7_05) %>% 
  summarise(n())

# health workers has some variation!
healthWorkers = y8 %>% 
  mutate_(.dots= setNames(list(convert01('y8_01')), 'healthWorkerCame')) %>% 
  mutate_(.dots= setNames(list(convert01('y8_04')), 'receivedNutAdvice')) %>% 
  mutate_(.dots= setNames(list(convert01('y8_06')), 'gotHealthAdvice')) %>% 
  select(a01, healthWorkerCame, receivedNutAdvice, gotHealthAdvice)


# Fishy fishes ------------------------------------------------------------
fish = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/026_mod_l1_male.CSV')

# !!! NOTE: Fish module only has the data where people have reported having fish farms, 
# not those who don't have any.  For initial purposes, assuming everyone who didn't report
# doesn't fish farm.  However, may or may not be true... no indication who's NA.

fish = fish %>% 
  mutate(fishOpenWater = ifelse(is.na(pondid), NA,
                                ifelse(pondid == 999, 1, 0)),
         fishes = 1) %>% # tag for whether family fishes.
  select(a01, fishArea = l1_01, fishOpenWater,
         fishes) %>% 
  group_by(a01, fishes) %>% 
  summarise(fishOpenWater = any(fishOpenWater == 1),
            fishArea = sum(fishArea, na.rm = TRUE)) %>% 
  mutate(fishArea = ifelse(fishOpenWater == TRUE  & 
                             fishArea == 0, NA_real_, fishArea))



# fertilizer (module H3) --------------------------------------------------
fertilizer = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/013_mod_h3_male.CSV')

fertilizer = fertilizer %>% 
  mutate(orgFert = h3_10, 
         pesticides = h3_11) %>% 
  select(-h3_10, -h3_11, -crop_a, -crop_b) %>% 
  gather(fertType, inorgFertAmt, -a01, -orgFert, -pesticides, -plotid) %>% 
  group_by(a01) %>% 
  summarise(inorgFert = any(inorgFertAmt > 0),
            totInorg = sum(inorgFertAmt, na.rm = TRUE),
            orgFert = any(orgFert > 0),
            totPesticides = sum(pesticides, na.rm = TRUE),
            pesticides = any(pesticides > 0)
            )