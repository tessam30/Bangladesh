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
