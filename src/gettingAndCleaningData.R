
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


# DataTransformation.ExamineData.OrganizeData ---------------------------------
helper.decision.View("The variables are reordered according to the role in the analysis.
Fixed values, such as location related variables, are the first coloums.
The measured values follow.")



# DataTransformation.OrganizeVariables.select ---------------------------------
#' ```{r echo=FALSE,eval=TRUE, results='hide'}
newOrder <- list(
  "STATE","BGN_DATE","END_DATE",
  "EVTYPE","F","MAG",
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
  "Factor","Numeric","Numeric",
  "Numeric","Numeric","Numeric","Numeric")
transform.selectClass(process.dfContext(),newOrder,newClass)
process.summurize(process.dfContext())
#' ```
# DataTransformation.ClassifyVariables.ClassfiedVariables ---------------------------------------


# DataTransformation.OrganizeVariables.arrange ---------------------------------
#' ```{r echo=FALSE,eval=TRUE, results='hide'}
arrangement <- list(
  "BGN_DATE", "END_DATE",
  "EVTYPE","MAG",
  "FATALITIES","INJURIES","PROPDMG","CROPDMG","F","STATE"
)
transform.orderRowsBy(process.dfContext(),arrangement)
#' ```
# DataTransformation.OrganizeVariables.SortedByDateAndEvent ---------------------------------------



# DataTransformation.GroupVariables.groupby ---------------------------------
#' ```{r echo=FALSE,eval=TRUE, results='hide'}
group <- list(
  "STATE",
  "EVTYPE")
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



