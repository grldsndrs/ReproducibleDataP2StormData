
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
#' #####Note


helper.decision.View("The table above indicates that the data could be tidyer.
                     The Event Type variable has multiple varibles embeded and
                     they could be separated.  However, any scheme that I come
                     is aribitary due to my lack of domain knowlege.
                     Therefore, I will use the judgement of those that put together
                     the list.  In short, I will not tidy the EVTYPE further")
# EventType.EconomicConsequences.TableEconomicsByStormData ---------------------------------------





# EventType.EconomicConsequences.SubSetData ---------------------------------------------------


#### Results

## _**Which types of events have the greatest economic consequences?**_
### and
## _**Which types of events are most harmful to Human Health?**_

##### The data are grouped by EVTYPE and ordered by BGN_DATE.
##### The color and opacity of each name is scaled according to the cost function listed at the end of this doccument in a variable called scaled.Cost.#####
##### The MAG variable has been scaled to the symbol fill color.
##### The F variable scales to the line color of the symbol.
##### Fatalities scale to the opacity of the symbol.
##### Injuries scale to the size of the symbol.
##### Finally the stroke of the line has been scaled to the *scaled* sum of Damages and Human suffuring.

helper.decision.View("Refer to the end of the documentto see how this calculated")

# EventType.EconomicConsequences.SubSetDataEnd ---------------------------------------------------

#' ```{r,  fig.margin = TRUE,fig.cap = "The visible Event Types have the greatest economic and health consquences"}
analyze.summarize.Plot(percentData = 1, percentile = 1, dayta = process.dfContext())
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
#' calculted metric scaled.Cost, which is based on the fundamental stat
#' refered to above.

#' The more visiable the name the larger the apparent cost.

#' ### The fadded names on the y axis can be regarded as having a relatively small measure of consequence (monetary or health).###
#' So the names which can be resolved most clearly can be regarded as having the Greatest Consequence,
#' in either respect.
#' Additionally, _the the text color has been scaled with the cost
#' statistic with the colors of a heat map._
#' The red-er colors indicate a higher cost. Also since the data are ordered by year one
#' can see when the events, that had the greatest impact, took place .

#' * #### Some unintended consequences of my plot design.####
#' + The grouping of the event types on the y axis has caused a super positon of the colors.
#' + The text is scaled to heat map colors (yellows oranges and reds), but since each observation
#' in the data have an event type, with its own scaled color, the device draws the label for that
#' row with the individual's color.  Because they are grouped, matching label are drawn at the same positions.
#' + The color of the Event Types vary depending on how many observations it claims and the scale at which they register.

#' + The hot colors( reds ,oranges) are those which can address the issue of consquences.

#' + The supprising thing is that the Events which do not have a high relative cost , but have high
#' + repeatablity manifest themselves in black text.
#' + The black text color is not on the heat map color scale.
#' + So why is there black text?  In a word, Superpostion.
#' + The opacity on the events that have low cost is high, making their text barely visible with a
#' bright yellow color.
#' + However, since some of these events have thousands of observations, that barely visible
#' color adds up an eventually makes the text visible.

#' * #### This unintended effect has made this design difficult to use, as the low cost Events were intended to have barely visible y labels.####
#' + On the other hand, it does show that there is a sort of additive high cost associated with events that have
#' high repeatablity.


#' ##EventType Economic Consequences Appendix ---------------------------------------
