pp <- g + coord_flip()+labs(x ="District", title = "Bangladesh: Shock Summary by District", 
		y = "Percent of households reporting shock") + scale_fill_brewer(palette = clr ) +
		scale_y_continuous(labels=percent) +
		theme(legend.position = "top", legend.title=element_blank(),
		panel.background=element_rect(fill="white"), axis.ticks.y=element_blank(),
		axis.text.y  = element_text(hjust=1, size=10, colour = dblueL), axis.ticks.x=element_blank(),
		axis.text.x  = element_text(hjust=1, size=10, colour = dblueL),
		axis.title.x = element_text(colour=dblueL, size=8),
		plot.title = element_text(lineheight=.8, colour = dblueL)) + guides(fill = guide_legend(reverse=TRUE))
	print(pp)
