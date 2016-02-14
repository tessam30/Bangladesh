# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')

# # Import plotting functions -----------------------------------------------
source('~/GitHub/Bangladesh/R/reusablePlots.r')



# Boxplot of value vs. coping --------------------------------------------
heightBox = 6
widthBox = 7

coping = shkR %>%
  filter(!is.na(copeClass), shkCat == 'medexp')  %>% 
  group_by(copeClass) %>% 
  summarise(num=n())

shkR$copeClass = factor(shkR$copeClass,
                        c('bad', 'good', 'none'))

ggplot(shkR %>% filter(!is.na(copeClass), shkCat == 'medexp'),
       aes(x = copeClass, y = logShkVal, colour = copeClass)) +
  geom_boxplot(size = 0.3, width = 1.15, fill = NA)+
  geom_violin(size = 0.4, fill = NA)+
  geom_jitter(alpha = 0.2, size = 4, shape = 16, 
              width = 0.0, height = 0)+
  # coord_flip() +
  scale_x_discrete(labels = c('bad coping', 'good coping', 'no coping')) +
  scale_y_continuous(limits = c(2.2, 6.5),
                     breaks = 3:6,
                     expand = c(0, 0.3),
                     labels = c("1,000", "10,000","100,000", "1,000,000")) +
  scale_colour_manual(values = c('bad' = ftfOrange, 'good' = '#66bd63', 'none' = '#4eb3d3')) +
  annotate('text', x = coping$copeClass, y = 2.2, hjust = 0.5, 
           label = paste0(coping$num, ' households'), size = 5,
           colour = grey60K, family = 'Segoe UI Light'
  ) +
  ggtitle('Households with more severe medical expense shocks tend to cope through less sustainable means') + 
  theme_yGrid() +
  ylab('estimated cost of shock (taka)')


ggsave("~/Documents/USAID/Bangladesh/plots/BG_medshkCoping.pdf",
       width = widthBox, height = heightBox,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)


# boxplot med coping broken down ------------------------------------------

mini = data.frame(val = c(46, 46, 21, 2, 313, 217, 38, 3, 2, 221), 
                  type = c('bad', 'bad','bad', 'bad',
                           'good','good','good','good','good', 'none'),
                  strat = c('sold or mortgaged productive assets', 'sold or mortgaged land', 
                            'changed food consumption', 'removed kids from school', 'took a loan', 
                            'took help from others', 'sold or mortgaged consumption assets', 
                            'non-working member took job', 'forced to change occupation',
                            'did nothing'))

mini$strat = factor(mini$strat, rev(c('sold or mortgaged productive assets', 'sold or mortgaged land', 
                                      'changed food consumption', 'removed kids from school', 'took a loan', 
                                      'took help from others', 'sold or mortgaged consumption assets', 
                                      'non-working member took job', 'forced to change occupation',
                                      'did nothing')))

ggplot(mini, aes(x = strat, y = val, fill = type)) +
  geom_bar(stat = 'identity') +
  coord_flip() +
  geom_text(aes(label = val, y = 0),
            family = 'Segoe UI', size = 2.8, colour = grey50K) +
  scale_fill_manual(values = c('bad' = ftfOrange, 'good' = '#66bd63', 'none' = '#4eb3d3')) +
  theme_classicLH() +
  theme(axis.title = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 9, family = 'Segoe UI Light',
                                   color = '#4D525A', hjust = 0),
        axis.ticks = element_blank())


ggsave("~/Documents/USAID/Bangladesh/plots/BG_medshkCoping_mini.pdf",
       width = 3.5, height = 3,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)



# #'s for the plot...
# total shocks with coping mech:
shkR %>% 
  filter(!is.na(cope1Cat),
         shkCat == 'medexp') %>% 
  summarise(n())

shkR %>% 
  filter(!is.na(cope1Cat),
         shkCat == 'medexp') %>% 
  group_by(copeClass, cope1Cat) %>% 
  summarise(nObs = n()) %>% 
  arrange(desc(nObs)) %>% 
  ungroup() %>% 
  mutate(val = paste0('(',nObs, ') ', cope1Cat)) %>% 
  select(val)

# #'s for median
shkR %>% 
  filter(!is.na(copeClass), !is.na(logShkVal)) %>% 
  group_by(copeClass) %>% 
  summarise(median(logShkVal), median(shkValue))


# price -------------------------------------------------------------------
#'s for coping:
shkR %>% 
  filter(!is.na(cope1Cat),
         shkCat == 'price') %>% 
  group_by(copeClass, cope1Cat) %>% 
  summarise(nObs = n()) %>% 
  ungroup() %>% 
  mutate(pct = percent(nObs / sum(nObs)))

# seasonality of shocks -------------------------------------------------------------------
shkByMonth = shkR %>% 
  filter(!is.na(month)) %>% 
  group_by(shkCat, month) %>% 
  summarise(nObs = n())


medByMonth = shkByMonth %>% 
  filter(shkCat == 'medexp')



ggplot(medByMonth, aes(x = month, y = nObs)) +
  geom_point(size = 5, colour = 'dodgerblue') +
  theme_jointplot()

hazByMonth = shkR %>% 
  filter(shkCat == 'hazard')

precip = precip[1:12,]
ggplot(hazByMonth, aes(x = month, y = shk.x, group = 1)) +
  stat_summary(fun.y = sum, geom = 'line') +
#   annotate(geom = 'rect', ymin = 0, ymax = 40, 
#            xmin = 6, xmax = 10, fill = 'blue', alpha = 0.2) +
  theme_jointplot() +
  geom_line(aes(x = 1:12, y = Precip..mm./10),data = precip, colour = 'dodgerblue')

shkByYr = shk %>% 
  filter(!is.na(time)) %>% 
  group_by(shkCat, time) %>% 
  summarise(nObs = n())

hazByYr = shkByYr %>% filter(shkCat == 'hazard')

medByYr = shkByYr %>% filter(shkCat=='medexp')

ggplot(medByYr, aes(x = time, y = nObs)) +
  geom_point(size = 4, colour = 'dodgerblue') +
  # facet_wrap(~shkCat, scales = 'free_y') + 
  theme_jointplot()




x = bg_raw %>% 
  group_by(shkCat, time) %>% 
  summarise(nObs = n()) 

ggplot(x, aes(x = time, y = nObs)) +
  geom_line(size = 1, colour = 'seagreen') +
  facet_wrap(~shkCat, scales  = 'free_y') + 
  theme_jointplot()

x = shk %>%
  group_by(year, shkCat, month) %>% 
  summarise(nObs = n()) %>% 
  mutate(pct = nObs / sum(nObs))



# Extra plots -------------------------------------------------------------

# Bubble plot of shockValue by coping method, by size.  Not used.
x = shkR %>% 
  filter(shkCat %in% c('medexp', 'ag', 'hazard', 'price'), 
         !is.na(shkValue)) %>% 
  group_by(shkCat, cope1Cat)  %>% 
  summarise(avg = mean(shkValue), num= n())

ggplot(x, aes(x = avg, y= cope1Cat, colour = shkCat, group = shkCat, size = num)) +
  geom_point() +
  scale_size_continuous(range = c(2, 15)) +
  # stat_smooth() +
  theme_jointplot() 

# Full range of box plot of shock cat by value
coping = shkR %>%
  filter(!is.na(cope1Cat), shkCat == 'medexp')  %>% 
  group_by(cope1Cat) %>% 
  summarise(num=n())


ggplot(shkR %>% filter(!is.na(cope1Cat), shkCat == 'medexp'), 
       aes(x = cope1Cat, y = logShkVal, colour = copeClass)) +
  geom_boxplot(size = 0.3)+ 
  geom_point(alpha = 0.2, size = 4)+ 
  coord_flip() +
  scale_y_continuous(limits = c(2.2, 6),
                     breaks = 3:6,
                     expand = c(0, 0.1),
                     labels = c("1,000", "10,000","100,000", "1,000,000")) +
  scale_colour_manual(values = c('bad' = ftfOrange, 'good' = '#66bd63', 'none' = '#4eb3d3')) +
  annotate('text', x = coping$cope1Cat, y = 2.5, label = coping$num, size = 7,
           colour = grey60K, family = 'Segoe UI Light'
  ) +
  theme_xGrid()
# Bangladesh stunting plots
# Laura Hughes, lhughes@usaid.gov

# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')

child = child %>%
  mutate(ageYrs = round(ageMonths / 12,0))

# stunting point estimates ------------------------------------------------
# boysStunting = child %>% 
#   filter(gender == 0,
#          !is.na(stunted))
# 
# # pairGrid(boysStunting, 'stunted', 'div_name', 
# #          fileMain = '~/Documents/USAID/Bangladesh/plots/boysStunting.pdf', 
# #          fileHHsize = '~/Documents/USAID/Bangladesh/plots/boysStunting_HH.pdf', 
# #          xLim = c(0, .7), 
# #          colorDot = brewer.pal(9, 'Blues'), rangeColors = c(0,1), 
# #          colorSE = brewer.pal(9, 'Blues')[3], alphaSE = 0.4, 
# #          regionOrder = c(2,5,3,1,6,4,7))
# 
# pairGrid(boysStunting, 'stunted', 'div_name', 
#          fileMain = '~/Documents/USAID/Bangladesh/plots/boysStunting_horiz.pdf', 
#          fileHHsize = '~/Documents/USAID/Bangladesh/plots/boysStunting_HH.pdf', 
#          xLim = c(0, .7), yLim = c(0,.7),
#          colorDot = brewer.pal(9, 'Blues'), rangeColors = c(0,1), 
#          colorSE = brewer.pal(9, 'Blues')[3], alphaSE = 0.4, 
#          regionOrder = rev(c(1,4,2,7,6,3,5)))
# 
# girlsStunting = child %>% 
#   filter(gender == 1,
#          !is.na(stunted))

# pairGrid(girlsStunting, 'stunted', 'div_name', 
#          fileMain = '~/Documents/USAID/Bangladesh/plots/girlsStunting.pdf', 
#          fileHHsize = '~/Documents/USAID/Bangladesh/plots/girlsStunting_HH.pdf', 
#          xLim = c(0, .7), 
#          colorDot = femaleGradient, rangeColors = c(0, 1), 
#          colorSE = femaleGradient[2], alphaSE = 0.4, 
#          regionOrder = c(2,5,3,1,6,4,7))

# pairGrid(girlsStunting, 'stunted', 'div_name', 
#          fileMain = '~/Documents/USAID/Bangladesh/plots/girlsStunting_horiz.pdf', 
#          fileHHsize = '~/Documents/USAID/Bangladesh/plots/girlsStunting_HH.pdf', 
#          xLim = c(0, .7), yLim = c(0, .7),
#          colorDot = femaleGradient, rangeColors = c(0, 1), 
#          colorSE = femaleGradient[2], alphaSE = 0.4, 
#          regionOrder = rev(c(1,4,2,7,6,3,5)))

facetAvgPoints(df = child, varName = 'stunted', facetVar = 'gender',
               regionVar =  'div_name', facet1 = 0, facet2 = 1,
               fileMain = '~/Documents/USAID/Bangladesh/plots/girlsStunting_horiz.pdf', 
               fileHHsize = '~/Documents/USAID/Bangladesh/plots/girlsStunting_HH.pdf', 
               heightAvg = 7, widthAvg = 16,
               xLim = c(0, .7), horiz = TRUE,
               colorDot = femaleGradient, rangeColors = c(0.2, .7), 
               colorSE = femaleGradient[2], alphaSE = 0.4)

facetAvgPoints(df = child, varName = 'stunted', facetVar = 'gender',
               regionVar =  'div_name', facet1 = 0, facet2 = 1,
               heightAvg = 7, widthAvg = 16,
               fileMain = '~/Documents/USAID/Bangladesh/plots/boysStunting_horiz.pdf', 
               fileHHsize = '~/Documents/USAID/Bangladesh/plots/girlsStunting_HH.pdf', 
               xLim = c(0, .7), horiz = TRUE,
               colorDot = brewer.pal(9, 'Blues'), rangeColors = c(0.2,.7), 
               colorSE = brewer.pal(9, 'Blues')[3], alphaSE = 0.4)





# heatmap: wealth, stunting -----------------------------------------------
widthStuntHeat = 5
heightStuntHeat = 3.75

stuntAvg = child %>% 
  filter(!is.na(stunted)) %>% 
  group_by(wealthDecile, ageYrs, gender) %>% 
  summarise(stunted = mean(stunted))

# Plotting girls...
ggplot(stuntAvg, aes(y = wealthDecile, x = ageYrs, fill = stunted)) +
  geom_tile(size = 0.6, colour = 'white') +
  facet_wrap(~ gender) +
  scale_fill_gradientn(colours = femaleGradient) +
  # scale_fill_gradientn(colours = brewer.pal(9, 'Blues')) +
  # scale_y_reverse() +
  xlab('age (years)') +
  scale_y_continuous(breaks = c(4,7,10),
                     labels = c('low wealth', 'medium wealth', 'high wealth')) +
  theme_xylab() +
  theme(axis.title.y = element_blank())


ggsave("~/Documents/USAID/Bangladesh/plots/BG_stuntingHeatF.pdf",
       width = widthStuntHeat, height = heightStuntHeat,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)

# ... then boys.
ggplot(stuntAvg, aes(y = wealthDecile, x = ageYrs, fill = stunted)) +
  geom_tile(size = 0.6, colour = 'white') +
  facet_wrap(~ gender) +
  scale_fill_gradientn(colours = brewer.pal(9, 'Blues')) +
  xlab('age (years)') +
  scale_y_continuous(breaks = c(4,7,10),
                     labels = c('low wealth', 'medium wealth', 'high wealth')) +
  theme_xylab() +
  theme(axis.title.y = element_blank())


ggsave("~/Documents/USAID/Bangladesh/plots/BG_stuntingHeatM.pdf",
       width = widthStuntHeat, height = heightStuntHeat,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)



# Marginal effects of age/sex ---------------------------------------------
stuntMFX <- read.csv("~/Documents/USAID/Bangladesh/Data/Stunting.Gender.MFX.csv", stringsAsFactors=FALSE)

m = stuntMFX %>% 
  filter(gender == 1)

f = stuntMFX %>% 
  filter(gender == 2)

stuntAge = rbind(m,f)

maleBlue = brewer.pal(9, 'Blues')[6]

ggplot(stuntAge, aes(x = age/12, y = b, colour = genderLabel)) +
  geom_line(size = 0.7) +
  geom_ribbon(aes(ymin = lowerB, ymax = upperB, fill = genderLabel),
              colour = NA, alpha = 0.1
  ) +
  coord_cartesian(xlim = c(0, 5), ylim = c(0, 0.6)) +
  scale_y_continuous(expand = c(0,0), 
                     breaks = seq(0, 0.6, by = 0.2),
                     labels = percent) + 
  scale_x_continuous(expand = c(0,0)) +
  annotate(geom = 'text', x = 0.85, y = 0.44, label = 'male', colour = maleBlue,
           size = 4, family = 'Segoe UI Semilight') +
  annotate(geom = 'text', x = 1.2, y = 0.37, label = 'female', colour = colorFemale,
           size = 4, family = 'Segoe UI Semilight') +
  xlab('age (years)') +
  ggtitle('Males have higher stunting when young but the gap narrows as they age') +
  scale_fill_manual(values = c('male' = maleBlue, 'female' = colorFemale)) +
  scale_colour_manual(values = c('male' = maleBlue, 'female' = colorFemale)) +
  theme_xygrid()

ggsave("~/Documents/USAID/Bangladesh/plots/BG_stuntingAge.pdf",
       width = 3.5, height = 2,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)





# choropleth values: mean stunting rates. ---------------------------------

stuntVal = child %>% 
  group_by(gender, div_name, stunted) %>% 
  summarise(s=(mean(stunted, na.rm = T)), 
            w =(mean(wasted, na.rm = T)),
            u = (mean(underwgt, na.rm = T)),
            n = n()) %>% 
  arrange(div_name)


# # -- Quick choropleth in R. --
# # Broken by dev version of ggplot?
# data(admin1.regions)
# 
# x = data.frame(admin1.regions %>% 
#                  filter(country == 'bangladesh') %>% 
#                  select(region)) %>% 
#   mutate(value = stuntVal$s[1:7])
# 
# admin1_choropleth("bangladesh",
#                   x)
# 
# 
# x = data.frame(admin1.regions %>% 
#                  filter(country == 'bangladesh') %>% 
#                  select(region)) %>% 
#   mutate(value = stuntVal$s[8:14])
# 
# admin1_choropleth("bangladesh",
#                   x)
# 
# 


# Global stat: malnourished children --------------------------------------

# -- Calculating percent of children who have at least one form of malnutrition. --
child %>% 
  filter(!is.na(malnourished)) %>% 
  group_by(div_name, malnourished > 0)  %>% 
  summarise(num = n()) %>% 
  mutate(pct = percent(num/sum(num)))


# stunting by age, sex ----------------------------------------------------
colorGrey = '#D1D3D4' # 20% K
colorRegion = 'dodgerblue'

yMax = 0.6
width1 = 6
height1 = 3

colorGender = c(colorMale, colorFemale)

ggplot(child, aes(x = ageMonths, y = stunted, colour = factor(gender))) + 
  geom_smooth(method = "loess", size = 0.9, span = 0.8, se = FALSE) +
  # stat_summary(fun.y = mean, geom = 'point', size = 5)+
  # facet_wrap(~ div_name) +
  theme_xygrid() +
  ggtitle('percent of stunted children') +
  scale_colour_manual(values = colorGender) +
  coord_cartesian(ylim = c(0, yMax)) +
  scale_y_continuous(expand = c(0,0), labels = percent,
                     breaks = seq(0, yMax, by  = 0.2)) +
  scale_x_continuous(expand = c(0,0),
                     breaks = seq(0, 60, by = 20)) +
  xlab('age (months)')


ggsave(paste0("~/Documents/USAID/Bangladesh/plots/stunting_sexAge_allBG.pdf"), 
       width = width1, height = height1,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)


# wasting by age, sex -----------------------------------------------------


ggplot(child, aes(x = ageMonths, y = wasted, colour = factor(gender))) + 
  geom_smooth(se=FALSE, size=1) +
  # stat_summary(fun.y = mean, geom = 'point', size = 5)+
  # facet_wrap(~ div_name) +
  theme_xygrid() +
  ggtitle('percent of wasted children') +
  scale_colour_manual(values = colorGender) +
  coord_cartesian(ylim = c(0, yMax)) +
  scale_y_continuous(expand = c(0,0), labels = percent,
                     breaks = seq(0, yMax, by  = 0.2)) +
  scale_x_continuous(expand = c(0,0),
                     breaks = seq(0, 60, by = 20)) +
  xlab('age (months)')


ggsave(paste0("~/Documents/USAID/Bangladesh/plots/wasting_sexAge_allBG.pdf"), 
       width = width1, height = height1,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)





# underweight by age, sex -------------------------------------------------
ggplot(child, aes(x = ageMonths, y = underwgt, colour = factor(gender))) + 
  geom_smooth(alpha = 0.2, size=1) +
  # stat_summary(fun.y = mean, geom = 'point', size = 5)+
  # facet_wrap(~ div_name) +
  theme_xygrid() +
  ggtitle('percent of underweight children') +
  scale_colour_manual(values = colorGender) +
  coord_cartesian(ylim = c(0, yMax)) +
  scale_y_continuous(expand = c(0,0), labels = percent,
                     breaks = seq(0, yMax, by  = 0.2)) +
  scale_x_continuous(expand = c(0,0),
                     breaks = seq(0, 60, by = 20)) +
  xlab('age (months)')


ggsave(paste0("~/Documents/USAID/Bangladesh/plots/underwgt_sexAge_allBG.pdf"), 
       width = width1, height = height1,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)

# stunting by region, age, sex --------------------------------------------
width2 = 2.25
height2 = 2
yMax = 0.75

regions = unique(child$div_name)

df = child %>% 
  filter(gender == 0)

for (region in regions){
  child1 = child %>% 
    filter(div_name == region)
  
  q = ggplot(child, aes(x = ageMonths, y = stunted, colour = factor(gender))) + 
    geom_smooth(se=FALSE, size=0.7) +
    geom_smooth( aes(x = ageMonths, y = stunted, colour = factor(gender)), 
                 data = child1,
                 se=FALSE, size=1.5) +
    # stat_summary(fun.y = mean, geom = 'point', size = 5)+
    # facet_wrap(~ div_name) +
    theme_xygrid() +
    ggtitle(region) +
    scale_colour_manual(values = colorGender) +
    coord_cartesian(ylim = c(0, yMax)) +
    scale_y_continuous(expand = c(0,0), labels = percent) +
    scale_x_continuous(expand = c(0,0),
                       breaks = seq(0, 60, by = 20)) +
    xlab('age (months)')
  
  print(q)
  
  ggsave(paste0("~/Documents/USAID/Bangladesh/plots/stunting_sexAge_", region, ".pdf"), 
         width = width2, height = height2,
         bg = 'transparent',
         paper = 'special',
         units = 'in',
         useDingbats=FALSE,
         compress = FALSE,
         dpi = 300)
}


# exploration: not for final ----------------------------------------------


child = removeAttributes(child) %>% 
  mutate(ageYrs = round(ageMonths / 12,0))

ggplot(child, aes(x = wealthDecile, y = stunted , colour = factor(gender))) + 
  geom_smooth(method = 'loess', span = 1, alpha = 0.1)+
  facet_wrap(~ ageYrs) +
  theme_jointplot() +
  coord_cartesian(ylim = c(0, 0.9)) +
  theme(legend.position = 'right')

ggplot(child, aes(x = wealthDecile, y = stunted, colour = factor(gender))) + 
  geom_smooth(method = 'loess', span = 1, fill = NA)+
  coord_cartesian(ylim = c(0, 0.9)) +
  theme_jointplot()

child %>% 
  group_by(div_name, FCS > 53) %>% 
  summarise(nObs = n()) %>% 
  mutate(pct = percent(nObs/sum(nObs)))


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

edR = read_dta('~/Documents/USAID/Bangladesh/Data/edshkposR.dta')
edR$a01 = as.integer(edR$a01)

# Calculate rooms per capita
bg = bg %>% 
  mutate(roomsPC = totRooms / hhsize,
         # edshkR = ifelse(edshkpos == 1 & 
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

occupDict = data.frame(key = 1:9,
                       val = c('Ag-day laborer', 'Non-ag day laborer',
                               'Salaried', 'Self-employed', 
                               'Rickshaw/van puller', 'Business or trade',
                               'Production business', 'Farming', 
                               'Non-earning occupation'))

bg = code2Cat(bg, occupDict, 'occupHoh', 'occupCat')

# Merge in recent ed shk
bg = full_join(bg, edR, by = 'a01')

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
         fishOpenWater = ifelse(is.na(fishOpenWater), 0, fishOpenWater),
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
  filter(t1_10 %in% c(1,2)) %>%  # remove shocks that aren't first or second most important.
  mutate(month = t1_04, year = t1_05, shkCode = t1_02,
         month = ifelse(month < 10, sprintf('%02d', month), month),
         time = ymd(paste0(year, month, '01')),
         shk = ifelse(t1_03 == 0, 0, 
                      ifelse(t1_03 > 0, 1, NA)),
         shkCat = 
           ifelse(shkCode %in% c(3,4), 'medexp',
                  # ifelse(shkCode %in% c(9, 10, 11, 12, 13), 'ag',
                         # ifelse(shkCode %in% c(14, 15, 16, 17), 'asset2',
                                ifelse(shkCode == 32, 'price', 
                                       ifelse(shkCode  %in% c(6, 9, 10, 11, 14, 16), 'hazard', 'other'))),
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

# -- Merge in with interesting categories from the household set
shk = full_join(shk, bg, by = 'a01')

# Recent shocks in the past 2 y.
# ! Note: filters out hh without a shock.
shkR = shk %>% 
  filter(year > 2009) %>% 
  mutate(logShkVal = log10(shkValue))

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
  summarise(wtLossHH = sum(wtLoss, na.rm = TRUE),
            wtLossNA = all(is.na(wtLoss)),
            feverHH = sum(fever, na.rm = TRUE),
            feverNA = all(is.na(fever)),
            diarrheaHH = sum(diarrhea, na.rm = TRUE),
            diarrheaNA = all(is.na(diarrhea)),
            coughHH = sum(cough, na.rm = TRUE),
            coughNA = all(is.na(cough)),
            rashHH = sum(rash, na.rm = TRUE),
            rashNA = all(is.na(rash)),
            throatHH = sum(throatInfect, na.rm = TRUE),
            throatNA = all(is.na(throatInfect))) %>% 
  mutate(wtLossHH = ifelse(wtLossNA == 1, NA, wtLossHH > 0),
         rashHH = ifelse(rashNA == 1, NA, rashHH > 0),
         feverHH = ifelse(feverNA == 1, NA, feverHH > 0),
         diarrheaHH = ifelse(diarrheaNA == 1, NA, diarrheaHH > 0),
         coughHH = ifelse(coughNA == 1, NA, coughHH > 0),
         throatHH = ifelse(throatNA == 1, NA, throatHH > 0)
         )

illness = full_join(illness, illnessHH, by = 'a01')


# food security -----------------------------------------------------------
foodSec = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/051_mod_x3_female.CSV')

foodSec = foodSec %>% 
  select(a01, x3_01, x3_03, x3_05) %>% 
  group_by(a01) %>% 
  summarise(foodLackLH = any(x3_01 == 1),
            sleepHungry = any(x3_03 == 1),
            noFood = any(x3_05 == 1))


# micronutrients (mod Y1)-------------------------------------------------------
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

fishBreaks = quantile(fish$fishArea, probs = seq(0,1, by = 0.1), na.rm = TRUE)
fishBreaks[1] = 0

fish = fish %>% 
  mutate(fishAreaDecile = cut(fishArea, 
                              breaks = fishBreaks,
                              na.rm = TRUE, labels = FALSE))

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



# Tobacco use -------------------------------------------------------------
tobacco = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/031_mod_o1_female.CSV')

tobacco = tobacco %>% 
  filter(o1_01 == 314) %>% 
  mutate(tobacco = ifelse(
    o1_02 == 1, 1, 
    ifelse(o1_02 == 2, 0, NA)
  )) %>% 
  select(a01, tobacco)
# import mods for women's empowerment.
bg = bg  %>% mutate(ageGap = agehead - ageSpouse)

regions = bg %>% 
  select(a01, div_name, verbalAbuse, physicalAbuse)

wd = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/072_mod_weai_wd_female.CSV')




# Most women have some money of their own.
# wd  %>% group_by(wd01) %>% summarise(n())
# Source: local data frame [3 x 2]
# 
# wd01   n()
# (int) (int)
# 1     1  4595
# 2     2  1903
# 3    NA     5

# Spending is often healthcare, after spending money on clothes for self or kids.
wd  %>% group_by(wd05_a) %>% summarise(x=n()) %>% arrange(desc(x))


# WE ----------------------------------------------------------------------


we = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/074_mod_weai_we_female.CSV')
weM = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/073_mod_weai_we_male.CSV')

# Able to change community
we %>% group_by(we01) %>% summarise(n())

# Voting
we %>% group_by(we03) %>% summarise(x = n()) %>% mutate(pct = x/sum(x))
weM %>% group_by(we03) %>% summarise(x = n()) %>% mutate(pct = x/sum(x))

we %>% filter(!is.na(we04)) %>% group_by(div_name, we04) %>% summarise(x = n()) %>% mutate(pct = x/sum(x)) %>% filter(we04 ==1)
weM  %>% filter(!is.na(we04)) %>%  group_by(we04) %>% summarise(x = n()) %>% mutate(pct = x/sum(x))



# WF ----------------------------------------------------------------------

wfF = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/078_mod_weai_wf02-wf11_female.csv')
wfM = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/077_mod_weai_wf02-wf11_male.csv')

wfF = wfF %>% mutate(gender = 'female')
wfM = wfM %>% mutate(gender = 'male')

wf = rbind(wfF, wfM) %>% 
  mutate(a01 = wa01)
wf = full_join(wf, regions)

# Men are sicker than women.
wfF %>% filter(!is.na(wf05)) %>% group_by(wf05) %>% summarise(x = n()) %>% mutate(pct = x/sum(x))
wfM %>% filter(!is.na(wf05)) %>% group_by(wf05) %>% summarise(x = n()) %>% mutate(pct = x/sum(x))

ggplot(wfF, aes(x = wf05))+ geom_histogram(aes(y=..count../sum(..count..)), binwidth = 1)+ 
  ggtitle('number days sick in past month (women)') +theme_xygrid() + coord_cartesian(ylim=c(0,1))

ggplot(wfM, aes(x = wf05))+ geom_histogram(aes(y=..count../sum(..count..)), binwidth = 1)+ 
  ggtitle('number days sick in past month (men)') +theme_xygrid() + coord_cartesian(ylim=c(0,1))

# How spend time
wfF %>% filter(!is.na(wf04d)) %>% group_by(wf04d) %>% summarise(x = n()) %>% mutate(pct = x/sum(x))
wfM %>% filter(!is.na(wf04d)) %>% group_by(wf04d) %>% summarise(x = n()) %>% mutate(pct = x/sum(x))

ggplot(wf, aes(x = wf04d, colour = gender)) +
               # y=..count../sum(..count..))) + 
  geom_freqpoly(binwidth = 1) +
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, scales = 'free_y', ncol = 4) +
  scale_x_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  # scale_y_continuous(labels = percent, name = "") +
  ggtitle('ability to go outside village')




ggplot(wf, aes(x = wf04a, colour = gender)) +
  # y=..count../sum(..count..))) + 
  geom_freqpoly(binwidth = 1) +
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, scales = 'free_y', ncol = 4) +
  scale_x_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  # scale_y_continuous(labels = percent, name = "") +
  ggtitle('distrib work')


ggplot(wf, aes(x = wf04b, colour = gender)) +
  # y=..count../sum(..count..))) + 
  geom_freqpoly(binwidth = 1) +
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, scales = 'free_y', ncol = 4) +
  scale_x_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  # scale_y_continuous(labels = percent, name = "") +
  ggtitle('leisure time')


ggplot(wf, aes(y = wf04b, x = gender, colour = factor(gender))) +
  geom_boxplot()+
    scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +  
  scale_y_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  ggtitle('leisure time')


ggplot(wf, aes(y = wf04d, x = gender, colour = factor(gender))) +
  geom_boxplot()+
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +
  scale_y_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  ggtitle('ability to roam')


ggplot(wf, aes(y = wf04f, x = gender, colour = factor(gender))) +
  geom_boxplot()+
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +
  scale_y_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  ggtitle('general happiness')


ggplot(wf, aes(y = wf04c, x = gender, colour = factor(gender))) +
  geom_boxplot()+
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +
  scale_y_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  ggtitle('contacts with fam/friends')

ggplot(wf, aes(y = wf04a, x = gender, colour = factor(gender))) +
  geom_boxplot()+
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  scale_y_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  facet_wrap(~ div_name, ncol = 4) +
  ggtitle('work duties')

ggplot(wf, aes(y = wf04e, x = gender, colour = factor(gender))) +
  geom_boxplot()+
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  scale_y_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  facet_wrap(~ div_name, ncol = 4) +
  ggtitle('power to decide')

ggplot(wf, aes(x = wf04c, colour = gender)) +
  # y=..count../sum(..count..))) + 
  geom_freqpoly(binwidth = 1) +
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, scales = 'free_y', ncol = 4) +
  scale_x_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  # scale_y_continuous(labels = percent, name = "") +
  ggtitle('contacts w/ friends/fam')



wf04 = wf %>% 
  group_by(gender, div_name, quest= wf04c) %>% 
  summarise(x = n()) %>% 
  mutate(pct = x/sum(x))

ggplot(wf04, aes(x = quest, y= pct, colour = gender)) +
  geom_line()+
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +
  scale_x_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  scale_y_continuous(labels = percent, name = "") +
  ggtitle('contacts w/ friends/fam')


wf04 = wf %>% 
  group_by(gender, div_name, quest= wf04b) %>% 
  summarise(x = n()) %>% 
  mutate(pct = x/sum(x))

ggplot(wf04, aes(x = quest, y= pct, colour = gender)) +
  geom_line()+
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +
  scale_x_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  scale_y_continuous(labels = percent, name = "") +
  ggtitle('leisure time')


wf04 = wf %>% 
  group_by(gender, div_name, quest= wf04a) %>% 
  summarise(x = n()) %>% 
  mutate(pct = x/sum(x))

ggplot(wf04, aes(x = quest, y= pct, colour = gender)) +
  geom_line()+
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +
  scale_x_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  scale_y_continuous(labels = percent, name = "") +
  ggtitle('household work distrib')


wf04 = wf %>% 
  group_by(gender, div_name, quest= wf04d) %>% 
  summarise(x = n()) %>% 
  mutate(pct = x/sum(x))

ggplot(wf04, aes(x = quest, y= pct, colour = gender)) +
  geom_line()+
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +
  scale_x_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  scale_y_continuous(labels = percent, name = "") +
  ggtitle('ability to leave house')


wf04 = wf %>% 
  group_by(gender, div_name, quest= wf04e) %>% 
  summarise(x = n()) %>% 
  mutate(pct = x/sum(x))

ggplot(wf04, aes(x = quest, y= pct, colour = gender)) +
  geom_line()+
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +
  scale_x_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  scale_y_continuous(labels = percent, name = "") +
  ggtitle('decision making power')


wf04 = wf %>% 
  group_by(gender, div_name, quest= wf04f) %>% 
  summarise(x = n()) %>% 
  mutate(pct = x/sum(x))

ggplot(wf04, aes(x = quest, y= pct, colour = gender)) +
  geom_line()+
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +
  scale_x_continuous(breaks = 1:10,
                     labels = c('not satisfied', '', '', '',
                                'neutral', '', '', '', '',
                                'very satisfied')) +
  scale_y_continuous(labels = percent, name = "") +
  ggtitle('overall satisfation')



wf %>% group_by(div_name, gender) %>%  summarise(x = mean(wf04f, na.rm = T))



View(wf %>% filter(!is.na(physicalAbuse)) %>% group_by(div_name, gender, physicalAbuse) %>%  summarise(x = mean(wf04f, na.rm = T)))

ggplot(wf, aes(x = physicalAbuse, y = wf04f, colour = gender)) +
  stat_summary(fun.y = mean, geom = 'point', size = 4) +
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +
  scale_x_continuous(breaks = c(0, 1),
                     labels = c('not abused', 'abused'))+
  theme(panel.margin = unit(3, 'lines')) +
  xlab('physically abused') +
  ggtitle('Physical abuse makes women REALLY unhappy') +
  ylab('general life satisfaction (higher better)')


ggplot(wf, aes(x = verbalAbuse, y = wf04f, colour = gender)) +
  stat_summary(fun.y = mean, geom = 'point', size = 4) +
  scale_colour_manual(values = c('male' = colorMale, 'female' = colorFemale)) +
  scale_x_continuous(breaks = c(0, 1),
                     labels = c('not abused', 'abused'))+
  theme_yGrid() +
  facet_wrap(~ div_name, ncol = 4) +
  theme(panel.margin = unit(3, 'lines')) +
  xlab('verbally abused') +
  ggtitle('Verbal abuse makes women unhappy') +
  ylab('general life satisfaction (higher better)')


# WG ----------------------------------------------------------------------


wgF = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/080_mod_weai_wg_male.csv')
wgM = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/079_mod_weai_wg_male.csv')

wgF = wgF %>% mutate(gender = 'female')
wgM = wgM %>% mutate(gender = 'male')

wg = rbind(wgF, wgM) %>% 
  mutate(a01 = wa01)
wg = full_join(wg, regions)


# Men think they decide more often than the women think they have sole control.
whoDecides = wg %>% 
  select(contains('wg01'), gender, a01, div_name) %>% 
  gather(decision, decider, -gender, -a01, -div_name)

# Disconnect!  Men think they're in charge of religion, while women think it's their purview.
whoDecides %>% 
  filter(decision == 'wg01_k') %>% 
  group_by(gender, decider) %>% 
  summarise(n())

View(whoDecides %>% 
       filter(!is.na(decider)) %>% 
       group_by(gender, decision, who = decider == 1) %>% 
       summarise( x= n()) %>% 
       mutate(pct =x/sum(x)) %>% 
       filter(who == TRUE) %>% 
       ungroup() %>% 
       mutate(diff = pct - lag(pct, order_by = decision)))

# Universally, women are less likely to feel like they can make personal decisions about anything-- except birth control.
canUDecide = wg %>% 
  select(contains('wg02'), gender, a01, div_name) %>% 
  gather(decision, decider, -gender, -a01, -div_name)

View(canUDecide %>% 
       filter(!is.na(decider)) %>% 
       group_by(gender, decision, who = decider < 3) %>% 
       summarise( x= n()) %>% 
       mutate(pct =x/sum(x)) %>% 
       filter(who == TRUE) %>% 
       ungroup() %>% 
       mutate(diff = pct - lag(pct, order_by = decision)))


View(canUDecide %>% 
       filter(!is.na(decider), gender == 'female') %>% 
       group_by(div_name, decision, who = decider < 3) %>% 
       summarise( x= n()) %>% 
       mutate(pct =x/sum(x)) %>% 
       filter(who == TRUE))

# Men worry more about religion; women about expenditures.
fearPunishment = wg %>% 
  select(contains('wg03'), gender, a01, div_name) %>% 
  gather(decision, fear, -gender, -a01, -div_name)

View(fearPunishment %>% 
  filter(!is.na(fear)) %>% 
  group_by(gender, decision, who = fear < 3) %>% 
  summarise( x= n()) %>% 
  mutate(pct =x/sum(x)) %>% 
  filter(who == TRUE) %>% 
  ungroup() %>% 
  mutate(diff = pct - lag(pct, order_by = decision)))


# age cohorts -------------------------------------------------------------
fm = fm %>% 
  mutate(ageSpouseCat = cut(ageSpouse, breaks = c(seq(14, 59, by = 5), 100)),
         ageGapCat = cut(ageGap, breaks = seq(-30, 30, by = 5)))

fm %>% group_by(ageSpouseCat) %>% summarise(mean(physicalAbuse, na.rm = T), n())

fm %>% group_by(ageGapCat) %>% summarise(mean(physicalAbuse, na.rm = T), n())
fm %>% group_by(ageGapCat) %>% summarise(mean(verbalAbuse, na.rm = T), n())

fm %>% group_by(anotherWife) %>% summarise(mean(verbalAbuse, na.rm = T), n())
fm %>% filter(ageSpouse < 50, ageSpouse > 19) %>% group_by(anotherWife) %>% summarise(mean(physicalAbuse, na.rm = T), n())

# verbal —> physical ------------------------------------------------------


fm %>% filter(!is.na(verbalAbuse)) %>% group_by(div_name, verbalAbuse) %>% 
  summarise(mean(physicalAbuse, na.rm = TRUE))

fm %>% filter(!is.na(verbalAbuse), physicalAbuse == 1) %>% 
  group_by(verbalAbuse) %>%  summarise(n())



# Z2 ----------------------------------------------------------------------

z2 = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/061_mod_z2_female.CSV')

fm = left_join(fm, z2)
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

write_dta(child, '~/Documents/USAID/Bangladesh/Data/childwithfish_2015-09-22LH.dta')
# Shock plots, Bangladesh Livelihoods Analysis
# Laura Hughes, lhughes@usaid.gov, October 2015.

# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')

# Import plotting functions -----------------------------------------------
source('~/GitHub/Bangladesh/R/reusablePlots.r')




# << Total Shocks >> ------------------------------------------------------


# Heatmap shocks by region ------------------------------------------------
regionCol = 'div_name'
shockCols = c("medexpshkR", "priceshkR","hazardshkR")

# x=bg  %>% select(one_of(shockCols)) %>% summarise_each(funs(mean))
orderShks = rev(c('medexpshkR', 'hazardshkR', 'priceshkR'   
              ))

# bg %>% 
#   select(one_of(shockCols), -edshkposR, div_name) %>% 
#   gather(type, shk, -div_name) %>% 
#   group_by(div_name) %>% 
#   summarise(s = mean(shk)) %>% 
#   arrange(desc(s)) %>% 
#   select(div_name)

orderRegions = c('Chittagong', 'Sylhet', 'Barisal', 'Rangpur', 'Dhaka', 'Khulna', 'Rajshahi')
orderRegions = c('Sylhet', 'Barisal', 'Rajshahi', 'Khulna','Rangpur', 'Dhaka', 'Chittagong' )

# ! Note-- need to remove negative signs from the educ shk data!!  
# Reversed so the colors are right, since edshk are good.
shkHeatmap(bg, shockCols, regionCol = 'div_name',
           rangeAvg = c(0, .3),
           orderRegions = orderRegions, orderShks = orderShks)


ggsave('~/Documents/USAID/Bangladesh/plots/totalShk_heat.pdf', 
       width = 15*.7*.8, height = 4.75*.8,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)

# ggsave('~/Documents/USAID/Bangladesh/plots/totalShk_heat_avgRd.pdf', 
#        width = 15*.7*.8/4, height = 6*.8,
#        bg = 'transparent',
#        paper = 'special',
#        units = 'in',
#        useDingbats=FALSE,
#        compress = FALSE,
#        dpi = 300)


ggsave('~/Documents/USAID/Bangladesh/plots/totalShk_heat_avgGn.pdf', 
       width = 15*.7*.8/4, height = 6*.8,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)



# shock country average ---------------------------------------------------------
regionVar = 'div_name'

shkVar = 'medexpshkR'

pairGrid (bg, shkVar = shkVar, regionVar = regionVar, 
          fileMain = '~/Documents/USAID/Bangladesh/plots/BG_medexpR.pdf', 
          fileHHsize = '~/Documents/USAID/Bangladesh/plots/BG_medexpR_hh.pdf', 
          rangeColors = c(0, 0.35))

shkVar = 'priceshkR'
pairGrid (bg, shkVar = shkVar, regionVar = regionVar, 
          fileMain = paste0('~/Documents/USAID/Bangladesh/plots/BG_',shkVar, '.pdf'), 
          fileHHsize = paste0('~/Documents/USAID/Bangladesh/plots/BG_',shkVar, '_hh.pdf'),
          rangeColors = c(0, 0.35))


shkVar = 'hazardshkR'
pairGrid (bg, shkVar = shkVar, regionVar = regionVar, 
          fileMain = paste0('~/Documents/USAID/Bangladesh/plots/BG_',shkVar, '.pdf'), 
          fileHHsize = paste0('~/Documents/USAID/Bangladesh/plots/BG_',shkVar, '_hh.pdf'),
          rangeColors = c(0, 0.35))

shkVar = 'agshkR'
pairGrid (bg, shkVar = shkVar, regionVar = regionVar, 
          fileMain = paste0('~/Documents/USAID/Bangladesh/plots/BG_',shkVar, '.pdf'), 
          fileHHsize = paste0('~/Documents/USAID/Bangladesh/plots/BG_',shkVar, '_hh.pdf'),
          rangeColors = c(0, 0.35))




# Chittagong price shock story --------------------------------------------
priceByYr = shk %>% 
  filter(!is.na(time), shkCat == 'price',
         year > 2009, 
         div_name %in% c('Chittagong',
                         'Dhaka')) %>% 
  group_by(shkCat, div_name, time) %>% 
  summarise(nObs = n())


chitCol = brewer.pal(9, 'YlOrRd')[8]
dhakaCol = brewer.pal(9, 'YlOrRd')[4]

ggplot(priceByYr, aes(x = time, y = nObs, colour = div_name)) +
  geom_line(size = 1) +
  scale_colour_manual(values = c('Chittagong' = chitCol,
                                 'Dhaka' = dhakaCol),
                      name = "") +
  scale_y_continuous(breaks = c(0, 25, 50)) +
    theme_xygrid() +
  facet_wrap(~div_name, ncol = 2) +
  theme(panel.grid.major.y = element_blank(),
        axis.line = element_line(size = 0.2, color = grey60K),
        axis.line.y = element_blank(),
        axis.text.y = element_blank(),
        panel.grid.major.x = element_line(size = 0.1, color = grey30K)
        )

ggsave('~/Documents/USAID/Bangladesh/plots/prShk_time.pdf', 
       width = 4, height = 1.75,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)

# How price shks cope
mini = shkR %>% 
  filter(shkCat == 'price') %>% 
  mutate(cope1Filtered = 
           ifelse(cope1 == 1, 'none',
                  ifelse(cope1 %in% c(10, 11), 'changed food consumption',
                         'other'))) %>% 
  filter(cope1Filtered != 'other') %>% 
  group_by(strat = cope1Filtered, type = copeClass) %>% 
  summarise(val = n())
  
ggplot(mini, aes(x = strat, y = val, fill = type)) +
  geom_bar(stat = 'identity') +
  coord_flip() +
  geom_text(aes(label = val, y = 0),
            family = 'Segoe UI', size = 2.8, colour = 'white') +
  scale_fill_manual(values = c('bad' = ftfOrange, 'good' = '#66bd63', 'none' = '#4eb3d3')) +
  theme_classicLH() +
  theme(axis.title = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_text(size = 9, family = 'Segoe UI Light',
                                   color = '#4D525A', hjust = 0),
        axis.ticks = element_blank())


ggsave("~/Documents/USAID/Bangladesh/plots/BG_priceshkCoping_mini.pdf",
       width = 3.5, height = 1,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)

# Who gets shocked? -------------------------------------------------------


# shock by profession -----------------------------------------------------
# shkProf = bg %>% 
#        filter(!is.na(occupCat)) %>% 
#   group_by(occupCat) %>% 
#   select(one_of(shockCols)) %>% 
#   summarise_each(funs(mean(.), nObs = n())) %>% 
#   gather(shkType, shock, -occupCat)


# shkProf = bg %>% 
#   filter(!is.na(occupCat)) %>% 
#   group_by(occupCat) %>% 
#   select(one_of(shockCols)) %>% 
#   summarise(shock = mean(medexpshkR), nObs = n())
# 
# ggplot(shkProf, aes(y = occupCat, size = nObs,
#                     x = shock)) +
#   geom_point() +
#   scale_x_continuous(breaks = seq(0, 0.3, by = 0.1),
#                      limits = c(0, 0.3)) +
#   theme_xGrid() +
#   theme(legend.position = 'left')

occupHH = bg %>% 
  filter(!is.na(occupCat)) %>% 
  mutate(occupCat = ifelse(occupCat == 'Production business', 
                           'Business or trade', occupCat))

pairGrid(occupHH, 'medexpshkR', 'occupCat', 
         fileMain = '~/Documents/USAID/Bangladesh/plots/occup_med.pdf', 
         fileHHsize = '~/Documents/USAID/Bangladesh/plots/occup.pdf', 
         widthAvg = 3.7/2,
         heightAvg = 3.1,
         sizeDot = 5,
         sizeAnnot = 4,
         xLim = c(0, .3), 
         annotAdj = -0.25,
         rangeColors = c(0, 0.3))

pairGrid(occupHH, 'hazardshkR', 'occupCat', 
         fileMain = '~/Documents/USAID/Bangladesh/plots/occup_haz.pdf', 
         fileHHsize = '~/Documents/USAID/Bangladesh/plots/occup.pdf', 
         widthAvg = 3.7/2,
         heightAvg = 3.1,
         sizeDot = 5,
         sizeAnnot = 4,
         xLim = c(0, .3), 
         annotAdj = -0.25,
         rangeColors = c(0, 0.3))


pairGrid(occupHH, 'priceshkR', 'occupCat', 
         fileMain = '~/Documents/USAID/Bangladesh/plots/occup_price.pdf', 
         fileHHsize = '~/Documents/USAID/Bangladesh/plots/occup.pdf',
         widthAvg = 3.7/2,
         heightAvg = 2.6,
         sizeDot = 5,
         sizeAnnot = 4,
         xLim = c(0, .3), 
         annotAdj = -0.25,
         rangeColors = c(0, 0.3))
         # regionOrder = c(9, 5, 1, 7, 3, 2, 6, 8,4))

pairGrid(occupHH, 'edshkposR', 'occupCat', 
         fileMain = '~/Documents/USAID/Bangladesh/plots/occup_ed.pdf', 
         fileHHsize = '~/Documents/USAID/Bangladesh/plots/occup.pdf',
         widthAvg = 2,
         heightAvg = 2.25,
         annotAdj = -0.25,
         sizeAnnot = 4,
         colorDot = brewer.pal(9, 'Greens'),
         xLim = c(0, .3), 
         rangeColors = c(0, 0.3))

# shock by wealth ---------------------------------------------------------
wlthShk = bg %>%
  select(one_of(shockCols), wealthDecile) %>% 
  gather(shkType, shk, -wealthDecile)

ggplot(wlthShk, aes(x = wealthDecile, y = shk)) +
  geom_smooth() +
  facet_wrap(~ shkType, scales = 'free_y') +
  # geom_smooth(method  = 'loess', span = 1, size = 1) +
  theme_yGrid()

# shock by femheade ---------------------------------------------------------
femShk = bg %>%
  select(one_of(shockCols), femhead) %>% 
  gather(shkType, shk, -femhead)

ggplot(femShk, aes(x = femhead, y = shk)) +
  stat_summary(fun.y = mean, geom='point', size =5) +
    facet_wrap(~ shkType, ncol = 4) +
  # geom_smooth(method  = 'loess', span = 1, size = 1) +
  theme_yGrid()


# shock by ftf ---------------------------------------------------------
ftfShk = bg %>%
  select(one_of(shockCols), ftfzone) %>% 
  gather(shkType, shk, -ftfzone)


ggplot(ftfShk, aes(x = as.numeric(ftfzone), y = shk)) +
  stat_summary(fun.y = mean, geom='point', size =5) +
  facet_wrap(~ shkType, ncol = 4) +
  # geom_smooth(method  = 'loess', span = 1, size = 1) +
  theme_yGrid()

# shock by educ ---------------------------------------------------------
eduShk = bg %>%
  select(one_of(shockCols), educAdult_18) %>% 
  gather(shkType, shk, -educAdult_18) %>% 
  group_by(shkType, educAdult_18) %>% 
  summarise(shk = mean(shk), nObs = n())


ggplot(eduShk, aes(x = as.numeric(educAdult_18), y = shk,
                   size = nObs)) +
  # stat_summary(fun.y = mean, geom='point', size =5) +
  geom_point() +
  scale_size(range = c(2, 10)) +
  facet_wrap(~ shkType, ncol = 4, scales = 'free_y') +
  # geom_smooth(method  = 'loess', span = 1, size = 1) +
  theme_yGrid() + theme(panel.margin =  unit(3, 'lines'))

# shock by age ------------------------------------------------------------
ageHH = bg %>%
  select(one_of(shockCols), agehead) %>% 
  gather(shkType, shk, -agehead)

ggplot(ageHH, aes(x = agehead, y = shk)) +
  geom_smooth() +
  facet_wrap(~ shkType, scales = 'free_y') +
  # geom_smooth(method  = 'loess', span = 1, size = 1) +
  theme_yGrid()







# NOT USED ----------------------------------------------------------------
# exploration -------------------------------------------------------------

# Nothing: breastfed, birthGap
ggplot(child, aes(y = wasted, x = birthGap, colour = factor(gender))) +
  geom_smooth() +
  theme_box_ygrid()

# shock value -------------------------------------------------------------
colorLoss = '#276419'

shockValue = bg %>% 
  select(medexpshkRTot, agshkRTot, hazardshkRTot, priceshkRTot, shk) %>% 
  gather(shockType, value, -shk) %>%
  filter(value != 0, shk == 1) %>% 
  mutate(logVal = log10(value))


# -- calculate quartiles for each of the shocks. --
logMedTot = shockValue %>% filter(shockType == 'medexpshkRTot')
quantMed = quantile(logMedTot$logVal)


ggplot(data = shockValue, aes(y = logVal, x = shockType)) + 
  geom_violin(fill = colorLoss) +
  annotate(geom = 'rect', ymin = 2.5, ymax = quantMed[4], xmin = 0, xmax = 4, fill = 'white', alpha = 0.1) +
  annotate(geom = 'rect', ymin = quantMed[2], ymax = quantMed[3], xmin = 0, xmax = 4, fill = 'white', alpha = 0.1) +
  annotate(geom = 'rect', ymin = quantMed[1], ymax = quantMed[2], xmin = 0, xmax = 4, fill = 'white', alpha = 0.1) +
  coord_flip() +
  scale_y_continuous(limits = c(2.5, 6.25),
                     breaks = seq(2.5, 6.5, by = 0.5),
                     labels = c("", "1,000","", "10,000", "", "100,000", "", "1,000,000", "")) +
  theme_jointplot()

# breast feeding ----------------------------------------------------------
childPlot = removeAttributes(child)

ggplot(childPlot, aes(x = ageMonths, y = breastFed, colour = factor(gender))) + 
  stat_smooth(method = "loess", size = 0.9, span = 0.5, fill = NA) +
  scale_y_continuous(labels = percent, limits = c(0,1)) +
  scale_colour_manual(values = c("0" = colorMale, "1" = colorFemale),
                      name= "",
                      labels = c('male', 'female')) +
  xlim(c(0, 60)) +
  xlab('age (months)') +
  # stat_summary(fun.y = mean, geom = 'point', size = 5) +
  theme_xygrid() +
  ggtitle('Percent of children currently being breastfed') +
  theme(legend.position =c(0.85, 0.85),
        legend.text = element_text(size = 14, family = "Segoe UI Semilight", 
                                   color = grey60K, hjust = 0.5, vjust = -0.25))


# where ppl fish ----------------------------------------------------------

ggplot(bg %>% filter(!is.na(fishOpenWater)), aes(x = latitude, y = longitude, colour = factor(fishOpenWater))) + geom_point(alpha = 0.3,size = 4) + theme_blankLH()



# Reusable plots.



# shock heatmap -----------------------------------------------------------
shkHeatmap = function (df,
                       shockCols,
                       regionCol,
                       orderShks,
                       orderRegions,
                       colorHeatmap = rev(PlBl),
                       colorAvg = brewer.pal(9, 'YlOrRd'),
                       widthWhite = 1,
                       sizePctLab = 6,
                       plotTitle = 'Percent difference from the national average',
                       relRange = c(-0.15, 0.15),
                       rangeAvg = c(0, 0.4)){
  
  
  # -- Select the columns containing the shock names and the regions. --
  df = df %>% 
    select(one_of(c(shockCols, regionCol)))
  
  # -- Calculate mean for each region, and transform into a tidy array. --
  df_regions = df %>% 
    group_by_(regions = regionCol) %>% 
    select_(paste0('-', regionCol)) %>% 
    summarise_each(funs(mean))
  
  row.names(df_regions) = df_regions$regions
  
  df_regions  = df_regions %>% 
    select(-regions)
  
  numRegions = nrow(df_regions)
  
  # -- Calculate average shock frequency over the sample. --
  df_avg = df %>% 
    select_(paste0('-', regionCol)) %>% 
    summarise_each(funs(mean))
  
  # For overall plot
  avg = df_avg %>% 
    gather(shocks, avg)
  avg$shocks = factor(avg$shocks, orderShks)
  
  if(nrow(df_avg) != 1) {
    stop('you have a problem.  your country avg. does not give  a single value.')
  }
  
  # Replicate to the number of regions
  df_avg = df_avg[rep(1,numRegions),]
  
  
  # -- Convert the avg. to relative average from the mean. --
  df_rel = df_regions - df_avg
  
  #   # ! Hack for now, to flip the 
  #   df_rel$edshkposR = df_rel$edshkposR * -1
  
  # Add back in region names
  df_rel = df_rel %>% 
    mutate(regions = row.names(df_rel)) %>% 
    gather(shocks, rel_mean, -regions)
  
  
  # -- Reorder the rows by worst type of shock --
  df_rel$shocks = factor(df_rel$shocks, orderShks)
  
  # -- Reorder the columns by order of worst regions. --
  df_rel$regions = factor(df_rel$regions, orderRegions)
  
  
  
  
  
  # -- heat plot --
  ggplot(df_rel) +
    geom_tile(aes(y = shocks, x = regions, fill = rel_mean), 
              color = 'white', size = widthWhite) +
    scale_fill_gradientn(colours = colorHeatmap, limits = relRange) +
    geom_text(aes(y = shocks, x = regions, 
                  label = sprintf('%.1f', round(rel_mean * 100,1))), 
              size = sizePctLab, family = 'Segoe UI') +
    ggtitle(plotTitle) +
    theme_heatmap() +
    theme(axis.text = element_text(size = 16, hjust = 0.5, 
                                   color = grey60K, family = 'Segoe UI Light'))
  
  #   ggplot(avg) +
  #     geom_tile(aes(y = shocks, x = 1, fill = avg), 
  #               color = 'white', size = widthWhite) +
  #     scale_fill_gradientn(colours = colorAvg, limits = rangeAvg) +
  #     geom_text(aes(y = shocks, x = 1, 
  #                   label = sprintf('%.1f', round(avg * 100,1))), 
  #               size = sizePctLab, family = 'Segoe UI') +
  #     ggtitle(plotTitle) +
  #     theme_heatmap() +
  #     theme(axis.text = element_text(size = 16, hjust = 0.5, 
  #                                    color = grey60K, family = 'Segoe UI Light'))
}


# country average ---------------------------------------------------------

pairGrid = function (df, shkVar, regionVar, title = NA, 
                     # File names
                     fileMain = NA, fileHHsize = NA, 
                     savePlots = TRUE,
                     confidLevel = 0.95,
                     sizeLine = 0.9, colorLine = 'grey',
                     xLim = NA, yLim = NA,
                     lineAdj = 0.02,
                     # Region names
                     annotAdj = 0.02,
                     sizeAnnot = 7, 
                     regionOrder = NA,
                     # Percent labels
                     sizePct = 5,
                     sizeDot = 6, borderDot = 1,
                     colorDot = brewer.pal(9, 'YlOrRd'),
                     rangeColors = c(0,0.65),
                     # Controlling average point:
                     lineAvgAdj = 2.75, sizeAvg = 0.05,
                     xLabAdj = 0,
                     # S.E. bars
                     colorSE = grey10K,
                     alphaSE = 1,
                     # Whether plot is vertical or horiz.
                     horiz = FALSE,
                     # Height/width for output
                     heightAvg = 3.4,
                     widthAvg = 4.2, 
                     # For plot w/ hh size.
                     colorNObs = c("#d7d7d7", "#5b5b5b"),
                     nObsAdj = -0.02, sizeNObsText = 4.2) {
  
  # -- convert confidence level to factor to convert from std. deviation to CI.
  if (confidLevel == 0.90) {
    confidFactor = 1.645
  }  else if (confidLevel == 0.95) {
    confidFactor = 1.96
  } else if (confidLevel == 0.98) {
    confidFactor = 2.33
  } else if (confidLevel == 0.99) {
    confidFactor = 2.575
  }
  
  # -- Throw a warning if there are any NAs in the shkVar --
  if (any(is.na(df %>% select_(shkVar)))) {
    warning('There are NAs in `shkVar`.  They are being removed!')
    
    df = df %>% 
      filter_(paste0('!is.na(',shkVar, ')'))
  }
  
  # -- Calculate average data, sd, and SE --
  meanFormula = paste0('mean(', shkVar, ')')
  stdFormula = paste0('sd(', shkVar, ')')
  numFormula = 'n()'
  numRegions = nrow(unique(df  %>% select_(regionVar)))
  
  countryAvg = df %>% 
    summarise_(.dots = setNames(c(meanFormula, stdFormula), c('avg', 'std')))
  
  xAvg = countryAvg$avg
  
  
  if (is.na(regionOrder)) {
    orderVar = 'x'
    
    regionOrder = 1:numRegions
  } else {
    orderVar = 'order'
  }
  
  avgVals = df %>% 
    group_by_(regionVar) %>% 
    rename_(.dots = setNames(regionVar, 'names')) %>% 
    summarise_(.dots = setNames(c(meanFormula, stdFormula, numFormula), 
                                c('x', 'std', 'numHH'))) %>% 
    mutate(order = regionOrder) %>% 
    arrange_(orderVar) %>%  # sort, so highest shocks are at top.
    mutate(lb = x - (std * confidFactor)/sqrt(numHH), 
           ub = x + (std * confidFactor)/sqrt(numHH),
           ymin = seq(from = 10, by = 10, length.out = numRegions),
           ymax = seq(from = 10, by = 10, length.out = numRegions))
  
  
  
  # -- Limits for the graph overall --
  if (is.na(xLim)) {
    xLim = c(min(min(avgVals$x)) - 0.1, max(max(avgVals$x)) + 0.1)
  }
  
  if (is.na(yLim)) {
    yLim = c(-5, max(avgVals$ymin)+ 8)
  }
  
  
  # -- Set up the base plot --
  mainPlot =  ggplot(data = avgVals) + 
    theme_pairGrid() +
    
    # -- axis limits --
    # coord_cartesian(ylim = c(-5, nrow(avgVals)*10 + 10), xlim = xLim) +
    coord_cartesian(ylim = yLim, xlim = xLim) + 
    scale_x_continuous(labels = percent, expand = c(0,0)) +
    
    # -- labels --
    # ggtitle(title) +
    #     annotate("text", x = 0, y = max(avgVals$ymin) + 9.5, 
    #              size = 6.5, label = year, 
    #              color = avgVals$colors[7], hjust = 0) +
    #     annotate("text", x = 0, y = max(avgVals$ymin) + 15, 
    #              size = 8, label = title,
    #              fontface = "bold", hjust = 0) 
    # xlab(xLab) +
    
  
  # -- Plot country average --
  geom_vline(xint = xAvg, linetype = 1, color = grey50K, size = sizeAvg) +
    
    # -- Add in S.E. --
    geom_rect(aes(xmin = lb, xmax = ub, ymin = ymin - 0.5, ymax = ymax + 0.5, 
                  fill = colorSE), alpha = alphaSE) +
    scale_fill_identity()+
    
    # -- Overlay the points --
    # geom_point(aes(x = x, y = ymin), size = (sizeDot + borderDot), color = 'black') + # border
    geom_point(aes(x = x, y = ymin, colour = x), size = sizeDot, shape = 16) +
    scale_colour_gradientn(colours = colorDot,   limits = rangeColors) +
    
    
    # -- Add in circles containing the number of samples per segment. --
    #     geom_rect(aes(xmax = -0.01, xmin = -0.05, 
    #                   ymin = ymin - 3, ymax = ymin + 2, fill = nObs)) +
    #     geom_point(aes(x = -0.043,
    #                    y = ymin,  color = nObs), size = sizeDot * 2) +
    #     geom_text(aes(x = -0.043, y = ymin, label = nObs), size = 4.5, fontface = 'bold') + 
    # scale_color_gradientn(colours = colorDot) +
    
    # -- Add in names on the left --
  annotate("text", x =  - annotAdj, y = avgVals$ymin, family = 'Segoe UI Light',
           size = sizeAnnot, label= avgVals$names, hjust = 1, colour = grey90K) +
    
    # -- Annotate percents over the numbers --
    annotate("text", x = avgVals$x + xLabAdj, y = avgVals$ymin + 4, family = 'Segoe UI Light',
             size = sizePct, label= percent(avgVals$x,0), hjust = 0.5, colour = grey60K) +
    
    if(horiz == TRUE) coord_flip()
  
  
  
  # -- blocks for the labels --
  # annotate("rect", xmin = -0.35, xmax = -0.32, ymin = 0, ymax = avgVals$ymin[2] + 5, fill = avgVals$colors[3], alpha = 0.3) +
  # annotate("rect", xmin = -0.35, xmax = -0.32, ymin = avgVals$ymin[3] - 5, ymax = avgVals$ymin[12] + 5, fill = avgVals$colors[8], alpha = 0.3)
  
  print(mainPlot)
  
  # -- Save the main plot --
  
  if (savePlots){
    ggsave(fileMain, 
           plot = mainPlot,
           width = widthAvg, height = heightAvg,
           bg = 'transparent',
           paper = 'special',
           units = 'in',
           useDingbats=FALSE,
           compress = FALSE,
           scale = 2,
           dpi = 300)
  }
  
  
  # -- Plot the household sizes in a separate plot --
  hhSizePlot = ggplot(data = avgVals) + 
    theme_pairGrid() +
    
    # -- axis limits --
    # coord_cartesian(ylim = c(-5, nrow(avgVals)*10 + 10), xlim = xLim) +
    coord_cartesian(ylim = c(-5, max(avgVals$ymin)+ 8), xlim = xLim) + 
    scale_x_continuous(labels = percent, expand = c(0,0)) +
    
    # Add in circles containing the number of samples per segment.
    geom_point(aes(x = 0.02,
                   y = ymin,  color = numHH), size = sizeDot * 2.25) +
    geom_text(aes(x = 0.02, y = ymin, label = numHH), size = sizeNObsText, 
              family = 'Segoe UI', colour = grey90K) + 
    scale_color_gradientn(colours = colorNObs) +
    
    # Add in names on the left
    annotate("text", x = min(avgVals$x) - annotAdj, y = avgVals$ymin, family = 'Segoe UI Light',
             size = sizeAnnot, label= avgVals$names, hjust = 1, colour = grey90K)
  
  # print(hhSizePlot)
  if(savePlots){
    # -- Save the main plot --
    ggsave(fileHHsize, 
           plot = hhSizePlot,
           width = widthAvg, height = heightAvg,
           bg = 'transparent',
           paper = 'special',
           units = 'in',
           useDingbats=FALSE,
           compress = FALSE,
           scale = 2,
           dpi = 300)
  }
  return(mainPlot)
}



# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')

femaleAssets = read_dta('~/Documents/USAID/Bangladesh/Data/femaleAssets.dta')

bg = full_join(femaleAssets, bg, by = 'a01')

child = full_join(femaleAssets, child, by = 'a01')

fm = removeAttributes(bg) %>% 
  filter(femhead == 0, ageSpouse > 14, 
         ageSpouse < 50) %>% 
  mutate(ageGap = agehead - ageSpouse,
         anyAbuse = ifelse(verbalAbuse == 1 | physicalAbuse == 1, 1,
                           ifelse(verbalAbuse == 0 | physicalAbuse == 0, 0, NA)),
         ageSpouseCat = cut(ageSpouse, breaks = c(seq(14, 59, by = 5), 100)),
         ageGapCat = cut(ageGap, breaks = c(-30, seq(0, 15, by = 5),50)),
         under15Cat = cut(under15, breaks = c(-1:3, 9)))

# # Import plotting functions -----------------------------------------------
source('~/GitHub/Bangladesh/R/reusablePlots.r')



# Other data: Bangladesh UN VAW study -------------------------------------
# Source: http://203.112.218.66/WebTestApplication/userfiles/Image/Latest%20Statistics%20Release/VAW_Survey_2011.pdf
# Report on Violence Against Women Suvey 2011
# Bangldesh Bureau of Stats, funded by UNFPA
# Nationally representative survey; conducted w/ female enumerators with 1:1 interviews with a randomly selected female.


# Taking the RURAL data, current husband for all, from Annex B.
# ! Only valid for married spouses >= 15 y old.

confidFactor  = 1.96
physicalAbuse_VAW = data.frame(avg = 0.4836, se = 0.01819) %>%  
  mutate(lb = avg - (se * confidFactor), 
         ub = avg + (se* confidFactor),
         ymin = 0, ymax = 80)

pyschAbuse_VAW = data.frame(avg = 0.7415, se = 0.01728) %>%  
  mutate(lb = avg - (se * confidFactor), 
         ub = avg + (se* confidFactor), 
         ymin = 0, ymax = 80)


# Full table: physical (from Table 5B)




# Other data: 2007 DHS Study ----------------------------------------------
# Source: http://dhsprogram.com/pubs/pdf/FR207/FR207[April-10-2009].pdf

# ! Only good for currently married women b/w ages of 15 - 49.

# To get the total number per area, combining two tables.
# table 14.4: Frequency of spousal violence: proportion of the subset of women reporting past violence.
physAbuse_12mo_DHS = data.frame(div = c('Barisal', 'Chittagong', 'Dhaka', 'Khulna', 'Rajshahi', 'Sylhet'),
                                noAbuse = c(0.496, 0.516, 0.568, 0.573, 0.544, 0.557),
                                n = c(150, 364, 719, 274, 608, 97)) %>% 
  mutate(physAbuse = 1 - noAbuse, nAbs = round(physAbuse * n))

# table 14.2: those who ever reported violence
physAbuse_ever_DHS = data.frame(div = c('Barisal', 'Chittagong', 'Dhaka', 'Khulna', 'Rajshahi', 'Sylhet'),
                                nTot = c(274, 814, 1433, 548, 1115, 283))

# ! Note for future Laura.  These numbers are possibly WRONG!  The numbers of total reported abuse differ b/w the tables, probably due to NAs in table 14.5.4
dhsRegions = full_join(physAbuse_ever_DHS, physAbuse_12mo_DHS) %>% 
  mutate(pctAbs12mo = nAbs / nTot)

physicalAbuse_DHS = data.frame(avg = 0.239, n = 4181) %>% 
  mutate(se = sqrt((avg* (1-avg))/ n),
         lb = avg - (se * confidFactor), 
         ub = avg + (se* confidFactor),
         ymin = 0, ymax = 80)

# Physical abuse point estimate -------------------------------------------------
widthAbuse = 8
heightAbuse = 6
colorAbuse = PuPiYl
rangeColors = c(0, 0.4)
regionVar = 'div_name'


physAbusePlot = pairGrid (fm, shkVar = 'physicalAbuse', regionVar = regionVar, 
                          savePlots = FALSE, horiz = FALSE, 
                          colorDot = colorAbuse, annotAdj = -0.04,
                          xLim = c(0, 0.55),
                          rangeColors = rangeColors)

physAbusePlot + 
  geom_rect(aes(xmin = lb, xmax = ub, ymin = ymin, ymax = ymax), data = physicalAbuse_DHS,
            fill = PuPiYl[13], alpha = 0.2) +
  geom_rect(aes(xmin = lb, xmax = ub, ymin = ymin, ymax = ymax), data = physicalAbuse_VAW,
            fill = PuPiYl[21], alpha = 0.2) +
  geom_vline(xintercept = physicalAbuse_DHS$avg, colour = PuPiYl[13], size = 0.5) +
  geom_vline(xintercept = physicalAbuse_VAW$avg, colour = PuPiYl[21], size = 0.5) +
  annotate('text', x = physicalAbuse_VAW$avg - 0.05,  y = 40,
           colour = PuPiYl[21], hjust = 1,
           size = 6, label = paste0('Violence Against Women\nsurvey 2011: ',
                                    percent(physicalAbuse_VAW$avg)),
           family = 'Segoe UI Semilight') +
  annotate('text', x = physicalAbuse_DHS$avg - 0.02,  y = 40,
           colour = PuPiYl[13], hjust = 1,
           size = 6, label = paste0('DHS survey 2007: ',
                                    percent(physicalAbuse_DHS$avg)),
           family = 'Segoe UI Semilight') +
  theme(title = element_text(family = 'Segoe UI', size= 16, colour = grey90K)) +
  ggtitle('Physical abuse is reported more in Rangpur and Chittagong, but overall at lower rates than previously reported') +
  coord_cartesian(ylim = c(5, 75), xlim = c(0, 0.85))

ggsave("~/Documents/USAID/Bangladesh/plots/BG_physicalAbuse.pdf",
       width = widthAbuse, height = heightAbuse,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)


# Verbal abuse pt estimate ------------------------------------------------
rangeColors = c(0, 0.5)

verbAbusePlot = pairGrid (fm, shkVar = 'verbalAbuse', regionVar = regionVar, 
                          savePlots = FALSE, horiz = FALSE, 
                          colorDot = colorAbuse, annotAdj = -0.04,
                          xLim = c(0, 0.55),
                          rangeColors = rangeColors)


verbAbusePlot + 
  geom_rect(aes(xmin = lb, xmax = ub, ymin = ymin, ymax = ymax), data = pyschAbuse_VAW,
            fill = PuPiYl[21], alpha = 0.2) +
  geom_vline(xintercept = pyschAbuse_VAW$avg, colour = PuPiYl[21], size = 0.5) +
  annotate('text', x = pyschAbuse_VAW$avg - 0.05,  y = 40,
           colour = PuPiYl[21], hjust = 1,
           size = 6, label = paste0('Violence Against Women survey 2011: ',
                                    percent(pyschAbuse_VAW$avg)),
           family = 'Segoe UI Semilight') +
  theme(title = element_text(family = 'Segoe UI', size= 16, colour = grey90K)) +
  ggtitle('Verbal abuse is more common than physical abuse') +
  coord_cartesian(ylim = c(5, 75), xlim = c(0, 0.85))

ggsave("~/Documents/USAID/Bangladesh/plots/BG_verbalAbuse.pdf",
       width = widthAbuse, height = heightAbuse,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)


# Averages ----------------------------------------------------------------
fm %>% summarise(mean(verbalAbuse, na.rm = TRUE))

fm %>% summarise(mean(physicalAbuse, na.rm = TRUE))


fm %>% filter(verbalAbuse == 1) %>%  summarise(mean(physicalAbuse, na.rm = TRUE))
fm %>% filter(physicalAbuse == 1) %>%  summarise(mean(verbalAbuse, na.rm = TRUE))



# binned faux map ---------------------------------------------------------
nBin = 30

x= fm  %>% mutate(latBin = cut(latitude, breaks = nBin), lonBin = cut(longitude, breaks = nBin))

df = x %>% group_by(lonBin, latBin) %>% summarise(avg = mean(anyAbuse, na.rm = TRUE))

ggplot(df, aes(x = lonBin, y = latBin, colour = avg)) + 
  geom_point(size = 4, shape = 15) + 
  theme_blankLH() +
  scale_color_gradientn(colours = brewer.pal(9, "RdPu"))


# wealth ------------------------------------------------------------------
fm$div_name = factor(fm$div_name,
                     c('Sylhet', 'Chittagong',  'Rangpur', 'Khulna', 'Dhaka','Barisal', 'Rajshahi'))

ggplot(fm, aes(x = wealthDecile, y = verbalAbuse)) +
  geom_smooth(method = 'loess', span = 0.85, 
              se = FALSE, size = 0.8, colour = PuPiYl[21]) +
  geom_smooth(aes(x = wealthDecile, y = physicalAbuse),
              method = 'loess', span = 0.85, 
              se = FALSE, size = 0.8, colour = PuPiYl[4]) +
  annotate('text', label = 'verbal', x = 8, y = .35,
           family = 'Segoe UI Semilight',
           size = 5, colour = PuPiYl[21]) +
  annotate('text', label = 'physical', x = 8, y = .3,
           family = 'Segoe UI Semilight',
           size = 5, colour = PuPiYl[4]) +
  # facet_wrap(~div_name, nrow = 2) +
  scale_x_continuous(expand = c(0,0),
                     limits = c(1,10),
                     breaks = 1:10,
                     labels = c('low', '', '', '', 'medium',
                                '', '' ,'', '', 'high'),
                     name = 'wealth'
  ) +
  coord_cartesian(ylim = c(0,0.4)) +
  scale_y_continuous(labels = percent, expand = c(0,0), name = "") +
  theme_yGrid() +
  theme(axis.title.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Semilight'))




wlth = fm  %>% group_by(wealthDecile) %>% 
  summarise(physical = mean(physicalAbuse, na.rm = TRUE), 
            verbal = mean(verbalAbuse, na.rm=TRUE), num = n()) %>% 
  gather(abuseType, avg, -wealthDecile, -num)


ggplot(wlth, aes(x = wealthDecile, y = avg, 
                 label = percent(avg),
                 group = abuseType,
                 colour = abuseType)) +
  geom_line(size = 0.2) +
  geom_point(size = 20, colour= 'white', shape = 17) +
  geom_text(family = 'Segoe UI Light', size = 6) +
  scale_x_discrete(limits = c(1,10),
                   breaks = 1:10,
                   labels = c('low', '', '', '', 'medium',
                              '', '' ,'', '', 'high'),
                   name = 'wealth') +
  scale_colour_manual(values = c('physical' = PuPiYl[9], 'verbal' = PuPiYl[21])) +
  annotate('text', label = 'verbal', x = 5, y = 0.39,
           family = 'Segoe UI Semilight',
           size = 5, colour = PuPiYl[21]) +
  annotate('text', label = 'physical', x = 5, y = 0.15,
           family = 'Segoe UI Semilight',
           size = 5, colour = PuPiYl[9]) +
  scale_y_continuous(labels = percent, 
                     limits = c(0, 0.4),
                     expand = c(0,0), name = "") +
  theme_xOnly()

ggsave("~/Documents/USAID/Bangladesh/plots/BG_abuseWealth.pdf",
       width = 6, height = 4,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)


# age ---------------------------------------------------------------------


ggplot(fm, aes(x = ageSpouse, y = verbalAbuse)) +
  geom_smooth(method = 'loess', span = 0.85, 
              se = FALSE, size = 0.8, colour = PuPiYl[21]) +
  geom_smooth(aes(x = ageSpouse, y = physicalAbuse),
              method = 'loess', span = 0.85, 
              se = FALSE, size = 0.8, colour = PuPiYl[4]) +
  annotate('text', label = 'verbal', x = 45, y = .35,
           family = 'Segoe UI Semilight',
           size = 5, colour = PuPiYl[21]) +
  annotate('text', label = 'physical', x = 45, y = .3,
           family = 'Segoe UI Semilight',
           size = 5, colour = PuPiYl[4]) +
  # facet_wrap(~div_name, nrow = 2) +
  scale_x_continuous(expand = c(0,0),
                     name = 'age of wife',
                     limits = c(15, 50)) +
  coord_cartesian(ylim = c(0,0.4)) +
  scale_y_continuous(labels = percent, expand = c(0,0), name = "") +
  theme_yGrid() +
  theme(axis.title.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Semilight'))



# working -----------------------------------------------------------------
workingWomen = fm %>% 
  filter(!is.na(femWork)) %>% 
  group_by(femWork, div_name) %>% 
  select(femWork, verbalAbuse, physicalAbuse) %>% 
  summarise_each(funs(mean(., na.rm = TRUE))) %>% 
  gather(abuse, pct, -femWork, -div_name)

workingWomen = fm %>% 
  filter(!is.na(femWork)) %>% 
  group_by(femWork) %>% 
  select(femWork, verbalAbuse, physicalAbuse) %>% 
  summarise_each(funs(mean(., na.rm = TRUE))) %>% 
  gather(abuse, pct, -femWork)

workingWomen$femWork = factor(workingWomen$femWork, c(0,1))
# workingWomen$abuse = factor(workingWomen$abuse, c('verbal', 'physical'))

ggplot(workingWomen, aes(x = abuse, y = pct, label = percent(pct),
                         fill = femWork)) +
  geom_bar(stat = 'identity', position = 'dodge', alpha = 0.85) +
  scale_fill_manual(values = c('0' = PuPiYl[14], '1' = PuPiYl[21])) +
  geom_text( family = 'Segoe UI Semibold', colour = 'white', size = 8) +
  annotate('text', label = 'unemployed', x = 1, y = .35,
           family = 'Segoe UI Semilight',
           size = 5, colour = PuPiYl[14]) +
  annotate('text', label = 'employed', x = 1, y = .3,
           family = 'Segoe UI Semilight',
           size = 5, colour = PuPiYl[21]) +
  coord_cartesian(ylim = c(0,0.6)) +
  scale_x_discrete(labels = c('verbal', 'physical')) +
  scale_y_reverse(labels = percent, expand = c(0,0), name = "") +
  coord_flip()+
  theme_xAxis_yText() +
  theme(axis.ticks = element_blank(),
        axis.line = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_blank())

ggsave("~/Documents/USAID/Bangladesh/plots/BG_abuseWorking.pdf",
       width = 3, height = 2,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)

# number of kids ----------------------------------------------------------
numKids = fm  %>% group_by(under15Cat) %>% 
  summarise(physical = mean(physicalAbuse, na.rm = TRUE), 
            verbal = mean(verbalAbuse, na.rm=TRUE), num = n()) %>% 
  gather(abuseType, avg, -under15Cat, -num)


ggplot(numKids, aes(x = under15Cat, y = avg, 
                    label = percent(avg),
                    group = abuseType,
                    colour = abuseType)) +
  geom_line(size = 0.2) +
  geom_point(size = 20, colour= 'white', shape = 17) +
  geom_text(family = 'Segoe UI Light', size = 6) +
  scale_x_discrete(labels = c(0:3, '4+'),
                   name = 'number of children') +
  scale_colour_manual(values = c('physical' = PuPiYl[7], 'verbal' = PuPiYl[21])) +
  annotate('text', label = 'verbal', x = 5, y = 0.39,
           family = 'Segoe UI Semilight',
           size = 5, colour = PuPiYl[21]) +
  annotate('text', label = 'physical', x = 5, y = 0.15,
           family = 'Segoe UI Semilight',
           size = 5, colour = PuPiYl[7]) +
  scale_y_continuous(labels = percent, 
                     limits = c(0, 0.4),
                     expand = c(0,0), name = "") +
  theme_xOnly()


ggsave("~/Documents/USAID/Bangladesh/plots/BG_abuseNumKids.pdf",
       width = widthAbuse, height = heightAbuse,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)


# Mobiles -----------------------------------------------------------------
rangpur = fm %>% 
  filter(div_name == 'Rangpur')


ggplot(fm, aes(x = wealthDecile, y = femaleOwnsOperatesCell)) +
  geom_smooth(method = 'loess', span = 0.85, 
              se = FALSE, size = 0.8, colour = grey30K) +
  geom_smooth(aes(x = wealthDecile, y = femaleOwnsOperatesCell),
              data = rangpur,
              method = 'loess', span = 0.85, 
              se = FALSE, size = 0.8, colour = brewer.pal(9, 'Blues')[6]) +
  annotate('text', label = 'Bangladesh', family = 'Segoe UI',
           size = 5, colour = grey30K, x = 3, y = 0.1) +
  annotate('text', label = 'Rangpur', family = 'Segoe UI',
           size = 5, colour = brewer.pal(9, 'Blues')[6], x = 3, y = 0.3) +
  scale_x_continuous(expand = c(0,0),
                     limits = c(1,10),
                     breaks = 1:10,
                     labels = c('low', '', '', '', 'medium',
                                '', '' ,'', '', 'high'),
                     name = 'wealth'
  ) +
  coord_cartesian(ylim = c(0,1)) +
  scale_y_continuous(labels = percent, expand = c(0,0), name = "") +
  theme_yGrid() +
  theme(axis.title.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Semilight'))


ggsave("~/Documents/USAID/Bangladesh/plots/BG_female_cell.pdf",
       width = 6, height = 4,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)


ggplot(fm, aes(x = wealthDecile, y = femWork)) +
  geom_smooth(method = 'loess', span = 0.85, 
              se = FALSE, size = 0.8, colour = grey30K) +
  geom_smooth(aes(x = wealthDecile, y = femWork),
              data = rangpur,
              method = 'loess', span = 0.85, 
              se = FALSE, size = 0.8, colour = brewer.pal(9, 'Blues')[6]) +
  annotate('text', label = 'Bangladesh', family = 'Segoe UI',
           size = 5, colour = grey30K, x = 3, y = 0.1) +
  annotate('text', label = 'Rangpur', family = 'Segoe UI',
           size = 5, colour = brewer.pal(9, 'Blues')[6], x = 3, y = 0.3) +
  scale_x_continuous(expand = c(0,0),
                     limits = c(1,10),
                     breaks = 1:10,
                     labels = c('low', '', '', '', 'medium',
                                '', '' ,'', '', 'high'),
                     name = 'wealth'
  ) +
  coord_cartesian(ylim = c(0,1)) +
  scale_y_continuous(labels = percent, expand = c(0,0), name = "") +
  theme_yGrid() +
  theme(axis.title.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Semilight'))


ggsave("~/Documents/USAID/Bangladesh/plots/BG_female_work.pdf",
       width = 6, height = 4,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)



ggplot(fm, aes(x = wealthDecile, y = femWork)) +
  geom_smooth(method = 'loess', span = 0.85, 
              se = FALSE, size = 0.8, colour = 'dodgerblue') +
  facet_wrap(~div_name, nrow = 2) +
  scale_x_continuous(expand = c(0,0),
                     limits = c(1,10),
                     breaks = 1:10,
                     labels = c('low', '', '', '', 'medium',
                                '', '' ,'', '', 'high'),
                     name = 'wealth'
  ) +
  coord_cartesian(ylim = c(0,1)) +
  scale_y_continuous(labels = percent, expand = c(0,0), name = "") +
  theme_yGrid() +
  theme(axis.title.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Semilight'))



# supervisor effect -------------------------------------------------------
supervisor = data.frame(n = c(3619, 610, 3619, 610), abuse = c(756, 444, 331, 124), 
                        abuseType = c('verbal abuse', 'verbal abuse','physical abuse', 'physical abuse'), supervisor = c(0,1, 0,1)) %>% 
  mutate(pct = abuse/n)

ggplot(supervisor, aes(x = abuseType, y = pct, label = percent(pct),
                       fill = factor(supervisor))) +
  geom_bar(stat = 'identity', position = 'dodge') +
  geom_text(aes(y = pct - 0.02), family = 'Segoe UI Semibold', colour = 'white', size = 8) +
  scale_fill_manual(values = c('0' = '#35978f', '1' = '#01665e')) +
  theme_xAxis_yText() +
  coord_flip() +
  scale_y_reverse() +
  theme(axis.ticks = element_blank(),
        axis.line = element_blank(),
        axis.title = element_blank(),
        axis.text.x = element_blank())



ggsave("~/Documents/USAID/Bangladesh/plots/BG_supervisor.pdf",
       width = 6, height = 2.5,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)



# Who allowed to go to hospital -------------------------------------------
z2 = read.csv('~/Documents/USAID/Bangladesh/Data/household/data/csv/061_mod_z2_female.CSV')

fm = left_join(fm, z2)


fm = fm %>% 
  mutate(hospitalSelf = ifelse(z2_03_1 == 1, 1,
                               ifelse(!is.na(z2_03_1), 0, NA)),
         hospitalHubby = ifelse(z2_03_1 == 2, 1,
                                ifelse(!is.na(z2_03_1), 0, NA)))

pairGrid (fm, shkVar = 'hospitalHubby', regionVar = 'div_name', 
          savePlots = FALSE, horiz = FALSE, 
          colorDot = colorAbuse, annotAdj = -0.04,
          xLim = c(0, .6),
          rangeColors = c(0, 0.6))

fm$div_name = factor(fm$div_name,
                     rev(c('Barisal', 'Sylhet', 'Dhaka','Chittagong',
                           'Rangpur', 'Rajshahi', 
                           'Khulna')))

ggplot(fm, aes(x  = div_name, y = hospitalSelf)) +
  stat_summary(fun.y = mean, geom = 'bar', fill = 'blue') + 
  coord_flip() +
  theme_yGrid() +
  annotate('text', label = 'husband', x = 6, y = 0.45,
           colour = 'dodgerblue', size = 5, family = 'Segoe UI Semilight') +
  annotate('text', label = 'self', x = 5, y = 0.45,
           colour = 'blue', size = 5, family = 'Segoe UI Semilight') +
  ggtitle('Who decides whether you can go by yourself to the hospital?')+
  stat_summary(aes(x  = div_name, y = -1* hospitalHubby),
               fun.y = mean, geom = 'bar', fill = 'dodgerblue') + 
  scale_y_continuous(name = "", labels = percent, 
                     breaks = seq(-0.5, 0.3, by = 0.1)) +
  coord_flip(ylim = c(-.5, 0.3)) +
  theme_xGrid() +
  theme(panel.grid.major.x = element_line(colour = 'white'),
        axis.line.x = element_line(colour = 'white', size = 0.4))


ggsave("~/Documents/USAID/Bangladesh/plots/BG_goHospital.pdf",
       width = 7, height = 4,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)



# Total mobiles -----------------------------------------------------------
regionVar = 'div_name'
pairGrid (bg, shkVar = 'mobile', regionVar = 'div_name',
          # output file names
          fileMain = '~/Documents/USAID/Bangladesh/plots/BG_mobiles.pdf', 
          fileHHsize = '~/Documents/USAID/Bangladesh/plots/BG_mobiles_hh.pdf', 
          
          # Size of the saved plot; note that it's 1/2 the actual size.
          heightAvg = 3.4,
          widthAvg = 4.2, 
          
          # Colors and color limits.
          colorDot = brewer.pal(9, 'Blues'), 
          rangeColors = c(0.5,.8),
          # Location of the region names -- negative goes more to right.
          annotAdj = -0.2,
          xLim = c(0, 0.85))
# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')

femaleAssets = read_dta('~/Documents/USAID/Bangladesh/Data/femaleAssets.dta')

bg = full_join(femaleAssets, bg, by = 'a01')

child = full_join(femaleAssets, child, by = 'a01')

fm = bg %>% 
  filter(femhead == 0)


# domestic abuse

x = bg  %>% select(verbalAbuse, divorceThreat, physicalAbuse, anotherWife, femWork)

corX = cor(x, use = "pairwise.complete.obs")

colorAbuse = PuPiYl
rangeColors = c(0, 0.46)




pairGrid (bg, shkVar = 'divorceThreat', regionVar = regionVar, 
          savePlots = FALSE, horiz = FALSE, 
          colorDot = colorAbuse, annotAdj = -0.14,
          rangeColors = rangeColors)


pairGrid (bg, shkVar = 'physicalAbuse', regionVar = regionVar, 
          savePlots = FALSE, horiz = FALSE, 
          colorDot = colorAbuse, annotAdj = -0.14,
          rangeColors = rangeColors)


pairGrid (bg, shkVar = 'anotherWife', regionVar = regionVar, 
          savePlots = FALSE, horiz = FALSE, 
          colorDot = colorAbuse, annotAdj = -0.14,
          rangeColors = rangeColors)


ggplot(bg, aes(x = wealthIndex, y = verbalAbuse)) +
  geom_smooth(method = 'loess', span = 1) +
  facet_wrap(~femhead + div_name, nrow = 2) +
  scale_x_continuous(expand = c(0,0)) +
  coord_cartesian(ylim = c(0,1)) +
  scale_y_continuous(labels = percent, expand = c(0,0)) +
  theme_yGrid()


ggplot(bg, aes(x = educAdultM_cat012, y = physicalAbuse)) +
  # geom_smooth(method = 'loess', span = 1) +
  stat_summary(fun.y = mean, geom = 'point', size = 4) +
  facet_wrap(~div_name) +
  # scale_x_continuous(expand = c(0,0)) +
  coord_cartesian(ylim = c(0,.3)) +
  scale_y_continuous(labels = percent, expand = c(0,0)) +
  theme_yGrid()

ggplot(bg, aes(x = educAdultM_cat012, y = physicalAbuse)) +
  # geom_smooth(method = 'loess', span = 1) +
  stat_summary(fun.y = mean, geom = 'point', size = 4) +
  facet_wrap(~div_name) +
  # scale_x_continuous(expand = c(0,0)) +
  coord_cartesian(ylim = c(0,.3)) +
  scale_y_continuous(labels = percent, expand = c(0,0)) +
  theme_yGrid()


ggplot(bg, aes(x = wealthIndex, y = physicalAbuse)) +
  geom_smooth(method = 'loess', span = 1) +
  # stat_summary(fun.y = mean, geom = 'point', size = 4) +
  facet_wrap(~div_name) +
  # scale_x_continuous(expand = c(0,0)) +
  coord_cartesian(ylim = c(0,.3)) +
  scale_y_continuous(labels = percent, expand = c(0,0)) +
  theme_yGrid()

ggplot(fm, aes(x = femWork, y = physicalAbuse)) +
  # geom_smooth(method = 'loess', span = 1) +
  stat_summary(fun.y = mean, geom = 'point', size = 4) +
  facet_wrap(~div_name) +
  # scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(labels = percent, expand = c(0,0)) +
  theme_yGrid()


ggplot(bg, aes(x = longitude, y = latitude, colour = femaleOwnsOperatesCell)) + 
  geom_point(size = 4, alpha = 0.3) +
  facet_wrap(~femaleOwnsOperatesCell) +
  theme_blankLH()


ggplot(bg, aes(x = longitude, y = latitude, colour = femhead)) + 
  geom_point(size = 4, alpha = 0.3) +
  facet_wrap(~femhead) +
  theme_blankLH()


ggplot(bg, aes(x = longitude, y = latitude)) + 
  geom_point(size = 4, alpha = 0.3) +
  facet_wrap(~verbalAbuse) +
  theme_blankLH()


View(bg  %>% filter(!is.na(verbalAbuse), !is.na(physicalAbuse))  %>% 
  group_by(verbalAbuse, physicalAbuse, div_name) %>% 
  summarise(num = n())   %>% 
  ungroup()  %>% group_by(div_name, verbalAbuse) %>% 
  mutate(pct= num/sum(num)))



# Numbers for callouts ----------------------------------------------------

bg  %>% filter(!is.na(verbalAbuse), !is.na(physicalAbuse)) %>% 
  select(verbalAbuse, physicalAbuse) %>% 
  summarise_each(funs(mean))






# overall: verbal abuse ---------------------------------------------------
pairGrid (bg, shkVar = 'verbalAbuse', regionVar = regionVar, 
          savePlots = FALSE, horiz = FALSE, 
          colorDot = colorAbuse, annotAdj = -0.14,
          rangeColors = rangeColors)




# wealth, phys abuse ------------------------------------------------------
ggplot(bg, aes(x = wealthIndex, y = physicalAbuse)) +
  geom_smooth(method = 'loess', span = 1) +
  # stat_summary(fun.y = mean, geom = 'point', size = 4) +
  # scale_x_continuous(expand = c(0,0)) +
  coord_cartesian(ylim = c(0,.3)) +
  scale_y_continuous(labels = percent, expand = c(0,0)) +
  theme_yGrid()

ggplot(fm, aes(x = wealthIndex, y = physicalAbuse)) +
  geom_smooth(method = 'loess', span = 1) +
  # stat_summary(fun.y = mean, geom = 'point', size = 4) +
  facet_wrap(~div_name) +
  # scale_x_continuous(expand = c(0,0)) +
  coord_cartesian(ylim = c(0,.3)) +
  scale_y_continuous(labels = percent, expand = c(0,0)) +
  theme_yGrid()


ggplot(bg, aes(x = wealthIndex, y = verbalAbuse)) +
  geom_smooth(method = 'loess', span = 1) +
  # stat_summary(fun.y = mean, geom = 'point', size = 4) +
  # scale_x_continuous(expand = c(0,0)) +
  coord_cartesian(ylim = c(0,.6)) +
  scale_y_continuous(labels = percent, expand = c(0,0)) +
  theme_yGrid()

ggplot(bg, aes(x = wealthIndex, y = verbalAbuse)) +
  geom_smooth(method = 'loess', span = 1) +
  # stat_summary(fun.y = mean, geom = 'point', size = 4) +
  facet_wrap(~div_name) +
  # scale_x_continuous(expand = c(0,0)) +
  coord_cartesian(ylim = c(0,.6)) +
  scale_y_continuous(labels = percent, expand = c(0,0)) +
  theme_yGrid()


# who works ---------------------------------------------------------------
ggplot(fm, aes(x = wealthIndex, y = femWork)) +
  geom_smooth(method = 'loess', span = 1) +
  # stat_summary(fun.y = mean, geom = 'point', size = 4) +
  facet_wrap(~div_name) +
  # scale_x_continuous(expand = c(0,0)) +
  coord_cartesian(ylim = c(0.2,.8)) +
  scale_y_continuous(labels = percent, expand = c(0,0)) +
  theme_yGrid()

# Female working ----------------------------------------------------------
bg %>% group_by(femhead) %>%
  summarise(mean(femWork, na.rm = TRUE), n())

money = fm %>% 
  filter(!is.na(femWorkMoney)) %>% 
  mutate(femWorkMoneyCat = ifelse(femWorkMoney == 1,
                                  'gives all money to household', 
                                  ifelse(femWorkMoney == 3, 'keeps for self',
                                         'gives some to house'))) %>%
           group_by(div_name, femWorkMoneyCat) %>% 
           summarise(num = n()) %>% 
           mutate(pct = num/sum(num)) %>% 
  filter(femWorkMoneyCat != 'gives some to house')
  

money$div_name = factor(money$div_name, 
                        c('Rangpur', 'Barisal', 'Chittagong',
                          'Khulna', 'Dhaka', 'Sylhet','Rajshahi'))
  
ggplot(money, aes(x = div_name, y = pct, fill = factor(femWorkMoneyCat))) +
  geom_bar(position = 'dodge', stat = 'identity') + 
  scale_y_continuous(labels = percent) +
  theme_yGrid() +
  theme(legend.position = 'left')


fm %>% group_by(educSpouse) %>% 
  summarise(mean(femWork, na.rm = T),n())

fm %>% filter(!is.na(femWorkMoney)) %>% group_by(educSpouse < 3, femWorkMoney) %>% 
  summarise(num = n()) %>% mutate(num/sum(num))


# mobile phone ownership --------------------------------------------------
ggplot(fm, aes(x = wealthIndex, y = femaleOwnsOperatesCell)) +
  geom_smooth(method = 'loess', span = 1) +
  # stat_summary(fun.y = mean, geom = 'point', size = 4) +
  facet_wrap(~div_name) +
  # scale_x_continuous(expand = c(0,0)) +
  coord_cartesian(ylim = c(0,.7)) +
  scale_y_continuous(labels = percent, expand = c(0,0)) +
  theme_yGrid()



# EID ---------------------------------------------------------------------
x = bg  %>% group_by(a18, div_name) %>% 
  summarise(y =mean(physicalAbuse, na.rm=T), num=n()) %>% ungroup() %>% 
  arrange(y)

ggplot(x, aes(x = 1:171, y = y, size = num, colour = factor(div_name))) +
  geom_point() + theme_yGrid()+
  ggtitle('reported physical abuse by enumerator id') +
  theme(legend.position = c(0.2, 0.6))


x = bg  %>% group_by(a19) %>% 
  summarise(y =mean(verbalAbuse, na.rm=T), num=n()) %>% ungroup() %>% 
  arrange(y)

ggplot(x, aes(x = 1:20, y = y, size = num)) +
  geom_point() + theme_yGrid()+
  ggtitle('reported verbal abuse by supervisor id')


x = bg  %>% group_by(a19) %>% 
  summarise(y =mean(physicalAbuse, na.rm=T), num=n()) %>% ungroup() %>% 
  arrange(y)

ggplot(x, aes(x = 1:20, y = y, size = num)) +
  geom_point() + theme_yGrid()+
  ggtitle('reported physical abuse by supervisor id')


x = bg  %>% group_by(a19, div_name) %>% 
  summarise(y =mean(verbalAbuse, na.rm=T), num=n()) %>% ungroup() %>% 
  arrange(y)

ggplot(x, aes(x = 1:48, y = y, size = num, colour = factor(div_name))) +
  geom_point() + theme_yGrid()+
  ggtitle('reported verbal abuse by supervisor id') +
  theme(legend.position = c(0.2, 0.6))



# check: stunting ---------------------------------------------------------

x = child  %>% group_by(a19.x) %>% 
  summarise(y =mean(stunted, na.rm=T), num=n()) %>% ungroup() %>% 
  arrange(y)

ggplot(x, aes(x = 1:20, y = y, size = num)) +
  geom_point() + theme_yGrid()+
  scale_y_continuous(labels = percent, limits = c(0,1)) +
  ggtitle('reported stunting by supervisor id')

x = child  %>% group_by(a18.x) %>% 
  summarise(y =mean(stunted, na.rm=T), num=n()) %>% ungroup() %>% 
  arrange(y)

ggplot(x, aes(x = 1:76, y = y, size = num)) +
  geom_point() + theme_yGrid()+
  scale_y_continuous(labels = percent, limits = c(0,1)) +
  ggtitle('reported stunting by enumerator id')library(MASS)
library(sandwich)
library(lmtest)
library(plm)
library(haven)
library(dplyr)
library(ggplot2)
library(tidyr)
library(knitr)
library(RColorBrewer)
library(animation)
library(gridExtra)
library(grid)
library(stringr)
library(ggalt)
library(lubridate)
library(extrafont)
library(coefplot)
library(roxygen2)
library(testthat)


loadfonts()

# library(choroplethrAdmin1)
# library(choroplethr)


# colors ------------------------------------------------------------------
# Custom color libraries
source("~/GitHub/Ethiopia/R/colorPalettes.R")



# recode variables --------------------------------------------------------
# mutate with if/else dictionary function
source("~/GitHub/Ethiopia/R/code2Cat.r")

convert01 = function(varName) {
  paste0('ifelse(', varName, ' == 2, 0, 
                  ifelse(', varName, '== 1, 1, NA))')
  
  # mutate_(.dots= setNames(list(convert01('w4_04')), ''))
}



# clustering function, from dr. essam -------------------------------------
cl   <- function(dat,fm, cluster){
  M <- length(unique(cluster))
  N <- length(cluster)
  K <- fm$rank
  dfc <- (M/(M-1))*((N-1)/(N-K))
  uj  <- apply(estfun(fm),2, function(x) tapply(x, cluster, sum));
  vcovCL <- dfc*sandwich(fm, meat=crossprod(uj)/N)
  coeftest(fm, vcovCL) 
}


# Multiple plot function --------------------------------------------------
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}


# formatting numbers ------------------------------------------------------
roundMean = function(x) {
  round(mean(x, na.rm = TRUE), 2)
}

roundStd = function(x) {
  round(sd(x, na.rm = TRUE), 2)
}

percent = function(x, ndigits = 1) {
  paste0(sprintf("%.f", round(x*100, ndigits)), "%")
}



# clean up environment ----------------------------------------------------
rmExcept = function(x) {
  # x must be a string or a list of strings which encode the var names.
  rm(list=setdiff(ls(), x))
}



# remove attributes from dta import ---------------------------------------

removeAttributes <- function (data) {
  data <- lapply(data, function(x) {attr(x, 'labels') <- NULL; x})
  data <- lapply(data, function(x) {attr(x, 'label') <- NULL; x})
  data <- lapply(data, function(x) {attr(x, 'class') <- NULL; x})
  data <- lapply(data, function(x) {attr(x, 'levels') <- NULL; x})
  data = data.frame(data)
}

pullAttributes <- function (data) {
  label = lapply(data, function(x) attr(x, 'label'))
  
  label = data.frame(label)
  # labels = lapply(data, function(x) attr(x, 'labels'))
  
  # attrs = data.frame(label = label, labels = labels)
}




# themes ------------------------------------------------------------------



theme_jointplot <- function() {
  theme_bw() +
    theme(
      text = element_text(family = 'Segoe UI Light'),
      axis.text = element_text(size = 16, color = grey50K, family = 'Segoe UI Light'),
      title =  element_text(size = 18, family = 'Segoe UI', hjust = 0, color = grey60K),
      axis.title.y =  element_text(size = 20, color = grey50K, family = 'Segoe UI Semilight', hjust = 0.5, vjust = 1),
      axis.title.x =  element_text(size = 20, color = grey50K, family = 'Segoe UI Semilight', hjust = 0.5, vjust = -0.25),
      # axis.title.y = element_blank(), 
      # axis.line = element_blank(),
      # axis.ticks = element_blank()
      strip.text = element_text(size=13, color = grey50K, family = 'Segoe UI Semilight'),
      legend.position = c(0.85, 0.85),
      legend.text = element_text(size = 13),
      strip.background = element_blank()
      #           panel.grid.minor.y = element_blank(),
      #           panel.grid.major.y = element_blank())
    )
}

theme_box_ygrid<- function() {
  theme_bw() +
    theme(
      rect = element_blank(),
      plot.background = element_blank(),
      # panel.background = element_rect(fill = 'white'),
      axis.text = element_text(size = 10, color = '#4D525A'),
      title =  element_text(size = 14, face = "bold", hjust = 0, color = '#4D525A'),
      axis.title.x =  element_text(size = 12, face = "bold", color = '#4D525A', hjust = 0.5, vjust = -0.25),
      axis.title.y = element_blank(), 
      # axis.line = element_blank(),
      # axis.ticks = element_blank()
      strip.text = element_text(size=14, face = 'bold', hjust = 0.05, vjust = -2.5, color = '#4D525A'),
      legend.position = 'none',
      strip.background = element_blank(),
      axis.ticks.y = element_blank(),
      panel.margin = unit(3, 'lines'),
      panel.grid.major.y = element_line(size = 0.2, color = '#bababa'),
      panel.grid.minor.y = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_blank())
}

theme_xylab<- function() {
  theme_bw() +
    theme(
      text = element_text(family = 'Segoe UI Light', colour = grey60K),
      rect = element_blank(),
      plot.background = element_blank(),
      axis.text = element_text(size = 12,  color = grey60K),
      title =  element_text(size = 15, family = "Segoe UI", hjust = 0, color = grey90K),
      axis.title =  element_text(size = 14, family = "Segoe UI Semilight", color = grey60K, hjust = 0.5, vjust = -0.25),
      strip.text = element_text(size=14, family = "Segoe UI Semilight", hjust = 0.05, vjust = -2.5, color = grey90K),
      legend.position = 'none',
      strip.background = element_blank(),
      axis.ticks = element_blank(),
      panel.margin = unit(1, 'lines'),
      panel.grid.major.y = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_blank())
}

theme_xygrid<- function() {
  theme_bw() +
    theme(
      text = element_text(family = 'Segoe UI Light', colour = grey60K),
      rect = element_blank(),
      plot.background = element_blank(),
      # panel.background = element_rect(fill = 'white'),
      axis.text = element_text(size = 12,  color = grey60K),
      title =  element_text(size = 15, family = "Segoe UI", hjust = 0, color = grey90K),
      axis.title.x =  element_text(size = 14, family = "Segoe UI Semilight", color = grey60K, hjust = 0.5, vjust = -0.25),
      axis.title.y = element_blank(), 
      # axis.line = element_blank(),
      # axis.ticks = element_blank()
      strip.text = element_text(size=14, face = 'bold', hjust = 0.05, vjust = -2.5, color = '#4D525A'),
      legend.position = 'none',
      strip.background = element_blank(),
      axis.ticks = element_blank(),
      panel.margin = unit(3, 'lines'),
      panel.grid.major.y = element_line(size = 0.2, color = '#bababa'),
      panel.grid.minor.y = element_blank(),
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_line(size = 0.1, color = '#bababa'))
}

theme_blankbox <- function() {
  theme_bw() +
    theme(
      axis.text = element_text(size = 16, color = 'white'),
      title =  element_text(size = 18, face = "bold", hjust = 0, color = 'white'),
      axis.title =  element_text(size = 20, face = "bold", color = 'white', hjust = 0.5, vjust = -0.25),
      # axis.title.y = element_blank(), 
      # axis.line = element_blank(),
      axis.ticks = element_blank(),
      strip.text = element_text(size=11),
      strip.background = element_blank(),
      legend.position="none",
      panel.grid.minor.x = element_blank(),
      panel.grid.major.x = element_blank(),
      panel.grid.minor.y = element_blank(),
      panel.grid.major.y = element_blank(),
      panel.border = element_blank()
    )
}


theme_blankLH <- function() {
  theme(
    title = element_blank(),
  axis.title = element_blank(),
  axis.text = element_blank(),
  axis.ticks = element_blank(),
  axis.ticks.length = unit(0, units = 'points'),
  axis.ticks.margin = unit(0, units =  'points'),
  panel.border = element_blank(),
  plot.margin = rep(unit(0, units = 'points'),4),
  panel.grid = element_blank(),
  panel.background = element_blank(), 
  plot.background = element_blank(), 
  legend.position="none"
  )
}


theme_heatmap <- function() {
  theme(
    title =  element_text(size = 16, hjust = 0, color = grey90K,
                          family = 'Segoe UI'),
    axis.title = element_blank(),
    axis.text = element_text(size = 12, hjust = 0.5, 
                             color = grey60K, family = 'Segoe UI Light'),
    axis.ticks = element_blank(),
    # axis.text.margin = unit(0, units =  'points'),
    panel.border = element_blank(),
    plot.margin = rep(unit(0, units = 'points'),4),
    panel.grid = element_blank(),
    panel.background = element_blank(), 
    plot.background = element_blank(), 
    legend.position="none"
  )
}


theme_xOnly<- function() {
  theme(title = element_text(size = 32, color = grey90K),
        axis.line = element_line(color = grey60K, size = 1),
        axis.ticks.x = element_line(color = grey60K, size = 0.5),
        axis.text.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.x = element_text(size = 22, color = grey60K, family = 'Segoe UI Semilight'),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(), 
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        plot.margin = rep(unit(0, units = 'points'),4),
        panel.grid = element_blank(),
        panel.background = element_blank(), 
        strip.text = element_text(size=13, face = 'bold'),
        strip.background = element_blank()
  )
}


theme_xAxis_yText<- function() {
  theme(title = element_text(size = 32, color = grey90K),
        axis.line = element_line(color = grey60K, size = 1),
        axis.ticks.x = element_line(color = grey60K, size = 0.5),
        axis.text.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.x = element_text(size = 22, color = grey60K, family = 'Segoe UI Semilight'),
        axis.text.y = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.y = element_blank(), 
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        plot.margin = rep(unit(0, units = 'points'),4),
        panel.grid = element_blank(),
        panel.background = element_blank(), 
        strip.text = element_text(size=13, face = 'bold'),
        strip.background = element_blank()
  )
}


theme_xGrid<- function() {
  theme(title = element_text(size = 16, color = grey90K, 
                             family = 'Segoe UI'),
        axis.line = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.x = element_text(size = 18, color = grey60K, family = 'Segoe UI Semilight'),
        axis.text.y = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.y = element_blank(), 
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_line(size = 0.1, colour = grey60K),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        panel.border = element_blank(),
        plot.margin = rep(unit(0, units = 'points'),4),
        panel.background = element_blank(), 
        strip.text = element_text(size=13, face = 'bold'),
        strip.background = element_blank()
  )
}



theme_yGrid<- function() {
  theme(title = element_text(size = 16, color = grey90K, 
                             family = 'Segoe UI'),
        axis.line = element_blank(),
        axis.ticks.x = element_blank(),
        axis.text.x = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.y = element_text(size = 18, color = grey60K, family = 'Segoe UI Semilight'),
        axis.text.y = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        axis.title.x = element_blank(), 
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_line(size = 0.1, colour = grey60K),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.border = element_blank(),
        plot.margin = rep(unit(0, units = 'points'),4),
        panel.background = element_blank(), 
        strip.text = element_text(size=13, face = 'bold'),
        strip.background = element_blank()
  )
}


theme_bump<- function() {
  theme(title = element_text(size = 32, color = '#4D525A'),
        axis.line = element_blank(),
        axis.ticks.length = unit(7, 'points'),
        axis.ticks.y = element_line(color = '#4D525A', size = 0.5),
        axis.text.y = element_text(size = 16, color = '#4D525A'),
        axis.title.y = element_text(size = 22, color = '#4D525A'),
        axis.text.x = element_text(size = 16, color = '#4D525A'),
        axis.title.x = element_blank(), 
        axis.line.x = element_blank(),
        axis.ticks.x = element_blank(),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank(),
        strip.text = element_text(size=13, face = 'bold'),
        strip.background = element_blank()
  )
}


theme_classicLH<- function() {
  theme(title = element_text(size = 32, color = '#4D525A'),
        axis.line = element_blank(),
        axis.ticks.x = element_line(color = '#4D525A', size = 1),
        axis.text.x = element_text(size = 16, color = '#4D525A'),
        axis.title.x = element_text(size = 22, color = '#4D525A'),
        axis.ticks.y = element_line(color = '#4D525A', size = 1),
        axis.text.y = element_text(size = 16, color = '#4D525A'),
        axis.title.y = element_text(size = 22, color = '#4D525A'),
        legend.position="none",
        panel.background = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank())
}

theme_pairGrid = function() {
  theme(legend.position="none",
        plot.background = element_blank(),
        panel.background = element_blank(),
        axis.text = element_text(size = 16, color = grey60K, family = 'Segoe UI Light'),
        title =  element_text(size = 18, face = "bold", hjust = 0, color = grey90K, family = 'Segoe UI'),
        axis.title =  element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y= element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.minor.y= element_blank(),
        panel.background = element_blank(),
        axis.line = element_line(size = 0.2, colour = grey60K),
        axis.ticks.x = element_blank(),
        plot.margin = rep(unit(0, units = 'points'),4),
        panel.margin = rep(unit(0, units = 'points'),4),
        panel.border = element_blank(),
        # axis.text.x  = element_blank(), axis.title.x  = element_blank(),
        # axis.ticks = element_blank(), axis.line = element_blank(),
        axis.ticks.y = element_blank(), axis.line.y = element_blank(),
        axis.text.y = element_blank(), axis.title.y = element_blank())
}

# All plots for FCS data, Bangladesh Livelihoods Analysis
# October 2015, Laura Hughes, lhughes@usaid.gov

# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')



# FCS heatmap -------------------------------------------------------------

fcs_heat = bg %>% 
  group_by(regionName = div_name) %>% 
  summarise(staples = mean(staples_days) * 2,
            oils = mean(oil_days) * 0.5,
            pulses = mean(pulse_days) * 3,
            sugar = mean(sugar_days) * 0.5, 
            vegetables = mean(veg_days) * 1,
            dairy = mean(milk_days) * 4,
            meat = mean(meat_days) * 4, 
            fruits  = mean(fruit_days) * 1, 
            fcs = mean(FCS)) %>% 
  arrange(desc(fcs))


fcs_avg = bg %>% 
  summarise(staples = mean(staples_days) * 2,
            oils = mean(oil_days) * 0.5,
            pulses = mean(pulse_days) * 3,
            sugar = mean(sugar_days) * 0.5, 
            vegetables = mean(veg_days) * 1,
            dairy = mean(milk_days) * 4,
            meat = mean(meat_days) * 4, 
            fruits  = mean(fruit_days) * 1, 
            fcs = mean(FCS)) %>% 
  arrange(desc(fcs))


rel_fcs_heat = fcs_heat %>% 
  mutate(staples = staples - fcs_avg$staples,
         oils = oils - fcs_avg$oils,
         pulses = pulses - fcs_avg$pulses,
         sugar = sugar - fcs_avg$sugar,
         vegetables = vegetables - fcs_avg$vegetables,
         dairy = dairy - fcs_avg$dairy,
         meat = meat - fcs_avg$meat,
         fruits  = fruits - fcs_avg$fruits)


# -- plot --
widthDDheat = 3.25*2*1.15
heightDDheat = 3*2
widthDDavg = 1.85
fcsRange = c(30, 60)

fcsOrder = rev(rel_fcs_heat$regionName)

View(t(bg  %>% select(contains('days')) %>% summarise_each(funs(mean))))

foodOrder = c('staples', 'oils', 
              'vegetables', 'meat',
              'sugar', 'dairy', 'fruits', 'pulses')

rel_fcs_heat = rel_fcs_heat %>% 
  gather(food, rel_mean, -regionName, -fcs)

rel_fcs_heat$regionName = 
  factor(rel_fcs_heat$regionName,
         fcsOrder)

rel_fcs_heat$food = 
  factor(rel_fcs_heat$food,
         foodOrder)


# Main heatmap
ggplot(rel_fcs_heat) +
  geom_tile(aes(x = food, y = regionName, fill = rel_mean), 
            color = 'white', size = 1) +
  scale_fill_gradientn(colours = PlBl, 
                       limits = c(-6,6)) +
  # geom_text(aes(y = food, x = regionName, label = round(rel_mean,1)), size = 4) +
  ggtitle('FCS, relative to the national average') +
  theme_xAxis_yText() +
  theme(axis.line = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        title = element_text(size = 18, family = 'Segoe UI', hjust = 0, color = grey60K))


ggsave("~/Documents/USAID/Bangladesh/plots/BG_FCSheatmap.pdf",
       width = widthDDheat, height = heightDDheat,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)

# Side heatmap w/ dietary diversity score.

ggplot(rel_fcs_heat) +
  geom_tile(aes(x = 1, y = regionName, fill = fcs), 
            color = 'white', size = 1) +
  scale_fill_gradientn(colours = brewer.pal(9, 'YlGnBu'), 
                       name = 'food consumption score', 
                       limits = fcsRange) +
  geom_text(aes(x = 1, y = regionName, label = round(fcs,0)), size = 5,
            family = 'Segoe UI Semilight', colour = 'white') +
  ggtitle('FCS, relative to the national average') +
  theme_xAxis_yText() +
  theme(axis.line = element_blank(),
        axis.ticks = element_blank(),
        axis.title = element_blank(),
        title = element_text(size = 18, family = 'Segoe UI', hjust = 0, color = grey60K))

ggsave("~/Documents/USAID/Bangladesh/plots/BG_FCSheatmap_fcs.pdf",
       width = widthDDavg, height = heightDDheat,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)



# Marginal effects of FCS -------------------------------------------------

fcsCat = data.frame(xmin = rep(0,4), xmax = rep(1,4),
                    ymin = c(0, 28, 42, 53),
                    ymax = rep(112,4),
                    yavg = c(14, 35, 47.5, 73.5),
                    label = c('poor',
                              'borderline',
                              'acceptable-low',
                              'acceptable-high'))

noEducF = bg %>% 
  filter(educAdultF_cat == 0) %>% 
  summarise(FCS = mean(FCS), std = sd(FCS))


margEffects = data.frame(x = c(0, 0.25, 0.5), 
                         me = c(0, 0.7, 3.5),
                         se = c(0, .5, .6),
                         name = c('no education',
                                  'primary education',
                                  'secondary education')) %>% 
  mutate(y = noEducF$FCS + me,
         lb = noEducF$FCS + me - se,
         ub = noEducF$FCS + me + se)

ggplot() +
  coord_cartesian(ylim = c(0, 60)) +
  geom_rect(aes(xmin = xmin, xmax = xmax, 
                ymin = ymin, ymax = ymax), data = fcsCat,
            alpha  = 0.2, fill = 'dodgerblue') +
  geom_hline(yint = noEducF$FCS, colour = grey90K,
             size = 0.5) +
  geom_segment(y = noEducF$FCS + 0.7, yend = noEducF$FCS + 0.7, 
               x = 0.2, xend = 0.4, colour = grey90K,
               size = 0.5, linetype = 2) +
  #   geom_hline(yint = noEducF$FCS + 3.5, colour = grey90K,
  #              size = 0.5, linetype = 2) +
  #   geom_point(aes(x = x, y = y), size = 4, 
  #              data = margEffects, colour = grey90K) +
  #   geom_violin(aes(x = 0.5, y = FCS),
  #               data = noEducF, fill = NA) +
  geom_text(aes(x = 0.7, 
                y = yavg, label = label), data = fcsCat,
            colour = 'dodgerblue') +
  #   geom_boxplot(aes(x = 0.5, y = FCS),
  #                data = noEducF) + 
  theme_yGrid() +
  theme(axis.text.x = element_blank())

# FCS intepolated plots ---------------------------------------------------
# National FCS value.
avgFCS = mean(bg$FCS)

# bg$div_name = factor(bg$div_name,
#                      c('Sylhet',
#                                 'Chittagong',
#                                 'Barisal',
#                                 'Dhaka', 'Khulna',
#                                 'Rajshahi',
#                                 'Rangpur'))

bg %>% mutate(div = div_name)


yBox = 0.05
yText = 0.045

poorThresh = 28 # FCS "poor" categorisation
borderlineThresh = 42 # FCS "borderline" cutoff
avgColor = '#ce1256'
fillColor = '#fee080'
colText = '#662506'

ggplot(bg, aes(x = FCS)) +
  annotate("rect", xmin = 0, xmax = borderlineThresh, ymin = 0, 
           ymax = yBox, alpha = 0.2)  +
  annotate("rect", xmin = 0, xmax = poorThresh, ymin = 0, 
           ymax = yBox, alpha = 0.2)  +
  annotate("text", x = poorThresh/2, y = yText, label = "poor", 
           size = 4, colour =  "#545454") +
  annotate("text", x = (112 - borderlineThresh)/2 +
             borderlineThresh, y = yText, label = "acceptable", 
           size = 4, colour =  "#545454") +
  geom_vline(xintercept = avgFCS, colour = avgColor, linetype = 2, size = 0.75) +
  geom_density(alpha = 0.4, fill = fillColor) +
  ggtitle("Food Consumption scores (2011/2012)") +
  ylab("percent of households") +
  xlab("food consumption score") +
  facet_wrap(~ div_name) +
  theme_jointplot() +
  theme(strip.background = element_blank(),
        strip.text = element_text(colour = colText),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.y = element_blank())