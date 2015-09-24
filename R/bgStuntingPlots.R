# Bangladesh stunting plots


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


child %>% 
  group_by(div_name, FCS > 53) %>% 
  summarise(nObs = n()) %>% 
  mutate(pct = percent(nObs/sum(nObs)))
