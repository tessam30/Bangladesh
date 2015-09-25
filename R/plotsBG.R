# Shock plots, Bangladesh Livelihoods Analysis
# Laura Hughes, lhughes@usaid.gov, October 2015.

# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')

# Import plotting functions -----------------------------------------------
source('~/GitHub/Bangladesh/R/reusablePlots.r')




# << Total Shocks >> ------------------------------------------------------


# Heatmap shocks by region ------------------------------------------------
regionCol = 'div_name'
shockCols = c("medexpshkR", "priceshkR","hazardshkR", "edshkposR")

# x=bg  %>% select(one_of(shockCols)) %>% summarise_each(funs(mean))
orderShks = rev(c('medexpshkR', 'priceshkR',     
              'hazardshkR',  'edshkposR'))

# bg %>% 
#   select(one_of(shockCols), -edshkposR, div_name) %>% 
#   gather(type, shk, -div_name) %>% 
#   group_by(div_name) %>% 
#   summarise(s = mean(shk)) %>% 
#   arrange(desc(s)) %>% 
#   select(div_name)

orderRegions = c('Chittagong', 'Sylhet', 'Barisal', 'Rangpur', 'Dhaka', 'Khulna', 'Rajshahi')


# ! Note-- need to remove negative signs from the educ shk data!!  
# Reversed so the colors are right, since edshk are good.
shkHeatmap(bg, shockCols, regionCol = 'div_name', colorAvg = brewer.pal(9, 'Greens'),
           rangeAvg = c(0, .3),
           orderRegions = orderRegions, orderShks = orderShks)


ggsave('~/Documents/USAID/Bangladesh/plots/totalShk_heat.pdf', 
       width = 15*.7*.8, height = 6*.8,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)

ggsave('~/Documents/USAID/Bangladesh/plots/totalShk_heat_avgRd.pdf', 
       width = 15*.7*.8/4, height = 6*.8,
       bg = 'transparent',
       paper = 'special',
       units = 'in',
       useDingbats=FALSE,
       compress = FALSE,
       dpi = 300)


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


shkProf = bg %>% 
  filter(!is.na(occupCat)) %>% 
  group_by(occupCat) %>% 
  select(one_of(shockCols)) %>% 
  summarise(shock = mean(medexpshkR), nObs = n())

ggplot(shkProf, aes(y = occupCat, size = nObs,
                    x = shock)) +
  geom_point() +
  scale_x_continuous(breaks = seq(0, 0.3, by = 0.1),
                     limits = c(0, 0.3)) +
  theme_xGrid() +
  theme(legend.position = 'left')

occupHH = bg %>% 
  filter(!is.na(occupCat))

pairGrid(occupHH, 'medexpshkR', 'occupCat', 
         fileMain = '~/Documents/USAID/Bangladesh/plots/occup_med.pdf', 
         fileHHsize = '~/Documents/USAID/Bangladesh/plots/occup.pdf', 
         widthAvg = 2,
         heightAvg = 2.25,
         sizeAnnot = 4,
         xLim = c(0, .3), 
         annotAdj = -0.25,
         rangeColors = c(0, 0.3))

pairGrid(occupHH, 'hazardshkR', 'occupCat', 
         fileMain = '~/Documents/USAID/Bangladesh/plots/occup_haz.pdf', 
         fileHHsize = '~/Documents/USAID/Bangladesh/plots/occup.pdf', 
         widthAvg = 2,
         heightAvg = 2.25,
         sizeAnnot = 4,
         xLim = c(0, .3), 
         annotAdj = -0.25,
         rangeColors = c(0, 0.3))


pairGrid(occupHH, 'priceshkR', 'occupCat', 
         fileMain = '~/Documents/USAID/Bangladesh/plots/occup_price.pdf', 
         fileHHsize = '~/Documents/USAID/Bangladesh/plots/occup.pdf',
         widthAvg = 2,
         heightAvg = 2.25,
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



