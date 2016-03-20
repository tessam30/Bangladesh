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



# simple bar plot of stunting for CO --------------------------------------
childDF = child  %>% 
  filter(!is.na(stunted)) %>% 
  group_by(gender) %>% 
  summarise(y = mean(stunted))

ggplot(childDF, aes(x = gender, y = y, 
                    label = percent(y),
                    fill = factor(gender))) + 
  geom_bar(stat = 'identity') +
  geom_text(size = 5,
            family = 'Segoe UI',
            colour = 'white', vjust = 1,
            nudge_y = -0.03) + 
  # geom_hline(yintercept = childDF$y[1],
             # colour = grey60K) +
  theme_yGrid() + 
  theme(axis.title = element_blank()) +
  ggtitle('Boys are stunted more often than girls') +
  scale_fill_manual(values = colorGender) +
  scale_y_continuous(expand = c(0,0), 
                     limits = c(0, 0.5),
                     breaks = c(0, 0.25, 0.5),
                     labels = percent) +
  scale_x_continuous(breaks = c(0, 1), 
                     labels = c('boys', 'girls'))


# choropleth for CO -------------------------------------------------------
childRegions = child  %>% 
  filter(!is.na(stunted)) %>% 
  group_by(div_name) %>% 
  summarise(y = mean(stunted))

# Simple graph to get colors for choropleth
ggplot(childRegions, aes(x = div_name, y = y, colour = y)) +
  geom_point(size = 10) +
  scale_color_gradientn(colours = brewer.pal(9, 'BuPu'),
                        limits = c(0.35, 0.52))

ggplot(childRegions, aes(x = div_name, y = y, colour = y)) +
  geom_point(size = 10) +
  scale_color_gradientn(colours = brewer.pal(9, 'Purples'),
                        limits = c(0.35, 0.52)) +
  theme_blankLH()

ggplot(childRegions, aes(x = div_name, y = y, colour = y)) +
  geom_point(size = 10) +
  scale_color_gradientn(colours = brewer.pal(9, 'Greys'),
                        limits = c(0.35, 0.56)) +
  theme_blankLH()
 
