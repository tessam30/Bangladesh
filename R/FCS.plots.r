# Clear the workspace
remove(list = ls())

# Load libraries & set working directory

libs <- c ("reshape", "ggplot2", "dplyr", "RColorBrewer", "grid")

# Load required libraries
lapply(libs, require, character.only=T)

# Set working directory for home or away
wd <- c("U:/Bangladesh/Export/")
#wd <- c("C:/Users/t/Box Sync/Bangladesh/Export")
setwd(wd)

# Load data and rename veg to vegetables
d <- read.csv("food.consumption.score.csv", header = T)
names(d)[names(d) == 'veg'] <- 'vegetables'

# Change working directory to graphics folder (Graphs)
setwd("U:/Bangladesh/Graph/")

# Lab RGB colors
redL     <- c("#B71234")
dredL 	<- c("#822443")
dgrayL 	<- c("#565A5C")
lblueL 	<- c("#7090B7")
dblueL 	<- c("#003359")
lgrayL	<- c("#CECFCB")

# Setting predefined color schema; not used
clr = "YlOrRd"

# Reshape FCS categories for stacked area plot
mdata <- melt(d, id=c("a01","FCS", "div_name", "District_Name", "Upazila_Name"))
names(mdata) <- c("ID", "FCS", "Division", "District", "Upazila", "Food", "Days")

# Check color palettes available.
display.brewer.all()

# Set fontsize for grobs to be included as text on graphs
fsize <- c(16)
fcolor <- c("gray")

# Create customized text as grob to be inserted
my_grobP = grobTree(textGrob("Poor", x=0.075,  y=.55, hjust=0,
  gp=gpar(col=fcolor , fontsize=fsize , fontface="italic")))
my_grobB = grobTree(textGrob("Borderline", x=0.26,  y=.55, hjust=0,
  gp=gpar(col=fcolor , fontsize=fsize , fontface="italic")))
my_grobA = grobTree(textGrob("Acceptable", x=.63,  y=.55, hjust=0,
  gp=gpar(col=fcolor , fontsize=fsize , fontface="italic")))

# Create stacked area plot using ggplot2; First create basic layer
c <- ggplot(mdata, aes(FCS, Days, group = Food, colour = Food))

# Create smoothed lowess of the food categories where days ~ FCS; Add labeels and set x,y padding
pp <- c + stat_smooth(size = 1.25, se = FALSE) + labs(x ="Food Consumption Score", title = "Bangladesh Food Consumption Scores by Food Groups", 
    	y = "Consumed (Days/Week)", colour = lgrayL) + scale_y_continuous(breaks = c(1:7), limits = c(0, 7.01), expand = c(0,0)) + 
    	# Set the color schema and limits for x axis
	scale_colour_brewer(palette="Set2") + scale_x_continuous(breaks = seq(0, 110, by = 10), limits = c(0, 112), expand = c(0,0)) +
	
	# Create vertical lines at 28 and 42 which are thresholds for Bangladesh    
	geom_vline(xintercept=c(28,42), linetype="dotted", size = 1) +
    	
	# Order the legend, remove spaces around lines and adjust background colors and add bounding boxes for thresholds
	theme(legend.position = "top", legend.title=element_blank(), panel.border = element_blank(), legend.key = element_blank(), 
    	panel.background=element_rect(fill="white"), axis.ticks.y=element_blank(),
    	axis.text.y  = element_text(hjust=0, size=10, colour = dgrayL), axis.ticks.x=element_blank(),
    	axis.text.x  = element_text(hjust=0, size=10, colour = dgrayL),
    	axis.title.x = element_text(colour=dgrayL , size=11), strip.background=element_rect(colour="white", fill="white"),
	axis.title.y=element_text(vjust=1.5, colour = dgrayL)) + annotate("rect", xmin = 0, xmax = 28, ymin = 0, ymax = 7,
    	alpha = .15) + annotate("rect", xmin = 28, xmax = 42, ymin = 0, ymax = 7,  alpha = 0.075) +
	annotation_custom(my_grobP) + annotation_custom(my_grobB) + annotation_custom(my_grobA) 
print(pp)
ggsave(pp, filename = paste("FCS.Country", ".png"), width=11, height=8)


# Same graphs but now faceted for the Divisions in Bangladesh
fsize <- c(10)
# Create customized text as grob to be inserted
my_grobP = grobTree(textGrob("Poor", x=0.075,  y=.55, hjust=0,
  gp=gpar(col=fcolor , fontsize=fsize , fontface="italic")))
my_grobB = grobTree(textGrob("Borderline", x=0.26,  y=.55, hjust=0,
  gp=gpar(col=fcolor , fontsize=fsize , fontface="italic")))
my_grobA = grobTree(textGrob("Acceptable", x=.63,  y=.55, hjust=0,
  gp=gpar(col=fcolor , fontsize=fsize , fontface="italic")))

pp <- c + stat_smooth(size = 0.80, se = FALSE) + labs(x ="Food Consumption Score", title = "Bangladesh Food Consumption Scores by Food Groups", 
    	y = "Consumed (Days/Week)", colour = lgrayL) + scale_y_continuous(breaks = c(1:7), limits = c(0, 7.2), expand = c(0,0)) + 
    	# Set the color schema and limits for x axis
	scale_colour_brewer(palette="Set2") + scale_x_continuous(breaks = seq(0, 110, by = 10), limits = c(0, 112), expand = c(0,0)) +
	
	# Create vertical lines at 28 and 42 which are thresholds for Bangladesh    
	geom_vline(xintercept=c(28,42), linetype="dotted", size = 1) +
    	
	# Order the legend, remove spaces around lines and adjust background colors and add bounding boxes for thresholds
	theme(legend.position = "top", legend.title=element_blank(), panel.border = element_blank(), legend.key = element_blank(), 
    	panel.background=element_rect(fill="white"), axis.ticks.y=element_blank(),
    	axis.text.y  = element_text(hjust=0, size=10, colour = dgrayL), axis.ticks.x=element_blank(),
    	axis.text.x  = element_text(hjust=0, size=10, colour = dgrayL),
    	axis.title.x = element_text(colour=dgrayL , size=11), strip.background=element_rect(colour="white", fill="white"),
	axis.title.y=element_text(vjust=1.5, colour = dgrayL)) + annotate("rect", xmin = 0, xmax = 28, ymin = 0, ymax = 7,
    	alpha = .15) + annotate("rect", xmin = 28, xmax = 42, ymin = 0, ymax = 7,  alpha = 0.075) +
	annotation_custom(my_grobP) + annotation_custom(my_grobB) + annotation_custom(my_grobA) +
	facet_wrap(~Division, ncol = 1)
print(pp)

* Create ggvis graph using data
mdata %>% 
  ggvis(~FCS, ~Days) %>%
  group_by(Food) %>%
  layer_model_predictions(model = "loess", se = FALSE, stroke = ~Food) %>%
  add_axis("x", title = "Food Consumption Score") %>%
  add_axis("y", title = "Consumed (days/week)")

       
        
