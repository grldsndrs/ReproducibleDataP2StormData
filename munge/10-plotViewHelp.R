


analyze.missing.Plot <- function(dayta) {
  # DataAnalysis Summarize MissingData --------------------------------------
  # summarize by input arguments
  #' ```{r echo = FALSE, eval= TRUE }
  as.data.frame(dayta) %>%
    missmap(y.labels = c(nrow(dayta)),
            y.at = c(1),
            legend = TRUE)
  #' ```
}

analyze.summarize.Table <- function(..., veu) {
  if (hasArg(veu)) {
    tag = veu
  } else{
    tag = "Flatten Data with Summary"
  }

  # DataAnalysis Table RelevantData --------------------------------------
  # summarize by input arguments
  #' ```{r echo = FALSE, eval= TRUE }
  sbSet <- summarize(...)
  sbSetTbl <- tbl_df(as.data.frame(sbSet))
  # PropDmg<-"0"
  list(tag = tag,
       out = kable(
         sbSetTbl,
         align = 'c',
         digits = 3,
         caption = tag
       ))
  #' ```
}

analyze.summarize.Plot <- function(percentile=1, dayta, veu) {
  if (hasArg(veu)) {
    tag = veu
  } else{
    tag = "Which types of events have the greatest economic consequences?"
  }

  # DataAnalysis.Plot.RelevantData --------------------------------------
  # summarize by input arguments
  #' ```{r echo = FALSE, eval= TRUE }

  # Scale function used to scale data for graph aestetics
  scale01 <- function(v) {
    if (max(v, na.rm = TRUE) - min(v, na.rm = TRUE) == 0) {
      addt = .0000000001
    }
    else{
      addt = 0
    }
    (v - min(v, na.rm = TRUE)) / (max(v, na.rm = TRUE) + addt - min(v, na.rm = TRUE))
  }

  # Vectorized function to compute a running difference

  runningDiff <-
    Vectorize(function(x, y)
      abs((y - x) / x), SIMPLIFY = TRUE)


  # Get smaller set of data to work with by building a random
  # sample of numbers between year boundries
  runningSum0 <- 0

  dayta["Total.Damages"] <- dayta$PROPDMG+dayta$CROPDMG
  dayta <-
     group_by(
         mutate(
           ungroup(dayta),
           year = as.factor(format(as.Date(BGN_DATE,"%m/%d/%Y"), '%Y')),
           EVTYPE = as.factor(EVTYPE)),
       year)
  dayta.Yr<-
    dayta%>%
    summarise(
      count.Yr = n(),
      Total.Damages.Yr = sum(Total.Damages, na.rm = TRUE)
    )

  dayta.Yr <-
    merge(dayta,dayta.Yr,by = intersect(names(dayta.Yr), names(dayta)))
#
#   gStateC<-group_by(gyear,EVTYPE,year,STATE)%>%
#     summarise(Total.cropDmg.yr.state = sum(CROPDMG,na.rm = TRUE))
#
#
#   gStateP<-group_by(gyear,EVTYPE,year,STATE)%>%
#     summarise(Total.propDmg.yr.state = sum(PROPDMG,na.rm = TRUE))
#
#   gState <-
#     merge(gStateC,gStateP,by = intersect(names(gStateC), names(gStateP)))


  # dayta.Yr <-
  #   merge(gyear,gState,by = intersect(names(gState), names(gyear)))


#  old code ---------------------------------------------------------------
# set.seed <- 1
# # 0 - 1
# pct <- percentile
listSubSetIndices <- sample(nrow(dayta.Yr),floor(nrow(dayta.Yr)*percentile))
#   floor(unlist(sapply(dayta.Yr$count.Yr, function(cnt) {
#     listOfInd <-
#       runif(floor(pct * cnt), runningSum0 + 1, cnt + runningSum0)
#     runningSum0 <<- runningSum0 + cnt
#     listOfInd
#   }, simplify = TRUE)))
# plot(listSubSetIndices)


  # # Remove outliers
  # outlier(gyear$Emissions)
  # gyear$Emissions = rm.outlier(gyear$Emissions,fill = TRUE)
  # mrro1=rm.outlier(gyear$Emissions,fill =TRUE)
  # outlier(mrro1)
  # mrro1=rm.outlier(mrro1,fill =TRUE)
  # outlier(mrro1)
  # mrro1=rm.outlier(mrro1,fill =TRUE)
  # outlier(mrro1)
  # mrro1=rm.outlier(mrro1,fill =TRUE)
  # outlier(mrro1)
  # gyear$Emissions=rm.outlier(mrro1,fill =TRUE)
  # old code stop -----------------------------------------------------------

  daytaPlotSet <- dayta.Yr[listSubSetIndices, ]
dayta.Yr<-NULL


  # cast variables
  damagePalSymbols <- c(24:25)
  damagePalFactors <- factor(
    x = names(daytaPlotSet[10:11]))
  FFactors <- factor(daytaPlotSet$F)
  eventTypeFactors <- factor(daytaPlotSet$EVTYPE)
  stateFactors <- factor(daytaPlotSet$STATE)
  yearFactors <- factor(daytaPlotSet$year)
  fatalitiesFactors <- factor(1:ceiling(diff(range(daytaPlotSet$FATALITIES))))
  injuriesFactors <- factor(daytaPlotSet$INJURIES)
  magFactors <- factor(1:ceiling(diff(range(daytaPlotSet$MAG))))


  damageSymLvls <- levels(damagePalFactors)
  FLvls <- levels(as.factor(daytaPlotSet$F))
  eventTypeLvls <- levels(daytaPlotSet$EVTYPE)
  stateLvls <- levels(daytaPlotSet$STATE)
  yearLvls <- levels(daytaPlotSet$year)
  fatalitiesLvls <- levels(fatalitiesFactors)
  injuriesLvls <- levels(injuriesFactors)
  magLvls <- levels(magFactors)

  #pallette for the line and fill of the symbols
  numberOfColsForF <- length(FLvls)
  numberOfColsForEventType <- length(eventTypeLvls)
  numberOfColsForState <- length(stateLvls)
  numberOfColsForYear <- length(yearLvls)
  numberOfColsForFatalities <- length(fatalitiesLvls)
  numberOfColsForInjuries <- length(injuriesLvls)
  numberOfColsForMag <- length(magLvls)

  FPalFnc <-
    colorRampPalette(brewer.pal(numberOfColsForF,"Purples")[floor(numberOfColsForF/3):numberOfColsForF])
  magPalFnc <-
    colorRampPalette(cscale(1:numberOfColsForMag,
                            gradient_n_pal(brewer.pal(9, "Greens")))[floor(numberOfColsForMag /
                                                                             3):numberOfColsForMag])
  eventTypePalFnc <-
    colorRampPalette(heat.colors(numberOfColsForEventType))
  statePalFnc <-
    colorRampPalette(heat.colors(numberOfColsForState))
  yearPalFnc <-
    colorRampPalette(rainbow(numberOfColsForF))
  fatalitiesPalFnc <-
    colorRampPalette(heat.colors(numberOfColsForFatalities)[floor(numberOfColsForFatalities/3):numberOfColsForFatalities])
  injuriesPalFnc <-
    colorRampPalette(topo.colors(numberOfColsForInjuries))

  palSymStrokeCols <-
    (fatalitiesPalFnc(numberOfColsForFatalities))

  palEVTYPECols <-
    rev(eventTypePalFnc(numberOfColsForEventType)) # pallet symbol line color integer

  palSortOrderCols <-
    (statePalFnc(numberOfColsForState)) # pallet symbol line color integer

  palGroupCols <-
    (yearPalFnc(numberOfColsForYear)) # pallet symbol line color integer

  palSymFillCols <-
    (magPalFnc(numberOfColsForMag)) # pallet symbol line color integer

  palSymColCols <-
    (FPalFnc(numberOfColsForF)) # pallet symbol line color integer

  palSymSzCols <-
    (injuriesPalFnc(numberOfColsForInjuries)) # pallet symbol line color integer

  # rev(col2hex(c("red", "chocolate")))#brewer.pal(3,"Pastel1")[1:2]

  palSymFillCols2 <-
    (c(
      alpha(palSymFillCols[1], .001),
      alpha(palSymFillCols[2], 1)
    ))

  names(palSymStrokeCols) <- fatalitiesLvls
  names(palEVTYPECols) <- eventTypeLvls
  names(palSortOrderCols) <- stateLvls
  names(palGroupCols) <- yearLvls
  names(palSymFillCols) <- magLvls
  names(palSymSzCols) <- injuriesLvls
  names(palSymColCols) <- FLvls
  damagePalNamedSymbols <- damagePalSymbols
names(damagePalNamedSymbols) <- c("Crop Damage", "Property Damage")

# EventType.EconomicConsequences.SubSetData1 ---------------------------------------------------
#' ```{r echo = TRUE, eval= FALSE }
daytaPlotSet<-
  daytaPlotSet%>%
  mutate(
    scale.PDmg= rescale(PROPDMG,c(0,1),range(PROPDMG,na.rm=TRUE)),
    scale.CDmg= rescale(CROPDMG,c(0,1),range(CROPDMG,na.rm=TRUE)),
    scale.Injr= rescale(INJURIES,c(0,1),range(INJURIES,na.rm=TRUE)),
    scale.Fatl= rescale(FATALITIES,c(0,1),range(FATALITIES,na.rm=TRUE)),

    scale.Cost.Alpha= rescale(scale.PDmg + scale.CDmg + scale.Injr + scale.Fatl,c(.1,1)),

    scale.Cost.Stroke= floor(rescale(scale.Cost.Alpha,c(2,7))),
    scale.Cost.Color= floor(rescale(scale.Cost.Alpha,c(1,numberOfColsForEventType))),
    EVTYPE.Color.Alpha = alpha(palEVTYPECols[scale.Cost.Color],scale.Cost.Alpha)
    )
#' ```
# EventType.EconomicConsequences.SubSetData ---------------------------------------------------

# View.Plot.Exclude ---------------------------------------------------

  # group by Year to get mean by year
  gtype <- group_by(daytaPlotSet, year, EVTYPE)
  # get a count of the distinct Classes per type
  sm <-
    summarise(
      gtype,
      meanProp = mean(PROPDMG, na.rm = TRUE),
      medProp = median(PROPDMG, na.rm = TRUE),
      meanCrop = mean(CROPDMG, na.rm = TRUE),
      medCrop = median(CROPDMG, na.rm = TRUE),
      Total.Damage.yr.eventType = sum(PROPDMG + CROPDMG, na.rm = TRUE)
    )
  # merge counts back to original data set
  daytaPlotSet <-
    merge(daytaPlotSet, sm, by = intersect(names(sm), names(daytaPlotSet)))

  # try to isolate the big events so they dont mask others
  daytaPlotSet <-
    group_by(daytaPlotSet,EVTYPE,year)# Making and Submitting Plots

  # daytaPlotSet$LnColor <- palSymColCols[injuriesFactors]


  #par(mar=c(2,2,5,4)+.1)

  melteddDaytaPlotSet<-
    daytaPlotSet%>%
    gather(
      key_col = PROPDMG,
      value_col = CROPDMG,
      na.rm = FALSE,
      factor_key = FALSE,
      convert = TRUE,
      key = "Damage.Type",
      value = "Damage.Dollars"
    )
  # levels(melteddDaytaPlotSet$DamageType)<-damageSymLvls


  p <-
# ok ----------------------------------------------------------------------
    ggplot(
      data = melteddDaytaPlotSet,
      aes(
        x = Damage.Dollars,
        y = EVTYPE,
        shape = factor(Damage.Type),
        colour = melteddDaytaPlotSet$F,
        fill = MAG,
        size = INJURIES,
        stroke = scale.Cost.Stroke,
        alpha =  FATALITIES #.1,Percent.Emissions.type.fips,
         # group = EVTYPE,
         # order = BGN_DATE
      )
    ) +
    scale_shape_manual(
      #symbols
      name = "Damage Type",
      values =  damagePalSymbols #factor(melteddDaytaPlotSet$Damage.Type) # gets a factor column
# unused code -------------------------------------------------------------
      # guide = guide_legend(
      #   # title = "Damage Type",
      #   # title.position = "left",
      #   # keywidth = 0,
      #   label.theme = element_text(angle = 0, colour = "black")
      #   # override.aes = list(size = 5, alpha = .1)
      # )
    ) +
# unused code -------------------------------------------------------------

# ok ----------------------------------------------------------------------
    # To get a legend guide, specify guide = "legend" and breaks
  scale_colour_gradientn(
    colours = palSymColCols,
    guide = "colourbar",
     name = "F"

# unused code -------------------------------------------------------------
      # breaks = injuriesLvls,
      # palette = palSymColCols #injuriesPalFnc(),
      # labels = injuriesLvls
      # alpha=daytaPlotSet$Distinct.Source.Class.Count,
    #guide_legend(
         # title = "F",
      #legend.position = "top"
      #title.position = "left"
        # keywidth = 0,
        # label.theme = element_text(angle = 0, colour = "black"),
        # override.aes = list(
        #   shape = 18,
        #   colour = palSymColCols,
        #   size = 1
        #)
      #)
    # unused code -------------------------------------------------------------
    )   +
  # Fill aestitics
    scale_fill_gradientn(
      colours = palSymFillCols,
      guide = "colourbar",
      name = "MAG"
 # unused code -------------------------------------------------------------
      # # labels = c("Los Angles", "Baltimore"),
      # # breaks = fipsLvls,
      # values = fatalitiesPalFnc,
       #guide_legend(
      # title = "MAG",
      #   title.position = "left"
      #   keywidth = 0,
      #   label.theme = element_text(angle = 0, colour = "black"),
      #   override.aes = list(
      #     colour = palSymFillCols,
      #     shape = 23,
      #     size = 3
      #   )
      # )
    ) +
    scale_size_continuous(
      name = "# Injuries",
                range = c(3, 10),
               guide = "legend"
   ) +
  # expand = c( 2,2),
  # values = factor(melteddDaytaPlotSet$MAG)
    scale_alpha(
      name = "# Fatalities",
      range = c(.1,1)
# unused code -------------------------------------------------------------
   #guide = guide_legend(
   #legend.position = "top",
     # title = "Opacity ~ % of Emissions by Type for year and fips",
   #title.position = "left"
  # title.hjust = 1,
  # keywidth = 0,
  # label.theme = element_text(angle=0,colour = "black"),
  # override.aes = list(
  # shape = 18,
  # size=5
   #)
# unused code -------------------------------------------------------------
    ) +
    scale_x_log10(labels = dollar,
                  name = "Storm Data as a function of \n Total $ Property and Crop Damage \n with Health Factors "
                  # limits =c(1,1e+11)
                  ) +
    # ylim("0.5", "2") +
    scale_y_discrete(name = "Event Type ordered from the top by Begin Date") +
    theme(
       legend.position = "right",
       legend.direction = "vertical",
       legend.box = "vertical",
       legend.key.height = unit(.25,"cm"),
      # legend.key = element_rect(fill = "white"),
      # legend.background = element_rect(fill = "white"),
      #legend.text = element_text( face = "bold"),
      # breaks = c("0.5", "1", "2"),
      # labels = c("Dose 0.5", "Dose 1", "Dose 2"),
      panel.background = element_rect(fill = "white"),
      axis.text.y = element_text(
        # face = "bold",
        size = 9,
        angle = 45,
        color = melteddDaytaPlotSet$EVTYPE.Color.Alpha
      )
    ) +
    geom_point()
  #' ```
  p
}




