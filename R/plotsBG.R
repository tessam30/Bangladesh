

# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')

# Import plotting functions -----------------------------------------------
source('~/GitHub/Bangladesh/R/reusablePlots.r')


# << Stunting >> ----------------------------------------------------------



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

  
  

# stunting point estimates ------------------------------------------------
  boysStunting = child %>% 
    filter(gender == 0,
           !is.na(stunted))
  
  pairGrid(boysStunting, 'stunted', 'div_name', 
           fileMain = '~/Documents/USAID/Bangladesh/plots/boysStunting.pdf', 
           fileHHsize = '~/Documents/USAID/Bangladesh/plots/boysStunting_HH.pdf', 
           xLim = c(0, .7), 
           colorDot = brewer.pal(9, 'Blues'), rangeColors = c(0,1), 
           colorSE = brewer.pal(9, 'Blues')[3], alphaSE = 0.4, 
           regionOrder = c(2,5,3,1,6,4,7))
  
  girlsStunting = child %>% 
    filter(gender == 1,
           !is.na(stunted))
  
  pairGrid(girlsStunting, 'stunted', 'div_name', 
           fileMain = '~/Documents/USAID/Bangladesh/plots/girlsStunting.pdf', 
           fileHHsize = '~/Documents/USAID/Bangladesh/plots/girlsStunting_HH.pdf', 
           xLim = c(0, .7), 
           colorDot = femaleGradient, rangeColors = c(0, 1), 
           colorSE = femaleGradient[2], alphaSE = 0.4, 
           regionOrder = c(2,5,3,1,6,4,7))

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

