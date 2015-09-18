# Purpose: Run satial logistic regressions on shock variables
# Author: Tim Essam, PhD (USAID GeoCenter)
# Date: 2015/08/07
# packages: RColorBrewer, spdep, classInt, foreign, MASS, maptools, ggplot2


# Clear the workspace
# Reboot R-studio session using cntl+shift+f10


req_lib <- c("RColorBrewer", "spdep", "classInt", "foreign", "MASS", "maptools", "ggplot2",  "dummies", "useful", "coefplot", "haven", "reshape2", "dplyr")
lapply(req_lib, library, character.only = TRUE)

# --- Set working directory for home or away
wd <- c("U:/Bangladesh/Dataout/")
wdw <- c("C:/Users/Tim/Documents/Bangladesh/Dataout")
wdh <- c("C:/Users/t/Documents/Bangladesh/Dataout")
setwd(wdw)

file.name = "BGD_201509_SpatFilter.dta"

d <- data.frame(read_dta(file.name))
names(d)
str(d)


removeAttributes <- function (data) {
  data <- lapply(data, function(x) {attr(x, 'labels') <- NULL; x})
  data <- lapply(data, function(x) {attr(x, 'label') <- NULL; x})
  data <- lapply(data, function(x) {attr(x, 'class') <- NULL; x})
  data <- lapply(data, function(x) {attr(x, 'levels') <- NULL; x})
  data = data.frame(data)
}

d.clean <- removeAttributes(d)

# -- Disable scientific notiation
options(scipen = 999)


# Convert factors to numeric so they don't enter regression as dummies
# cols <- c(15, 20, 27, 28, 29, 30)
# names(d[cols])
# d[, cols]  <- apply(d[, cols], 2, function(x) as.numeric(x))

# Select only households that have a latitude and longitude
d.gps <- filter(d.clean , !is.na(latitude), !is.na(longitude))

x <- d.gps$longitude
y <- d.gps$latitude

# --- Plotting data to check it's correct
# Plot data to check consistency
bgn.coord <- SpatialPoints(d.gps[, c("longitude", "latitude")])
d.gps2 <- SpatialPointsDataFrame(bgn.coord, d.gps)
coord_bgn <- coordinates(d.gps2)

class(d.gps2)
bgn_k2 <- knn2nb(knearneigh(coord_bgn, k = 2, longlat = T))

# Plot the results
plot(as(d.gps2, "Spatial"), axes = T)
plot(bgn_k2, coord_bgn, add = T)
plot(d.gps2[d.gps2$priceshkR == 1, ], col = "red", add = TRUE)

# --- Set up a spatial weights matrix for regressions
# Using a distance threshold of 100 to ensure everyone has a neighbor
xy <- as.matrix(d.gps[2:3])
distThresh <- dnearneigh(xy, 0, 100, longlat = TRUE)

# Set up a distance threshold of a weights matrix within 100km
weights <- nb2listw(distThresh, style = "W")

# Use dummy to create dummy vars; Not program is a bit buggy hence all the repetition; TODO: redo in dplyreducMDum <
educMDum <- dummy(d.gps$educAdultM_cat2)
educMDum <- as.data.frame(educMDum)
educMDum <- rename(educMDum, No_educ_male = educAdultM_cat20,
                   Primary_male = educAdultM_cat21,
                   Secondary_male = educAdultM_cat22)

educFDum <- dummy(d.gps$educAdultF_cat2)
educFDum <- as.data.frame(educFDum)
educFDum <- rename(educFDum, No_educ_female = educAdultF_cat20,
                   Primary_female = educAdultF_cat21,
                   Secondary_female = educAdultF_cat22)

# combine vectors of dummies
d.reg <- cbind.data.frame(d.gps, educMDum, educFDum)

# Define exogenous paramenters for the model
exog.all <- dplyr::select(d.reg, farmOccupHoh, religHoh, marriedHead, femhead, agehead, literateHead,
                          Primary_male, Secondary_male, Primary_female, Secondary_female,
                          hhsize, depRatio, sexRatio, mlabor, flabor, dfloor, electricity,
                          latrineSealed, mobile, landless, migration)
exog.all2 <- dplyr::select(d.reg, farmOccupHoh, religHoh, marriedHead, femhead, agehead, literateHead,
                           Primary_male, Secondary_male, Primary_female, Secondary_female,
                           hhsize, depRatio, sexRatio, mlabor, flabor, landless, migration,
                           wealthIndex, TLUtotal_trim, logland)

# Run the SAR error model
## This applies a spatial error model.  The catch is that this essentially treats it as a linear regression,
## ignoring any complexity from the fact that the shocks are really binary variables.
#sar <- errorsarlm(depvar ~ exog, listw = weights, na.action = na.omit)
#summary(sar)

#Create spatial filter by calculating eigenvectors.
weightsB <- nb2listw(distThresh, style = "B")

## We need a non-row-standardized set of weights here, so style = "B"
n <- length(distThresh)
M <- diag(n) - matrix(1,n,n)/n
B <- listw2mat(weightsB)
MBM <- M %*% B %*% M
eig <- eigen(MBM, symmetric=T)
EV <- as.data.frame( eig$vectors[ ,eig$values/eig$values[1] > 0.25])

# Format a pipeline for the regressions
source("C:/Users/Tim/Documents/GitHub/Bangladesh/R/Models/results.formatter.R")

# Set up formatting for table and alignment of columns
two_digits <- . %>% fixed_digits(3)
table_names <- c("Parameter", "Estimate", "Std. Err.", "_t_", "_p_")
alignment <- c("l", "r", "r", "r", "r")
fix_names <- . %>% str_replace_all("x.vars", "")

# Setup automation to format table as desired
format_model_table <- . %>%
  mutate_each(funs(two_digits),
              -term, -p.value) %>%
  mutate(term = fix_names(term),
         p.value = format_pval(p.value)) %>%
  set_colnames(table_names)

# Look at the eigenvectors to see how the patterns play out spatially
EV.gps <- cbind.data.frame(EV, lat = d.gps$latitude, lon = d.gps$longitude, hhid = d.gps$a01)

# melt the EV into a stacked data frame to plot a faceted graph of all EV
EV_melt <- melt(EV.gps, id = c("hhid", "lon", "lat"))

ggplot(EV_melt, aes(x = lon, y = lat, colour = value, size = abs(value))) + geom_point() +
  facet_wrap(~variable, ncol = 4) +
  scale_colour_gradientn(colours = brewer.pal(11, 'RdYlBu')) +
  theme_classic() + ggtitle("Eigenvectors for Bangladesh IHS")

write.csv(EV.gps, file = "Eigenvectors.2014.csv")

#-----------------------------#
# Spatial Filter Models Start #
#-----------------------------#

exog <- as.matrix(exog.all2)
modeltype <- binomial(link = "logit")
#modeltype <- gaussian()

# ---- Medical Shocks ---
y.vars <- d.gps$medexpshkR
x.vars <- exog
full.glm <- glm(y.vars ~ x.vars +., data = EV, family = modeltype)
med.res <- stepAIC(glm(y.vars ~ x.vars , data=EV, family=modeltype),
                     scope=list(upper=full.glm), direction="forward")

medical.Result <- tidy(med.res) %>% format_model_table
medical.Result %>% kable(align = alignment)
#*morans_test(med.res)

# ---- Hazard Shocks ---
y.vars <- d.gps$hazardshkR
full.glm <- glm(y.vars ~ x.vars +., data = EV, family = modeltype)
haz.res <- stepAIC(glm(y.vars ~ x.vars , data=EV, family= modeltype),
                     scope=list(upper=full.glm), direction="forward")

haz.Result <- tidy(haz.res) %>% format_model_table
haz.Result %>% kable(align = alignment)
#morans_test(price.res)

# Plot main eigenvectors to see where spatial patterns are prominent


# ---- Agriculture Shocks ---
y.vars <- d.gps$agshkR
full.glm <- glm(y.vars ~ x.vars +., data = EV, family = modeltype)
ag.res <- stepAIC(glm(y.vars ~ x.vars , data=EV, family= modeltype),
                   scope=list(upper=full.glm), direction="forward")

ag.Results <- tidy(ag.res) %>% format_model_table
ag.Results %>% kable(align = alignment)
#morans_test(ag.res)

# ---- Price Shocks ---
y.vars <- d.gps$priceshkR
full.glm <- glm(y.vars ~ x.vars +., data = EV, family = modeltype)
price.res <- stepAIC(glm(y.vars ~ x.vars , data=EV, family= modeltype),
                  scope=list(upper=full.glm), direction="forward")

price.Results <- tidy(price.res) %>% format_model_table
price.Results %>% kable(align = alignment)
#morans_test(ag.res)

# ---- Diet Diversity ---
y.vars <- d.gps$dietDiv
full.glm <- glm(y.vars ~ x.vars +., data = EV, family = gaussian())
dd.res <- stepAIC(glm(y.vars ~ x.vars , data=EV, family=gaussian()),
                     scope=list(upper=full.glm), direction="forward")

dd.Results <- tidy(dd.res) %>% format_model_table
dd.Results %>% kable(align = alignment)
#morans_test(ag.res)


