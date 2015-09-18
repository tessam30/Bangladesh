

# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')

# Import plotting functions -----------------------------------------------
source('~/GitHub/Bangladesh/R/reusablePlots.r')


# << Stunting >> ----------------------------------------------------------



# choropleth values: mean stunting rates. ---------------------------------

stuntVal = child %>% 
  group_by(gender, div_name) %>% 
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
colorMale = '#27aae1'
colorFemale = '#E37686'
yMax = 0.6
width1 = 6
height1 = 3

colorGender = c(colorMale, colorFemale)

ggplot(child, aes(x = ageMonths, y = stunted, colour = factor(gender))) + 
    geom_smooth(se=FALSE, size=1) +
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


# exploration -------------------------------------------------------------
# wealth
# education
# literacy
# breast feeding
# fcs
# dd
# cows
# firstBorn
#birthGap

# Nothing: breastfed, birthGap
ggplot(child, aes(y = wasted, x = birthGap, colour = factor(gender))) +
  geom_smooth() +
  theme_box_ygrid()



# << Total Shocks >> ------------------------------------------------------


# Heatmap shocks by region ------------------------------------------------

shockCols = c("healthshkR", "medexpshkR", "hazardshkR",
              "agshkR",     "assetshkR",
              "assetshk2R", "finshkR", "priceshkR")

# x=bg  %>% select(one_of(shockCols)) %>% summarise_each(funs(mean))
orderShks = rev(c('healthshkR', 'medexpshkR', 'priceshkR',     
              'agshkR',    'finshkR', 'hazardshkR',  'assetshkR', 'assetshk2R'))

orderRegions = c('Barisal',    'Sylhet',     'Khulna',
'Rajshahi',   'Rangpur',    'Dhaka',      'Chittagong')

x = bg %>% 
  group_by(div_name) %>% 
  summarise(mean(shkTot), s = mean(shk)) %>% 
  arrange(desc(s)) %>% 
  select(div_name)

shkHeatmap(bg, shockCols, regionCol = 'div_name')

ggplot(data= bg, aes(x = priceshkTot)) +geom_histogram()


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


# country average ---------------------------------------------------------
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



# shock by profession -----------------------------------------------------
View(bg %>% 
  group_by(occupHoh, div_name) %>% 
  summarise(avg = percent(mean(medexpshkR)), n()) %>% 
  arrange(desc(avg)))

View(bg %>%
group_by(occupHoh == 8, div_name) %>%
summarise(avg = percent(mean(medexpshkR)), n()) %>%
arrange(desc(avg)))


View(bg %>%
       group_by(occupHoh) %>%
       summarise(avg = percent(mean(hazardshkR)), n()) %>%
       arrange(desc(avg)))

View(bg %>%
       group_by(occupHoh == 8, div_name) %>%
       summarise(avg = percent(mean(hazardshkR)), n()) %>%
       arrange(desc(avg)))



# coping ------------------------------------------------------------------

ß
