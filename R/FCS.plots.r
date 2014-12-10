# Clear the workspace
remove(list = ls())

# Load libraries & set working directory

libs <- c ("reshape", "ggplot2", "dplyr")

# Load required libraries
lapply(libs, require, character.only=T)

wd <- c("U:/Bangladesh/Export/")
setwd(wd)

d <- read.csv("food.consumption.score.csv", header = T)

# Change working directory to graphics folder (Graphs)
setwd("U:/Bangladesh/Graph/")

# Lab RGB colors
redL   	<- c("#B71234")
dredL 	<- c("#822443")
dgrayL 	<- c("#565A5C")
lblueL 	<- c("#7090B7")
dblueL 	<- c("#003359")
lgrayL	<- c("#CECFCB")

clr = "YlOrRd"

# Reshape FCS categories for stacked area plot
mdata <- melt(d, id=c("a01","FCS"))
names(mdata) <- c("ID", "FCS", "Food", "Days")


# Create stacked area plot using ggplot2
c <- ggplot(mdata, aes(FCS, Days, group = Food, colour = Food))
c + stat_smooth(se = FALSE) +labs(x ="Food Consumption Score", title = "Bangladesh: Food Consumption Scores by Food Groups", 
		y = "Number of days food was consumed") + scale_y_continuous(breaks = c(1:7.5)) + scale_colour_brewer(palette="Set2")





