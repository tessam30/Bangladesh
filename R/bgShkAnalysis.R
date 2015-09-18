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



# Boxplot of prices vs. coping --------------------------------------------

coping = shkR %>% filter(!is.na(cope1Cat), shkCat == 'medexp')  %>% group_by(cope1Cat) %>% summarise(num=n())


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

ggplot(shkR %>% filter(!is.na(cope1Cat), shkCat == 'ag'), 
       aes(x = cope1Cat, y = logShkVal, colour = copeClass)) +
  geom_boxplot(size = 0.3)+ 
  geom_point(alpha = 0.2, size = 4)+ 
  coord_flip() +
  scale_y_continuous(limits = c(3, 6),
                     breaks = 3:6,
                     expand = c(0.2, 0.1),
                     labels = c("1,000", "10,000","100,000", "1,000,000")) +
  scale_colour_manual(values = c('bad' = ftfOrange, 'good' = '#66bd63', 'none' = '#4eb3d3')) +
  theme_xGrid() +
  ylab('estimated cost of shock')


ggplot(shkR %>% filter(!is.na(cope1Cat), shkCat == 'ag'), 
       aes(x = cope1Cat, y = logShkVal, colour = copeClass)) +
  geom_boxplot(size = 0.3)+ 
  geom_point(alpha = 0.2, size = 4)+ 
  coord_flip() +
  scale_y_continuous(limits = c(3, 6),
                     breaks = 3:6,
                     expand = c(0.2, 0.1),
                     labels = c("1,000", "10,000","100,000", "1,000,000")) +
  scale_colour_manual(values = c('bad' = ftfOrange, 'good' = '#66bd63', 'none' = '#4eb3d3')) +
  theme_xGrid() +
  ylab('estimated cost of shock')


# other -------------------------------------------------------------------


ggplot(shkR %>% filter(!is.na(cope1Cat), shkCat == 'health'), 
       aes(x = cope1Cat, y = shkLength, colour = shkValue)) +
  geom_point(alpha = 0.25, size = 4)+ 
  scale_colour_gradientn(colours = brewer.pal(9, 'PuRd'),
                         limits = c(100, 50000)) +
  coord_flip() +
  theme_jointplot()

ggplot(shkR, aes(x = cope1Cat, y= shkLength)) +
  geom_hex() +
  scale_fill_gradientn(colours = brewer.pal(9, 'PuRd')) +
  # stat_smooth() +
  theme_jointplot() 



x = t1_raw %>% 
  group_by(shkCode, time) %>% 
  summarise(nObs = n() / nHH) %>% 
  filter(shkCode %in% c(3,4,9,10,14,15,16,19,32,34),
         !is.na(time))


ggplot(x, aes(x = time, y = nObs)) +
  geom_line(size = 1, colour = 'dodgerblue') +
  facet_wrap(~shkCode) + 
  theme_jointplot()

x = bg_raw %>% 
  group_by(shkCode, month) %>% 
  summarise(nObs = n()) %>% 
  filter(shkCode %in% c(4,32))

ggplot(x, aes(x = month, y = nObs)) +
  geom_point(size = 4, colour = 'salmon') +
  facet_wrap(~shkCode, scales  = 'free_y') + 
  theme_jointplot()


x = bg_raw %>% 
  group_by(shkCat, time) %>% 
  summarise(nObs = n()) 

ggplot(x, aes(x = time, y = nObs)) +
  geom_line(size = 1, colour = 'seagreen') +
  facet_wrap(~shkCat, scales  = 'free_y') + 
  theme_jointplot()

x = bg_raw %>% 
  group_by(shkCat, month) %>% 
  summarise(nObs = n()) 

x = bg_raw %>% 
  group_by(year, shkCat, month) %>% 
  summarise(nObs = n()) %>% 
  mutate(pct = nObs / sum(nObs))

ggplot(x, aes(x = month, y = pct)) +
  stat_summary(fun.y = 'mean', geom = 'point', size = 4, colour = 'tomato') +
  facet_wrap(~shkCat, scales  = 'free_y') + 
  theme_jointplot()