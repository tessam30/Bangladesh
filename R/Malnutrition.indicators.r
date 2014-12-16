# Create 


# Clear the workspace
remove(list = ls())


# Load libraries & set working directory

libs <- c ("reshape", "ggplot2", "dplyr", "RColorBrewer", "grid", "scales")

# Load required libraries
lapply(libs, require, character.only=T)

# Set working directory for home or away
wd <- c("U:/Bangladesh/Export/")
#wd <- c("C:/Users/t/Box Sync/Bangladesh/Export")
setwd(wd)

# Load data and rename veg to vegetables
d <- read.csv("malnutrition.csv", header = T)

ddiv <- d[, c(1, 3, 5, 7)]
ddis <- d[, c(1, 2, 4, 6, 8)]
names(ddis) <- c("Division", "District", "stunted", "underweight", "wasted") 

ddis.melt <- melt(ddis, id =c("Division", "District"))

# Change working directory to graphics folder (Graphs)
setwd("U:/Bangladesh/Graph/")

# Lab RGB colors
redL     <- c("#B71234")
dredL 	<- c("#822443")
dgrayL 	<- c("#565A5C")
lblueL 	<- c("#7090B7")
dblueL 	<- c("#003359")
lgrayL	<- c("#CECFCB")

# Setting predefined color schema; and dpi settings
clr = "YlOrRd"
dpi.out = 500
display.brewer.all()

# Create rotated bar graph using ggplot2

g <- ggplot(ddis.melt, aes(x = reorder(factor(District), value),
		y = value, fill = factor(ddis.melt$variable, levels = rev(levels(ddis.melt$variable))))) +
		geom_bar(stat = "identity") + facet_wrap(~variable)
pp <- g + coord_flip()+labs(x ="District", title = "Malnutrition Indicators by District (unweighted)", y = "Percent of children in District") +
	scale_fill_brewer(palette = "Set2") +
	theme(legend.position = "top", legend.title=element_blank(),
	panel.background=element_rect(fill="white"), axis.ticks.y=element_blank(),
	axis.text.y  = element_text(hjust=1, size=10, colour = dgrayL), axis.ticks.x=element_blank(),
	axis.text.x  = element_text(hjust=1, size=10, colour = dgrayL),
	axis.title.x = element_text(colour= dgrayL, size=8), 
	panel.grid.major.x = element_line(colour = lgrayL, linetype = "dashed"),
	plot.title = element_text(lineheight=.8, colour = "black")) + 
	guides(fill = guide_legend(reverse=TRUE))+ scale_y_continuous(labels = percent)
print(pp)
ggsave(pp, filename = paste("Malnutrition", ".png"), width=11, height=11, dpi = dpi.out)
