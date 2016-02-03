
# EventType.EconomicConsequences.ShowAllData ---------------------------------------------------
#' ```{r echo=FALSE,eval=TRUE,results='hide'}
eventCostTable <- analyze.summarize.Table(.data = group_by(process.dfContext(),EVTYPE),
                       Fatlaities=sum(FATALITIES,na.rm = TRUE),
                       Injuries=sum(INJURIES,na.rm = TRUE),
                       PropDmg=sum(PROPDMG,na.rm = TRUE),
                       CropDmg=sum(CROPDMG,na.rm = TRUE),
                       veu ="Table showing the Cost in dollars vs Event Type for all data")
#' ```

#' ```{r kable, echo=FALSE,eval=TRUE}
print(eventCostTable$out,type="html")
#' ```
# EventType.EconomicConsequences.TableEconomicsByStormData ---------------------------------------




# EventType.EconomicConsequences.SubSetData ---------------------------------------------------

#### Results

## _**Which types of events have the greatest economic consequences?**_
### and
## _**Which types of events are most harmful to Human Health?**_

helper.decision.View("The data are grouped by EVTYPE and ordered by BGN_DATE.
                     The color and opacity of each name is scaled according to
                     a cost function calculatd.  It is listed at the end of this
                     doccument. Is a variable called scaled.Cost.Alpha. The
                     variable has been scaled to the symbol fill color.
                     The F variable scale to the line color of the symbol.
                     Fatalities scale to the opacity of the symbol. Injuries
                     scale to the size of the symbol. Finally the stroke of
                     the line has been scaled to the *scaled* sum of Damages
                     and Human suffuring. Refer to the end of the document
                     to see how this calculated")

# EventType.EconomicConsequences.SubSetDataEnd ---------------------------------------------------

#' ```{r fig.margin = TRUE,fig.cap = "The visible Event Types have the greatest economic and health consquences"}
analyze.summarize.Plot(percentile = .001,dayta = process.dfContext())
#' ```


#### Synopsis
#' This plot summarizes the data so that the storm data,
#' can be viewed as a function of the Cost of storm, in terms
#' of human health consequense and finacial damages.
#' The fundamental statistic calculated here is the sum of
#' the Crop and Property damages. This sum is used as input
#' to the model while other variable of interest, such as
#' Injuries and Fatalities have been scaled in an aesthetics
#' to decorate that fundamental statistic.

#' The result is a plot in which the highest cost data
#' points stand out in either size or color and tend to the right
#' side of the graph.
#' The left side provides the answer to the questions posed.

#' Each Event Type name, has be scaled in color and opacity according to the
#' calculted metric scaled.Cost.Alpha, which is based on the fundamental stat
#' refered to above.

#' The more visiable the name the larger the apparent cost.

#' ### _**The fadded names on the y axis can be regarded as having a relatively small amount
#' of consequence (monetary or health).  So the names which can be resolved most clearly
#' can be regarded as having the Greatest Consequence, in either respect.**_


#' ##EventType Economic Consequences Appendix A ---------------------------------------
