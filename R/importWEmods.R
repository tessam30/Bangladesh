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
