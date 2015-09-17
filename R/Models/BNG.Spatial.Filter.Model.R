# Purpose: Run satial logistic regressions on shock variables
# Author: Tim Essam, PhD (USAID GeoCenter)
# Date: 2015/08/07
# packages: RColorBrewer, spdep, classInt, foreign, MASS, maptools, ggplot2


# Clear the workspace
# Reboot R-studio session using cntl+shift+f10


req_lib <- c("RColorBrewer", "spdep", "classInt", "foreign", "MASS", "maptools", "ggplot2",  "dummies", "useful", "coefplot", "haven", "dplyr")
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

x <- d.gps$latitude
y <- d.gps$longitude

# --- Plotting data to check it's correct
# Plot data to check consistency
bgn.coord <- SpatialPoints(d.gps[, c("longitude", "latitude")])
d.gps2 <- SpatialPointsDataFrame(bgn.coord, d.gps)
coord_bgn <- coordinates(d.gps2)

class(d.gps2)
bgn_k2 <- knn2nb(knearneigh(coord_bgn, k = 2, longlat = T))

# Plot the results
plot(as(d.gps2, "Spatial"), axes = T)
plot(eth_k2, coord_bgn, add = T)
plot(d.gps2[d.gps2$mobile == 1, ], col = "red", add = TRUE)

# --- Set up a spatial weights matrix for regressions
# Using a distance threshold of 125 to ensure everyone has a neighbor
xy <- as.matrix(d.gps[26:27])
distThresh <- dnearneigh(xy, 0, 100, longlat = TRUE)

# Set up a distance threshold of a weights matrix within 100km
weights <- nb2listw(distThresh, style = "W")

# Use dummy to create dummy vars; Not program is a bit buggy hence all the repetition; TODO: redo in dplyr
religDum <- dummy(d.gps$religHoh)
religDum <- as.data.frame(religDum[, 1:4]) # Drop NAs from analysis
religDum <- rename(religDum, Protestant = religHoh3, Muslim = religHoh4, Other = religHoh7)
landqDum <- dummy(d.gps$landQtile_lag)
landqDum <- as.data.frame(landqDum[, 1:4])

landqDum2 <- dummy(d.gps$landQtile)
landqDum2 <- as.data.frame(landqDum2[, 1:4])

educMDum <- dummy(d.gps$educAdultM_cat)
educMDum <- as.data.frame(educMDum)
educMDum <- rename(educMDum, No_educ_male = educAdultM_cat0,
                   Primary_male = educAdultM_cat1,
                   Secondary_male = educAdultM_cat2,
                   Tertiary_male = educAdultM_cat3)
educFDum <- dummy(d.gps$educAdultF_cat)
educFDum <- as.data.frame(educFDum)
educFDum <- rename(educFDum, No_educ_female = educAdultF_cat0,
                   Primary_female = educAdultF_cat1,
                   Secondary_female = educAdultF_cat2,
                   Tertiary_female = educAdultF_cat3)

# combine vectors of dummies
d.reg <- cbind.data.frame(d.gps, religDum, landqDum, landqDum2, educMDum, educFDum)

# Define exogenous paramenters for the model
exog.all <- dplyr::select(d.reg, agehead, ageheadsq, femhead, marriedHoh, vulnHead,
                          Protestant, Muslim, Other, literateHoh,
                          Primary_male, Secondary_male, Tertiary_male,
                          Primary_female, Secondary_female, Tertiary_female,
                          gendMix, ae, mlabor, flabor, hhsize,
                          ftfzone, TLUtotal_cnsrd_lag, wealthIndex_lag, landHectares_lag, landQtile_lag2,
                          landQtile_lag3, landQtile_lag4, iddirMemb_lag)
exog <- as.matrix(exog.all)


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
