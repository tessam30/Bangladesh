# All plots for FCS data, Bangladesh Livelihoods Analysis
# October 2015, Laura Hughes, lhughes@usaid.gov

# Import data -------------------------------------------------------------
source('~/GitHub/Bangladesh/R/importBGdata.r')



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