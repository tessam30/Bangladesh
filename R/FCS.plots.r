# Clear the workspace
remove(list = ls())

# Load libraries & set working directory

libs <- c ("reshape", "ggplot2", "dplyr", "RColorBrewer")

# Load required libraries
lapply(libs, require, character.only=T)

wd <- c("C:/Bangladesh/Export/")
wd <- c("C:/Users/t/Box Sync/Bangladesh/Export")
setwd(wd)

d <- read.csv("food.consumption.score.csv", header = T)

# Change working directory to graphics folder (Graphs)
setwd("U:/Bangladesh/Graph/")

# Lab RGB colors
redL     <- c("#B71234")
dredL 	<- c("#822443")
dgrayL 	<- c("#565A5C")
lblueL 	<- c("#7090B7")
dblueL 	<- c("#003359")
lgrayL	<- c("#CECFCB")

clr = "YlOrRd"

# Reshape FCS categories for stacked area plot
mdata <- melt(d, id=c("a01","FCS"))
names(mdata) <- c("ID", "FCS", "Food", "Days")

# Check color palettes available.
display.brewer.all()

# Create stacked area plot using ggplot2
c <- ggplot(mdata, aes(FCS, Days, group = Food, colour = Food))
c + stat_smooth(se = FALSE, size = 1.25) +labs(x ="Food Consumption Score", title = "Bangladesh: Food Consumption Scores by Food Groups", 
    y = "Number of days food was consumed") + scale_y_continuous(breaks = c(1:7.5), limits = c(0, 7)) +
    scale_colour_brewer(palette="Accent") + scale_x_continuous(breaks = seq(0, 110, by = 10)) +
    geom_vline(xintercept=c(28,42), linetype="dotted", size = 1) +
    geom_rect(aes(xmin = 0, xmax = 28, ymin = 0, ymax=7), alpha = 10)



+ scale_fill_brewer(palette = clr ) +
  theme(legend.position = "top", legend.title=element_blank(),
        panel.background=element_rect(fill="white"), axis.ticks.y=element_blank(),
        axis.text.y  = element_text(hjust=1, size=10, colour = dblueL), axis.ticks.x=element_blank(),
        axis.text.x  = element_text(hjust=1, size=10, colour = dblueL),
        axis.title.x = element_text(colour=dblueL, size=8),
        
        
        
