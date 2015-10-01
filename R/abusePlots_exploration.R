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
  ggtitle('reported stunting by enumerator id')