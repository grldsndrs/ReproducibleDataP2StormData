
# DataProcessing.LoadData.LoadProjectTemplate -----------------------------
#' ```{r echo=FALSE,eval=TRUE}
source(paste0(getwd(),c("/lib/modelGeneratorHelp.R")))
#' ```


## Data Processing: Load Data via *"ProjectTemplate"*
#' ```{r echo=TRUE,eval=TRUE}
ldData <- process.loadData()
#' ```
# DataProcessing.LoadData.End ------------------------------------------------------------



# DataProcessing.ExamineData.Summary --------------------------------------

#' ```{r echo=FALSE,eval=TRUE, tidy=TRUE}
process.summurize()
process.structure()
#' ```
helper.decision.View("Based on the summary above I will use the *make.names* funcion to
tidy up the names")
# DataProcessing.ExamineData.End ------------------------------------------



# DataTransformation.CleanNames.makenames ---------------------------------

#' ```{r echo=FALSE,eval=TRUE, tidy=TRUE}
transform.cleanNames()
#' ```
# DataTransformation.CleanNames.end ---------------------------------------



# DataTransformation.ExamineData.TidyedData ---------------------------------------

helper.decision.View("The Damage variables are transformed into a common scale dollar
converting the code into and actual exponent that I use to scale the units")

#' ```{r echo=TRUE,eval=TRUE}
rawData<-repdata.data.StormData
rawData$PROPDMGEXP <- as.character(rawData$PROPDMGEXP)
rawData$PROPDMGEXP[rawData$PROPDMGEXP %in% c("","?","+","-","1")]<-1
rawData$PROPDMGEXP[rawData$PROPDMGEXP %in% c("h","H")]<-2
rawData$PROPDMGEXP[rawData$PROPDMGEXP %in% c("k","K")]<-3
rawData$PROPDMGEXP[rawData$PROPDMGEXP %in% c("m","M")]<-6
rawData$PROPDMGEXP[rawData$PROPDMGEXP %in% c("b","B")]<-9
rawData$PROPDMGEXP[rawData$PROPDMGEXP %in% c("0")]<-0
rawData$CROPDMGEXP <- as.character(rawData$CROPDMGEXP)
rawData$CROPDMGEXP[rawData$CROPDMGEXP %in% c("","?","+","-","1")]<-1
rawData$CROPDMGEXP[rawData$CROPDMGEXP %in% c("h","H")]<-2
rawData$CROPDMGEXP[rawData$CROPDMGEXP %in% c("k","K")]<-3
rawData$CROPDMGEXP[rawData$CROPDMGEXP %in% c("m","M")]<-6
rawData$CROPDMGEXP[rawData$CROPDMGEXP %in% c("b","B")]<-9
rawData$CROPDMGEXP[rawData$CROPDMGEXP %in% c("0")]<-0
rawData$PROPDMGEXP <- as.numeric(rawData$PROPDMGEXP)
rawData$CROPDMGEXP <- as.numeric(rawData$CROPDMGEXP)

process.makeDataFrameRepository(rawData)

#' ```
# DataTransformation.ExamineData.SquareUnits -----------------------------

# DataTransformation.ExamineData.RemoveSpacePadding ---------------------------------

#' ```{r echo=TRUE,eval=TRUE, results='hide'}
# Use the dfContext to get the current data frame.
# Pass it to mutate to process columns.
# Pass the result to dfContext to set the current data frame
process.dfContext(
  mutate(process.dfContext(),
         EVTYPE = str_trim(EVTYPE, side = "both")
         )
)

#' ```
# DataTransformation.ExamineData.TrimmedData ---------------------------------


# DataTransformation.ExamineData.ApplyMultiplierToDollarAmmounts ---------------------------------

#' ```{r echo=TRUE,eval=TRUE, results='hide'}
# Use the dfContext to get the current data frame.
# Pass it to mutate to process columns.
# Pass the result to dfContext to set the current data frame
process.dfContext(
    mutate(process.dfContext(),
           CROPDMG = CROPDMG*10^CROPDMGEXP,
           PROPDMG = PROPDMG*10^PROPDMGEXP
      )%>%
      select(-CROPDMGEXP,-PROPDMGEXP)
    )

#' ```
# DataTransformation.ExamineData.ScaledDollarAmmounts ---------------------------------

# DataTransformation.ExamineData.SeparateSummarizeEVTYPE ---------------------------------

helper.decision.View("Separate the EVTYPE variables to common
antecedents")


#' ```{r echo=TRUE,eval=TRUE, results='hide'}
# Use the dfContext to get the current data frame.
# Pass it to mutate to process columns.
# Pass the result to dfContext to set the current data frame
process.dfContext(
  separate(
    process.dfContext(),
    sep = "/",
    into = c("EVTYPE", "EVTYPEFwSlash"),
    col = EVTYPE,
    convert = FALSE,
    extra = "merge",
    fill = "right"
  ) %>%
    separate(
      into = c("EVTYPE", "EVTYPE.1", "EVTYPE.2", "EVTYPE.3", "EVTYPE.4"),
      col = EVTYPE,
      convert = FALSE,
      extra = "merge",
      fill = "right"
    )
)

#' ```
# DataTransformation.ExamineData.VariablesSeparated ---------------------------------


# DataTransformation.ExamineData.RemoveSpacePadding ---------------------------------

#' ```{r echo=TRUE,eval=TRUE, results='hide'}
# Use the dfContext to get the current data frame.
# Pass it to mutate to process columns.
# Pass the result to dfContext to set the current data frame
process.dfContext(
  mutate(process.dfContext(),
         EVTYPE = str_trim(EVTYPE, side = "both")
  )
)

#' ```
# DataTransformation.ExamineData.TrimmedData ---------------------------------



# DataTransformation.ExamineData.OrganizeData ---------------------------------
helper.decision.View("The variables are reordered according to the role in the analysis.
Fixed values, such as location related variables, are the first coloums.
The measured values follow.")



# DataTransformation.OrganizeVariables.select ---------------------------------
#' ```{r echo=FALSE,eval=TRUE, results='hide'}
newOrder <- list(
  "STATE","BGN_DATE","END_DATE",
  "EVTYPE","EVTYPE.1","EVTYPE.2","EVTYPE.3","EVTYPE.4"
  ,"F","MAG",
  "FATALITIES","INJURIES","PROPDMG","CROPDMG")

transformedData<-transform.selectNames(process.dfContext(),newOrder)
# normalize the spelling of Event types to upper case removing unnecessary duplicates
transformedData$select$EVTYPE <- toupper(transformedData$select$EVTYPE)
process.dfContext(transformedData$select)
#' ```

#' ```{r echo=FALSE,eval=TRUE, tidy=TRUE}
transformedData[1:2]
#' ```

helper.decision.View("The __*F*__  and __*MAG*__ variables may be suited for use as a scale
in a later plot.  I have given them a numeric class in anticipation. The other variables are
cast as would be expected.")
# DataTransformation.OrganizeVariables.SubSetVariables ---------------------------------------



# DataTransformation.ClassifyVariables.mutate ---------------------------------------
#' ```{r echo=FALSE,eval=TRUE, tidy=TRUE}
newClass <- list(
  "Factor","POSIXct","POSIXct",
  "Factor","Factor","Factor","Factor","Factor",
  "Numeric","Numeric",
  "Numeric","Numeric","Numeric","Numeric")
transform.selectClass(process.dfContext(),newOrder,newClass)
process.summurize(process.dfContext())
#' ```
# DataTransformation.ClassifyVariables.ClassfiedVariables ---------------------------------------


# DataTransformation.OrganizeVariables.arrange ---------------------------------
#' ```{r echo=FALSE,eval=TRUE, results='hide'}
arrangement <- list(
  "BGN_DATE", "END_DATE",
  "EVTYPE","EVTYPE.1","EVTYPE.2","EVTYPE.3","EVTYPE.4","MAG",
  "FATALITIES","INJURIES","PROPDMG","CROPDMG","F","STATE"
)
transform.orderRowsBy(process.dfContext(),arrangement)
#' ```
# DataTransformation.OrganizeVariables.SortedByDateAndEvent ---------------------------------------



# DataTransformation.OrganizeVariables.TidyVariables ---------------------------------
#' ```{r echo=TRUE,eval=TRUE, results='hide'}

t<-process.dfContext()
t[grep("^ABNOR",t$EVTYPE),"EVTYPE"]<- "ABNORMAL"
t[grep("^AVAL",t$EVTYPE),"EVTYPE"]<- "AVALANCHE"
t[grep("^BLOW",t$EVTYPE),"EVTYPE"]<- "BLOW/ING"
t[grep("^COASTALFLOOD",t$EVTYPE),"EVTYPE"]<- "COASTAL FLOOD"
t[grep("^COASTALSTORM",t$EVTYPE),"EVTYPE"]<- "COASTAL STORM"
t[grep("^DRY",t$EVTYPE),"EVTYPE"]<- "DRY"
t[grep("^EXCESS",t$EVTYPE),"EVTYPE"]<- "EXCESSIVE"
t[grep("^EXTREM",t$EVTYPE),"EVTYPE"]<- "EXTREME"
t[grep("^FLOOD",t$EVTYPE),"EVTYPE"]<- "FLOOD/ING/S"
t[grep("^FREEZ",t$EVTYPE),"EVTYPE"]<- "FREEZ/ING"
t[grep("^FUNNEL",t$EVTYPE),"EVTYPE"]<- "FUNNEL/S"
t[grep("^HAILSTORM",t$EVTYPE),"EVTYPE"]<- "HAIL"
t[grep("^HAIL STORM",t$EVTYPE),"EVTYPE"]<- "HAIL"
t[grep("^HEAT",t$EVTYPE),"EVTYPE"]<- "HEAT"
t[grep("^HOT",t$EVTYPE),"EVTYPE"]<- "HEAT"
t[grep("^HYP",t$EVTYPE),"EVTYPE"]<- "HYPOTHERMIA"
t[grep("^ICESTORM",t$EVTYPE),"EVTYPE"]<- "ICE"
t[grep("^ICY",t$EVTYPE),"EVTYPE"]<- "ICE"
t[grep("^LANDSLIDE",t$EVTYPE),"EVTYPE"]<- "LANDSLIDE"
t[grep("^LIGHTING",t$EVTYPE),"EVTYPE"]<- "LIGHTNING"
t[grep("^LIGHNTNING",t$EVTYPE),"EVTYPE"]<- "LIGHTNING"
t[grep("^LIGHTNING",t$EVTYPE),"EVTYPE"]<- "LIGHTNING"
t[grep("^LOCAL",t$EVTYPE),"EVTYPE"]<- "LOCAL"
t[grep("^MUDSLIDE",t$EVTYPE),"EVTYPE"]<- "MUDSLIDE"
t[grep("^PROLONG",t$EVTYPE),"EVTYPE"]<- "PROLONGED"
t[grep("^RAIN",t$EVTYPE),"EVTYPE"]<- "RAIN"
t[grep("^SNOWFALL",t$EVTYPE),"EVTYPE"]<- "SNOW FALL"
t[grep("^SNOWMELT",t$EVTYPE),"EVTYPE"]<- "SNOW MELT"
t[grep("^SNOWSTORM",t$EVTYPE),"EVTYPE"]<- "SNOW"
t[grep("^MUDSLIDE",t$EVTYPE),"EVTYPE"]<- "MUDSLIDE"
t[grep("^THU",t$EVTYPE),"EVTYPE"]<- "THUNDER STORM"
t[grep("^TORN",t$EVTYPE),"EVTYPE"]<- "TORNADO"
t[grep("^TSTM",t$EVTYPE),"EVTYPE"]<- "TSUNAMI"
t[grep("^TUNDER",t$EVTYPE),"EVTYPE"]<- "THUNDER STORM"
t[grep("^UN",t$EVTYPE),"EVTYPE"]<- "UNUSUAL"
t[grep("^VOG",t$EVTYPE),"EVTYPE"]<- "FOG"
t[grep("^WATERSPOUT",t$EVTYPE),"EVTYPE"]<- "WATER SPOUT"
t[grep("^WAYERSPOUT",t$EVTYPE),"EVTYPE"]<- "WATER SPOUT"
t[grep("^WHIRLWIND",t$EVTYPE),"EVTYPE"]<- "WHIRL WIND"
t[grep("^WILDFIRE",t$EVTYPE),"EVTYPE"]<- "WILD FIRE"
t[grep("^WIND",t$EVTYPE),"EVTYPE"]<- "WIND"
t[grep("^WINT",t$EVTYPE),"EVTYPE"]<- "WINTER"
t[grep("^DUSTSTORM",t$EVTYPE),"EVTYPE"]<- "DUST STORM"
t[grep("^MUDSLIDE",t$EVTYPE),"EVTYPE"]<- "MUD SLIDE"
t[grep("^MUD SLIDE",t$EVTYPE),"EVTYPE"]<- "MUD SLIDE"

t$EVTYPE.1 <- toupper(t$EVTYPE.1)
t$EVTYPE.2 <- toupper(t$EVTYPE.2)

t[grep("^SNOWFALL",t$EVTYPE.1),"EVTYPE.1"]<- "SNOW"
t[grep("^EROS",t$EVTYPE.1),"EVTYPE.1"]<- "EROSION"
t[grep("^DEVEL",t$EVTYPE.1),"EVTYPE.1"]<- "DEVIL"
t[grep("^Snow",t$EVTYPE.1),"EVTYPE.1"]<- "SNOW"
t[grep("^[fF][lL]",t$EVTYPE.1),"EVTYPE.1"]<- "FLOOD"
t[grep("^CLOUD",t$EVTYPE.1),"EVTYPE.1"]<- "CLOUD"
t[grep("^RAINFALL",t$EVTYPE.1),"EVTYPE.1"]<- "RAIN"
t[grep("^RAINS",t$EVTYPE.1),"EVTYPE.1"]<- "RAIN"
t[grep("^SHOWERS",t$EVTYPE.1),"EVTYPE.1"]<- "RAIN"
t[grep("^SHOWER",t$EVTYPE.1),"EVTYPE.1"]<- "RAIN"
t[grep("^WIND",t$EVTYPE.1),"EVTYPE.1"]<- "WIND"
t[grep("^PRECIPATATION ",t$EVTYPE.1),"EVTYPE.1"]<- "PRECIPITATION "
t[grep("^SNOWPACK",t$EVTYPE.1),"EVTYPE.1"]<- "SNOW"
t[grep("^SWELLS",t$EVTYPE.1),"EVTYPE.1"]<- "SURF"
t[grep("^SEAS",t$EVTYPE.1),"EVTYPE.1"]<- "TIDES"
t[grep("^TEMPERATURE",t$EVTYPE.1),"EVTYPE.1"]<- "TEMPERATURE"
t[grep("^WATER",t$EVTYPE.1),"EVTYPE.1"]<- "TIDES"
t[grep("^WAVES",t$EVTYPE.1),"EVTYPE.1"]<- "SURF"
t[grep("^TIDES",t$EVTYPE.1),"EVTYPE.1"]<- "SURF"
t[grep("^SNOWFALL",t$EVTYPE.1),"EVTYPE.1"]<- "SNOW"
t[grep("^PRECIP",t$EVTYPE.1),"EVTYPE.1"]<- "RAIN"
t[grep("^SNOWFALL",t$EVTYPE.1),"EVTYPE.1"]<- "SNOW"
t[grep("^SNOWFALL",t$EVTYPE.1),"EVTYPE.1"]<- "SNOW"
t[grep("^SNOWFALL",t$EVTYPE.1),"EVTYPE.1"]<- "SNOW"
t[grep("^DRYNESS",t$EVTYPE.1),"EVTYPE.1"]<- "DRY"
t[grep("^Warm",t$EVTYPE.1),"EVTYPE.1"]<- "HEAT"
t[grep("^CURRENT",t$EVTYPE.1),"EVTYPE.1"]<- "CURRENT"
t[grep("^THU",t$EVTYPE.1),"EVTYPE.1"]<- "THUNDER STORM"
t[grep("^WIND",t$EVTYPE.1),"EVTYPE.1"]<- "WIND"
t[grep("^MICOBURST",t$EVTYPE.1),"EVTYPE.1"]<- "MICROBURST"
t[grep("^FIRE",t$EVTYPE.1),"EVTYPE.1"]<- "FIRE"
t[grep("^STORM",t$EVTYPE.1),"EVTYPE.1"]<- "STORM"
t[grep("^SLIDE",t$EVTYPE.1),"EVTYPE.1"]<- "SLIDE"

t[grep("^STORM",t$EVTYPE.1),"EVTYPE.1"]<- "STORM"


sufficentDescription <- list(
  "AVALANCHE",
  "BLIZZARD",
  "DUSTSTORM",
  "FLOOD/ING/S",
  "HAIL STORM/S",
  "ICE STORM",
  "LANDSLIDE",
  "LIGHTNING",
  "RAIN",
  "SNOW FALL",
  "SNOW MELT",
  "SNOW STORM",
  "TSUNAMI",
  "THUNDER STORM",
  "TYPHOON",
  "WATERSPOUT",
  "VOLCANIC",
  "TORNADO",
  "HEAT",
  "WIND",
  "HAIL",
  "COLD",
  "ICE",
  "HURRICANE",
  "SNOW",
  "SUMMARY",
  "TROPICAL STORM",
  "HIGH WIND",
  "HIGH SURF",
  "HEAVY SNOW",
  "HEAVY RAIN",
  "HEAVY SURF",
  "EXTREME WIND",
  "DUST DEVIL",
  "DRY MICROBURST",
  "FLASH FLOOD",
  "COASTAL FLOOD",
  "COASTAL FLOOD")

sufficentDescription.1 <- list(
  "WIND",
  "MICROBURST",
  "STORM,
  DEVIL")

newEVTYPE <-
  mapply(function(evt,evt.1,evt.2){
    ifelse(
      test = evt %in% sufficentDescription,
      yes = evt,
      no = paste(
        evt,
        ifelse(
          test = is.na(evt.1),
          yes = "",
          no = evt.1
        ),
        ifelse(
          test = is.na(evt.2) |evt.1 %in% sufficentDescription.1,
          yes = "",
          no = evt.2
        ),
      sep = " ")
    )
  },t$EVTYPE,t$EVTYPE.1,t$EVTYPE.2,SIMPLIFY = TRUE)
t$EVTYPE <- newEVTYPE
process.dfContext(t%>%select(-c(EVTYPE.1,EVTYPE.2,EVTYPE.3,EVTYPE.4)))

#' ```
# DataTransformation.OrganizeVariables.TidyVariables ---------------------------------------



# DataTransformation.GroupVariables.groupby ---------------------------------
#' ```{r echo=FALSE,eval=TRUE, results='hide'}
group <- list("EVTYPE")
transform.groupRowsBy(process.dfContext(),group)
#' ```
# DataTransformation.OrganizeVariables.SortedByDateAndEvent ---------------------------------------


# DataTransformation.ExamineData.MissingValues ---------------------------------

helper.decision.View("Generaly there are very few missing values in the data set.
The F variable by far contains the most and is to be expected as these events are
rare.")

#' ```{r, cache=TRUE,fig.cap = "Missing values will not be an issue. The F variable can be used as an aesthetic in a plot"}
analyze.missing.Plot(process.dfContext())
#' ```
# DataTransformation.ExamineData.ManagedMissingValues ---------------------------------------



