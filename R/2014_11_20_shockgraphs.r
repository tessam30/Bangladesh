# Clear the workspace
remove(list = ls())

# Dependencies: 

# Load libraries & set working directory
library(reshape)
library(ggplot2)

wd <- c("U:/Bangladesh/Export/")
setwd(wd)

d <- read.csv("shocks.csv", header = T)

# Change working directory to graphics folder (Graphs)
setwd("U:/Bangladesh/Graph/")

# Lab RGB colors
redL   	<- c("#B71234")
dredL 	<- c("#822443")
dgrayL 	<- c("#565A5C")
lblueL 	<- c("#7090B7")
dblueL 	<- c("#003359")
lgrayL	<- c("#CECFCB")

# Graph Parameters: Set dots per inch for all graphic output; Set color palette
dpi.out = 500
clr = "YlOrRd"

dsub <- d[, c(1:8, 16)]
#total <- (rowSums(dsub[2:7]))
names(dsub) <- c("Division", "Health", "Agriculture", "Financial", "Asset", "Price", "Flood", "Other", "id")

df.melt <- melt(dsub, id = c("Division", "id"))
names(df.melt) <- c("Division", "ID", "Shock", "value")
g <- ggplot(df.melt, aes(x = reorder(factor(Division), -value),
		y = value, fill = factor(df.melt$Shock, 
		levels = rev(levels(df.melt$Shock))))) + geom_bar(stat = "identity") + facet_wrap(~Shock, ncol = 1) 
#Toggle facet wrap depending on type of desired chart.

pp <- g + coord_flip()+labs(x ="Division", title = "Bangladesh: Shock Types", 
		y = "Percent of households reporting shock") + scale_fill_brewer(palette = clr ) +
		theme(legend.position = "top", legend.title=element_blank(),
		panel.background=element_rect(fill="white"), axis.ticks.y=element_blank(),
		axis.text.y  = element_text(hjust=1, size=10, colour = dblueL), axis.ticks.x=element_blank(),
		axis.text.x  = element_text(hjust=1, size=10, colour = dblueL),
		axis.title.x = element_text(colour=dblueL, size=8),
		plot.title = element_text(lineheight=.8, colour = dblueL)) + guides(fill = guide_legend(reverse=TRUE))
	print(pp)
ggsave(pp, filename = paste("Shocks.pct", ".png"), width=8, height=11, dpi=dpi.out)



dsub2 <- d[, c(1, 9:16)]
names(dsub2) <- c("Division", "Health", "Agriculture", "Financial", "Asset", "Price", "Flood", "Other", "id")

df.melt <- melt(dsub2, id = c("Division", "id"))
names(df.melt) <- c("Division", "ID", "Shock", "value")
g <- ggplot(df.melt, aes(x = reorder(factor(Division), -value),
		y = value, fill = factor(df.melt$Shock, 
		levels = rev(levels(df.melt$Shock))))) + geom_bar(stat = "identity") #+ facet_wrap(~Shock, ncol = 1) #Turn on fact wrap


pp <- g + coord_flip()+labs(x ="Division", title = "Bangladesh: Shock Types", 
		y = "Total households reporting shock") +scale_fill_brewer(palette = clr ) +
		theme(legend.position = "top", legend.title=element_blank(),
		 panel.background=element_rect(fill="white"), axis.ticks.y=element_blank(),
		axis.text.y  = element_text(hjust=1, size=10, colour = dblueL), axis.ticks.x=element_blank(),
		axis.text.x  = element_text(hjust=1, size=10, colour = dblueL),
		axis.title.x = element_text(colour=dblueL, size=8),
		plot.title = element_text(lineheight=.8, colour = dblueL)) + guides(fill = guide_legend(reverse=TRUE))
	print(pp)
ggsave(pp, filename = paste("Shocks.total.stacked", ".png"), width=8, height=11, dpi=dpi.out)
