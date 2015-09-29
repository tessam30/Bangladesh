# Reusable plots.



# shock heatmap -----------------------------------------------------------
shkHeatmap = function (df,
                       shockCols,
                       regionCol,
                       orderShks,
                       orderRegions,
                       colorHeatmap = rev(PlBl),
                       colorAvg = brewer.pal(9, 'YlOrRd'),
                       widthWhite = 1,
                       sizePctLab = 6,
                       plotTitle = 'Percent difference from the national average',
                       relRange = c(-0.15, 0.15),
                       rangeAvg = c(0, 0.4)){
  
  
  # -- Select the columns containing the shock names and the regions. --
  df = df %>% 
    select(one_of(c(shockCols, regionCol)))
  
  # -- Calculate mean for each region, and transform into a tidy array. --
  df_regions = df %>% 
    group_by_(regions = regionCol) %>% 
    select_(paste0('-', regionCol)) %>% 
    summarise_each(funs(mean))
  
  row.names(df_regions) = df_regions$regions
  
  df_regions  = df_regions %>% 
    select(-regions)
  
  numRegions = nrow(df_regions)
  
  # -- Calculate average shock frequency over the sample. --
  df_avg = df %>% 
    select_(paste0('-', regionCol)) %>% 
    summarise_each(funs(mean))
  
  # For overall plot
  avg = df_avg %>% 
    gather(shocks, avg)
  avg$shocks = factor(avg$shocks, orderShks)
  
  if(nrow(df_avg) != 1) {
    stop('you have a problem.  your country avg. does not give  a single value.')
  }
  
  # Replicate to the number of regions
  df_avg = df_avg[rep(1,numRegions),]
  
  
  # -- Convert the avg. to relative average from the mean. --
  df_rel = df_regions - df_avg
  
  #   # ! Hack for now, to flip the 
  #   df_rel$edshkposR = df_rel$edshkposR * -1
  
  # Add back in region names
  df_rel = df_rel %>% 
    mutate(regions = row.names(df_rel)) %>% 
    gather(shocks, rel_mean, -regions)
  
  
  # -- Reorder the rows by worst type of shock --
  df_rel$shocks = factor(df_rel$shocks, orderShks)
  
  # -- Reorder the columns by order of worst regions. --
  df_rel$regions = factor(df_rel$regions, orderRegions)
  
  
  
  
  
  # -- heat plot --
  ggplot(df_rel) +
    geom_tile(aes(y = shocks, x = regions, fill = rel_mean), 
              color = 'white', size = widthWhite) +
    scale_fill_gradientn(colours = colorHeatmap, limits = relRange) +
    geom_text(aes(y = shocks, x = regions, 
                  label = sprintf('%.1f', round(rel_mean * 100,1))), 
              size = sizePctLab, family = 'Segoe UI') +
    ggtitle(plotTitle) +
    theme_heatmap() +
    theme(axis.text = element_text(size = 16, hjust = 0.5, 
                                   color = grey60K, family = 'Segoe UI Light'))
  
  #   ggplot(avg) +
  #     geom_tile(aes(y = shocks, x = 1, fill = avg), 
  #               color = 'white', size = widthWhite) +
  #     scale_fill_gradientn(colours = colorAvg, limits = rangeAvg) +
  #     geom_text(aes(y = shocks, x = 1, 
  #                   label = sprintf('%.1f', round(avg * 100,1))), 
  #               size = sizePctLab, family = 'Segoe UI') +
  #     ggtitle(plotTitle) +
  #     theme_heatmap() +
  #     theme(axis.text = element_text(size = 16, hjust = 0.5, 
  #                                    color = grey60K, family = 'Segoe UI Light'))
}


# country average ---------------------------------------------------------

pairGrid = function (df, shkVar, regionVar, title = NA, 
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
                     colorDot = brewer.pal(9, 'YlOrRd'),
                     rangeColors = c(0,0.65),
                     # Controlling average point:
                     lineAvgAdj = 2.75, sizeAvg = 0.05,
                     xLabAdj = 0,
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
  
  # -- Throw a warning if there are any NAs in the shkVar --
  if (any(is.na(df %>% select_(shkVar)))) {
    warning('There are NAs in `shkVar`.  They are being removed!')
    
    df = df %>% 
      filter_(paste0('!is.na(',shkVar, ')'))
  }
  
  # -- Calculate average data, sd, and SE --
  meanFormula = paste0('mean(', shkVar, ')')
  stdFormula = paste0('sd(', shkVar, ')')
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
  
  avgVals = df %>% 
    group_by_(regionVar) %>% 
    rename_(.dots = setNames(regionVar, 'names')) %>% 
    summarise_(.dots = setNames(c(meanFormula, stdFormula, numFormula), 
                                c('x', 'std', 'numHH'))) %>% 
    mutate(order = regionOrder) %>% 
    arrange_(orderVar) %>%  # sort, so highest shocks are at top.
    mutate(lb = x - (std * confidFactor)/sqrt(numHH), 
           ub = x + (std * confidFactor)/sqrt(numHH),
           ymin = seq(from = 10, by = 10, length.out = numRegions),
           ymax = seq(from = 10, by = 10, length.out = numRegions))
  
  
  
  # -- Limits for the graph overall --
  if (is.na(xLim)) {
    xLim = c(min(min(avgVals$x)) - 0.1, max(max(avgVals$x)) + 0.1)
  }
  
  if (is.na(yLim)) {
    yLim = c(-5, max(avgVals$ymin)+ 8)
  }
  
  
  # -- Set up the base plot --
  mainPlot =  ggplot(data = avgVals) + 
    theme_pairGrid() +
    
    # -- axis limits --
    # coord_cartesian(ylim = c(-5, nrow(avgVals)*10 + 10), xlim = xLim) +
    coord_cartesian(ylim = yLim, xlim = xLim) + 
    scale_x_continuous(labels = percent, expand = c(0,0)) +
    
    # -- labels --
    # ggtitle(title) +
    #     annotate("text", x = 0, y = max(avgVals$ymin) + 9.5, 
    #              size = 6.5, label = year, 
    #              color = avgVals$colors[7], hjust = 0) +
    #     annotate("text", x = 0, y = max(avgVals$ymin) + 15, 
    #              size = 8, label = title,
    #              fontface = "bold", hjust = 0) 
    # xlab(xLab) +
    
  
  # -- Plot country average --
  geom_vline(xint = xAvg, linetype = 1, color = grey50K, size = sizeAvg) +
    
    # -- Add in S.E. --
    geom_rect(aes(xmin = lb, xmax = ub, ymin = ymin - 0.5, ymax = ymax + 0.5, 
                  fill = colorSE), alpha = alphaSE) +
    scale_fill_identity()+
    
    # -- Overlay the points --
    # geom_point(aes(x = x, y = ymin), size = (sizeDot + borderDot), color = 'black') + # border
    geom_point(aes(x = x, y = ymin, colour = x), size = sizeDot) +
    scale_colour_gradientn(colours = colorDot,   limits = rangeColors) +
    
    
    # -- Add in circles containing the number of samples per segment. --
    #     geom_rect(aes(xmax = -0.01, xmin = -0.05, 
    #                   ymin = ymin - 3, ymax = ymin + 2, fill = nObs)) +
    #     geom_point(aes(x = -0.043,
    #                    y = ymin,  color = nObs), size = sizeDot * 2) +
    #     geom_text(aes(x = -0.043, y = ymin, label = nObs), size = 4.5, fontface = 'bold') + 
    # scale_color_gradientn(colours = colorDot) +
    
    # -- Add in names on the left --
  annotate("text", x =  - annotAdj, y = avgVals$ymin, family = 'Segoe UI Light',
           size = sizeAnnot, label= avgVals$names, hjust = 1, colour = grey90K) +
    
    # -- Annotate percents over the numbers --
    annotate("text", x = avgVals$x + xLabAdj, y = avgVals$ymin + 4, family = 'Segoe UI Light',
             size = sizePct, label= percent(avgVals$x,0), hjust = 0.5, colour = grey60K) +
    
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
           scale = 2,
           dpi = 300)
  }
  
  
  # -- Plot the household sizes in a separate plot --
  hhSizePlot = ggplot(data = avgVals) + 
    theme_pairGrid() +
    
    # -- axis limits --
    # coord_cartesian(ylim = c(-5, nrow(avgVals)*10 + 10), xlim = xLim) +
    coord_cartesian(ylim = c(-5, max(avgVals$ymin)+ 8), xlim = xLim) + 
    scale_x_continuous(labels = percent, expand = c(0,0)) +
    
    # Add in circles containing the number of samples per segment.
    geom_point(aes(x = 0.02,
                   y = ymin,  color = numHH), size = sizeDot * 2.25) +
    geom_text(aes(x = 0.02, y = ymin, label = numHH), size = sizeNObsText, 
              family = 'Segoe UI', colour = grey90K) + 
    scale_color_gradientn(colours = colorNObs) +
    
    # Add in names on the left
    annotate("text", x = min(avgVals$x) - annotAdj, y = avgVals$ymin, family = 'Segoe UI Light',
             size = sizeAnnot, label= avgVals$names, hjust = 1, colour = grey90K)
  
  # print(hhSizePlot)
  if(savePlots){
    # -- Save the main plot --
    ggsave(fileHHsize, 
           plot = hhSizePlot,
           width = widthAvg, height = heightAvg,
           bg = 'transparent',
           paper = 'special',
           units = 'in',
           useDingbats=FALSE,
           compress = FALSE,
           scale = 2,
           dpi = 300)
  }
  return(mainPlot)
}



