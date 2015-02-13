# Purpose: Analyze food security data for point patterns and create rasters
# AUthor: Tim Essam, Phd
# Date: 2/13/2015

# Clear workspace
remove(list = ls())

# Load libraries needed for anlaysis
libs <- c("geoR", "akima", "leaflet", "dplyr",
          "lattice", "sp", "maptools", "raster",
          "rgdal", "maps", "mapdata", "RgoogleMaps",
          "mapproj", "RColorBrewer", "ape")

lapply(libs, require, character = TRUE)

# Set working directory

wdlt <- c("C:/Users/Tim/Documents/Bangladesh/GIS/Datain")
setwd(wdlt)

d <- read.csv("foodsecurity.csv", header = TRUE)

