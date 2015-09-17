# -------------------------------------------------------------------------
# Function to import, clean, and load in useful things for analysis of
# Bangladesh Livelihoods.
# 
# Laura Hughes, lhughes@usaid.gov, September 2015
# -------------------------------------------------------------------------


# Import data -------------------------------------------------------------

source('~/GitHub/Bangladesh/R/setupFncnsBG.r')

# -- Read in data --
bgRaw = read_dta('~/Documents/USAID/Bangladesh/Data/BNG_201509_all.dta')
bg = removeAttributes(bgRaw)

child= read_dta('~/Documents/USAID/Bangladesh/Data/ChildHealth_ind.dta')



# Mutations ---------------------------------------------------------------

child = child %>% 
  mutate(stuntedBin = ifelse(stunted == 1, 1, 0), # Removing NAs to get an aggregate number
         underwgtBin = ifelse(underwgt == 1, 1, 0),
         wastedBin = ifelse(wasted == 1, 1, 0),
         malnourished = stuntedBin + underwgtBin + wastedBin)


# Exploration -------------------------------------------------------------






# to do -------------------------------------------------------------------

# 1) change / cleanup all theme files.
# 2) Change all colors to soft black, consistent w/ other colors.
# 3) Write quick style guide and setup AI files
# 4) Import segoe
# 5) get a base BG map with terrain, etc.



# Import month data, since Tim deleted it ---------------------------------

ctrl = child %>% 
  filter(hh_type == 2, !is.na(stunted)) %>%
  select(stunted)

# stunted -----------------------------------------------------------------


ftf = child %>% 
  filter(hh_type == 1, !is.na(stunted)) %>% 
  select(stunted)

ftf = as.matrix(ftf)

ctrl = as.matrix(ctrl)

s = broom::tidy(t.test(ctrl, ftf))





# wasted ------------------------------------------------------------------
ctrl = child %>% 
  filter(hh_type == 2, !is.na(wasted)) %>%
  select(wasted)

ftf = child %>% 
  filter(hh_type == 1, !is.na(wasted)) %>% 
  select(wasted)

ftf = as.matrix(ftf)

ctrl = as.matrix(ctrl)

w = broom::tidy(t.test(ctrl, ftf))


# underwgt ------------------------------------------------------------------
ctrl = child %>% 
  filter(hh_type == 2, !is.na(underwgt)) %>%
  select(underwgt)

ftf = child %>% 
  filter(hh_type == 1, !is.na(underwgt)) %>% 
  select(underwgt)

ftf = as.matrix(ftf)

ctrl = as.matrix(ctrl)

u = broom::tidy(t.test(ctrl, ftf))



# by time -----------------------------------------------------------------
bg_raw = read.csv('~/Downloads/bihs_usaid_4.23.2013/household/data/csv/038_mod_t1_male.CSV')

t1_raw = read_dta('~/Documents/USAID/Bangladesh/Data/male_mod_t1_002.dta')

nHH = length(unique(t1_raw$a01))

t1_raw = t1_raw %>% 
  mutate(month = t1_04, year = t1_05, shkCode = t1_02,
         month = ifelse(month < 10, sprintf('%02d', month), month),
         time = ymd(paste0(year, month, '01')),
         shk = ifelse(t1_03 == 0, 0, 
                      ifelse(t1_03 > 0, 1, NA)),
         shkCat = ifelse(
           shkCode %in% 1:4, 'health',
           ifelse(shkCode %in% c(9, 10, 11, 12, 13), 'ag',
                  ifelse(shkCode %in% c(14, 15, 16, 17), 'asset2',
                         ifelse(shkCode == 32, 'price', 'other')))
         ))


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
