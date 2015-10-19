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
