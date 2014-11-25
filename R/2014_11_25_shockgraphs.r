# Purpose: Create district-level tables of the shocks using both counts and percentages.

# Clear the workspace
remove(list = ls())

# Load libraries & set working directory

libs <- c ("reshape", "ggplot2", "MASS", "dplyr", "GGally")

# Load required libraries
lapply(libs, require, character.only=T)

wd <- c("U:/Bangladesh/Export/")
setwd(wd)

d <- read.csv("shocks_district.csv", header = T)

# Change working directory to graphics folder (Graphs)
setwd("U:/Bangladesh/Graph/")

# Lab RGB colors (not used)
redL   	<- c("#B71234")
dredL 	<- c("#822443")
dgrayL 	<- c("#565A5C")
lblueL 	<- c("#7090B7")
dblueL 	<- c("#003359")
lgrayL	<- c("#CECFCB")

# Graph Parameters: Set dots per inch for all graphic output; Set color palette
dpi.out = 500
clr = "YlOrRd"

d.pct <- d[, c(1:9)]
d.num <- d[, c(1:2, 10:16)]
names(d.pct) <- c("Division", "District", "Health", "Agriculture", "Financial", "Asset", "Price", "Flood", "Other")
names(d.num) <- c("Division", "District", "Health", "Agriculture", "Financial", "Asset", "Price", "Flood", "Other")

# Create parallel coordinates plot tracing different shocks across districts
# ggparcoord(data = d.pct, columns=c(3:9), scale = "globalminmax", groupColumn = 1, mapping = ggplot2::aes(size = 1))
# ggparcoord(data = d.num, columns=c(2:8), scale = "globalminmax", showPoints = TRUE)

dsub <- d[, c(2:9, 16)]
#total <- (rowSums(dsub[2:7]))
names(dsub) <- c("District", "Health", "Agriculture", "Financial", "Asset", "Price", "Flood", "Other", "id")

# Collapse data for easier plotting
df.melt <- melt(dsub, id = c("District", "id"))
names(df.melt) <- c("District", "ID", "Shock", "value")

g <- ggplot(df.melt, aes(x = reorder(factor(District), -value),
		y = value, fill = factor(df.melt$Shock, 
		levels = rev(levels(df.melt$Shock))))) + geom_bar(stat = "identity") + facet_wrap(~Shock, ncol = 7) 
#Toggle facet wrap depending on type of desired chart.

pp <- g + coord_flip()+labs(x ="District", title = "Bangladesh: Shock Summary by District", 
		y = "Percent of households reporting shock") + scale_fill_brewer(palette = clr ) +
		theme(legend.position = "top", legend.title=element_blank(),
		panel.background=element_rect(fill="white"), axis.ticks.y=element_blank(),
		axis.text.y  = element_text(hjust=1, size=10, colour = dblueL), axis.ticks.x=element_blank(),
		axis.text.x  = element_text(hjust=1, size=10, colour = dblueL),
		axis.title.x = element_text(colour=dblueL, size=8),
		plot.title = element_text(lineheight=.8, colour = dblueL)) + guides(fill = guide_legend(reverse=TRUE))
	print(pp)
ggsave(pp, filename = paste("Shocks_district.pct", ".png"), width=14, height=10, dpi=dpi.out)


# Produce similar graphs but focues on counts instead of percentages.
dsub2 <- d[, c(2, 10:17)]
names(dsub2) <- c("District", "Health", "Agriculture", "Financial", "Asset", "Price", "Flood", "Other", "id")

df.melt <- melt(dsub2, id = c("District", "id"))
names(df.melt) <- c("District", "ID", "Shock", "value")
g <- ggplot(df.melt, aes(x = reorder(factor(District), -value),
		y = value, fill = factor(df.melt$Shock, 
		levels = rev(levels(df.melt$Shock))))) + geom_bar(stat = "identity") + facet_wrap(~Shock, ncol = 7) #Turn on fact wrap

# Tidy up graphs
pp <- g + coord_flip()+labs(x ="District", title = "Bangladesh: Shock Count by District", 
		y = "Total households reporting shock") +scale_fill_brewer(palette = clr ) +
		theme(legend.position = "top", legend.title=element_blank(),
		 panel.background=element_rect(fill="white"), axis.ticks.y=element_blank(),
		axis.text.y  = element_text(hjust=1, size=10, colour = dblueL), axis.ticks.x=element_blank(),
		axis.text.x  = element_text(hjust=1, size=10, colour = dblueL),
		axis.title.x = element_text(colour=dblueL, size=8),
		plot.title = element_text(lineheight=.8, colour = dblueL)) + guides(fill = guide_legend(reverse=TRUE))
	print(pp)
ggsave(pp, filename = paste("Shocks_district.pct", ".png"), width=14, height=10, dpi=dpi.out)
