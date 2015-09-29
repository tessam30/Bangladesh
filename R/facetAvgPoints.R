# country average ---------------------------------------------------------

facetAvgPoints = function (df, varName, facetVar, facet1, facet2, 
                           regionVar, title = NA, 
                           # File names
                           fileMain = NA, fileHHsize = NA, 
                           savePlots = TRUE,
                           confidLevel = 0.95,
                           sizeLine = 0.9, colorLine = 'grey',
                           xLim = NA, yLim = NA,
                           lineAdj = 0.02,
                           # Region names
                           annotAdj = 0.02,
                           sizeAnnot = 7, 
                           regionOrder = NA,
                           # Percent labels
                           sizePct = 5,
                           sizeDot = 6, borderDot = 1,
                           colorDot = brewer.pal(9, 'Blues'),
                           rangeColors = c(0,0.65),
                           # Controlling average point:
                           lineAvgAdj = 2.75, sizeAvg = 0.05,
                           xLabAdj = 0,
                           y2Adj = 2,
                           # S.E. bars
                           colorSE = grey10K,
                           alphaSE = 1,
                           # Whether plot is vertical or horiz.
                           horiz = FALSE,
                           # Height/width for output
                           heightAvg = 3.4,
                           widthAvg = 4.2, 
                           # For plot w/ hh size.
                           colorNObs = c("#d7d7d7", "#5b5b5b"),
                           nObsAdj = -0.02, sizeNObsText = 4.2) {
  
  # -- convert confidence level to factor to convert from std. deviation to CI.
  if (confidLevel == 0.90) {
    confidFactor = 1.645
  }  else if (confidLevel == 0.95) {
    confidFactor = 1.96
  } else if (confidLevel == 0.98) {
    confidFactor = 2.33
  } else if (confidLevel == 0.99) {
    confidFactor = 2.575
  }
  
  # -- Throw a warning if there are any NAs in the varName --
  if (any(is.na(df %>% select_(varName)))) {
    warning('There are NAs in `varName`.  They are being removed!')
    
    df = df %>% 
      filter_(paste0('!is.na(',varName, ')'))
  }
  # -- Ditto for facet var --
  if (any(is.na(df %>% select_(facetVar)))) {
    warning('There are NAs in `facetVar`.  They are being removed!')
    
    df = df %>% 
      filter_(paste0('!is.na(',facetVar, ')'))
  }
  
  # -- Calculate average data, sd, and SE --
  meanFormula = paste0('mean(', varName, ')')
  stdFormula = paste0('sd(', varName, ')')
  numFormula = 'n()'
  numRegions = nrow(unique(df  %>% select_(regionVar)))
  
  countryAvg = df %>% 
    summarise_(.dots = setNames(c(meanFormula, stdFormula), c('avg', 'std')))
  
  xAvg = countryAvg$avg
  
  
  if (is.na(regionOrder)) {
    orderVar = 'x'
    
    regionOrder = 1:numRegions
  } else {
    orderVar = 'order'
  }
  
  avgVals1 = df %>% 
    filter_(paste0(facetVar, ' == ', facet1)) %>% 
    group_by_(regionVar) %>% 
    rename_(.dots = setNames(regionVar, 'names')) %>% 
    summarise_(.dots = setNames(c(meanFormula, stdFormula, numFormula), 
                                c('x', 'std', 'numHH'))) %>% 
    mutate(order = regionOrder) %>% 
    arrange_(orderVar) %>%  # sort, so highest shocks are at top.
    mutate(lb = x - (std * confidFactor)/sqrt(numHH), 
           ub = x + (std * confidFactor)/sqrt(numHH),
           ymin = seq(from = 10, by = -10, length.out = numRegions),
           ymax = seq(from = 10, by = -10, length.out = numRegions),
           order = 1:numRegions)
  
  
  avgVals2 = df %>% 
    filter_(paste0(facetVar, ' == ', facet2)) %>% 
    group_by_(regionVar) %>% 
    rename_(.dots = setNames(regionVar, 'names')) %>% 
    summarise_(.dots = setNames(c(meanFormula, stdFormula, numFormula), 
                                c('x', 'std', 'numHH')))
  
  regionOrder1 = avgVals1 %>% 
    select(names, order)
  
  avgVals2 = full_join(avgVals2, regionOrder1) %>% 
    arrange(order) %>%  # sort, so highest shocks are at top.
    mutate(lb = x - (std * confidFactor)/sqrt(numHH), 
           ub = x + (std * confidFactor)/sqrt(numHH),
           ymin = seq(from = 10 + y2Adj, by = -10, length.out = numRegions),
           ymax = seq(from = 10+ y2Adj, by = -10, length.out = numRegions))
  
  
  
  # -- Limits for the graph overall --
  if (is.na(xLim)) {
    xLim = c(min(min(avgVals1$x)) - 0.1, max(max(avgVals1$x)) + 0.1)
  }
  
  if (is.na(yLim)) {
    yLim = c(-5, max(avgVals1$ymin)+ 8)
  }
  
  
  # -- Set up the base plot --
  mainPlot =  
    ggplot(data = avgVals1) + 
    theme_pairGrid() +
    
    # -- axis limits --
    # coord_cartesian(ylim = c(-5, nrow(avgVals1)*10 + 10), xlim = xLim) +
    coord_cartesian(ylim = yLim, xlim = xLim) + 
    scale_x_continuous(labels = percent, expand = c(0,0)) +
    
    
    
    # -- Plot country average --
    geom_vline(xint = xAvg, linetype = 1, color = grey50K, size = sizeAvg) +
    annotate("text", x =  xAvg, y = 1, family = 'Segoe UI Light',
             size = sizeAnnot, label= percent(xAvg), hjust = 1, colour = grey90K) + 
    
    
    # -- Facet 1 --
    
    # -- Add in S.E. --
    geom_rect(aes(xmin = lb, xmax = ub, ymin = ymin - 0.25, ymax = ymax + 0.25, 
                  fill = colorSE), alpha = alphaSE) +
    scale_fill_identity()+
    
    # -- Overlay the points --
    # geom_point(aes(x = x, y = ymin), size = (sizeDot + borderDot), color = 'black') + # border
    geom_point(aes(x = x, y = ymin, colour = x), size = sizeDot) +
    scale_colour_gradientn(colours = colorDot,   limits = rangeColors) +
    
    
    # -- Add in names on the left --
    annotate("text", x =  - annotAdj, y = avgVals1$ymin, family = 'Segoe UI Light',
             size = sizeAnnot, label= avgVals1$names, hjust = 1, colour = grey90K) +
    
    # -- Annotate percents over the numbers --
    annotate("text", x = avgVals1$x + xLabAdj, y = avgVals1$ymin + 4, family = 'Segoe UI Light',
             size = sizePct, label= percent(avgVals1$x,0), hjust = 0.5, colour = grey60K) +
    
    
    # -- Facet 2 --
    
    # -- Add in S.E. --
    geom_rect(aes(xmin = lb, xmax = ub, ymin = ymin - 0.25, ymax = ymax + 0.25,
                  fill = colorSE), data = avgVals2, alpha = alphaSE) +
    
    # -- Overlay the points --
    # geom_point(aes(x = x, y = ymin), size = (sizeDot + borderDot), color = 'black') + # border
    geom_point(aes(x = x, y = ymin, colour = x), size = sizeDot, data = avgVals2) +
    
    
    # -- Add in names on the left --
    annotate("text", x =  annotAdj, y = avgVals2$ymin, family = 'Segoe UI Light',
             size = sizeAnnot, label= avgVals2$names, hjust = 1, colour = grey90K) +
    
    # -- Annotate percents over the numbers --
    annotate("text", x = avgVals2$x + xLabAdj, y = avgVals2$ymin + 4, family = 'Segoe UI Light',
             size = sizePct, label= percent(avgVals2$x,0), hjust = 0.5, colour = grey60K) +
    
    if(horiz == TRUE) coord_flip()
  
  
  
  # -- blocks for the labels --
  # annotate("rect", xmin = -0.35, xmax = -0.32, ymin = 0, ymax = avgVals$ymin[2] + 5, fill = avgVals$colors[3], alpha = 0.3) +
  # annotate("rect", xmin = -0.35, xmax = -0.32, ymin = avgVals$ymin[3] - 5, ymax = avgVals$ymin[12] + 5, fill = avgVals$colors[8], alpha = 0.3)
  
  print(mainPlot)
  
  # -- Save the main plot --
  
  if (savePlots){
    ggsave(fileMain, 
           plot = mainPlot,
           width = widthAvg, height = heightAvg,
           bg = 'transparent',
           paper = 'special',
           units = 'in',
           useDingbats=FALSE,
           compress = FALSE,
           dpi = 300)
  }
  
  
  #   # -- Plot the household sizes in a separate plot --
  #   hhSizePlot = ggplot(data = avgVals) + 
  #     theme_pairGrid() +
  #     
  #     # -- axis limits --
  #     # coord_cartesian(ylim = c(-5, nrow(avgVals)*10 + 10), xlim = xLim) +
  #     coord_cartesian(ylim = c(-5, max(avgVals$ymin)+ 8), xlim = xLim) + 
  #     scale_x_continuous(labels = percent, expand = c(0,0)) +
  #     
  #     # Add in circles containing the number of samples per segment.
  #     geom_point(aes(x = 0.02,
  #                    y = ymin,  color = numHH), size = sizeDot * 2.25) +
  #     geom_text(aes(x = 0.02, y = ymin, label = numHH), size = sizeNObsText, 
  #               family = 'Segoe UI', colour = grey90K) + 
  #     scale_color_gradientn(colours = colorNObs) +
  #     
  #     # Add in names on the left
  #     annotate("text", x = min(avgVals$x) - annotAdj, y = avgVals$ymin, family = 'Segoe UI Light',
  #              size = sizeAnnot, label= avgVals$names, hjust = 1, colour = grey90K)
  
#   # print(hhSizePlot)
#   if(savePlots){
#     # -- Save the main plot --
#     ggsave(fileHHsize, 
#            plot = hhSizePlot,
#            width = widthAvg, height = heightAvg,
#            bg = 'transparent',
#            paper = 'special',
#            units = 'in',
#            useDingbats=FALSE,
#            compress = FALSE,
#            scale = 2,
#            dpi = 300)
#   }
#   return(mainPlot)
}
