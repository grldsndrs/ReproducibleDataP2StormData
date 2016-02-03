# Data transformations helper class

transform.selectNames <- function(dayta,nms,veu)
{
  if (hasArg(veu)){tag=veu}else{tag="Selected Names"}

  if (hasArg(dayta)) {

    # DataTransformation.Selecting.RelevantData --------------------------------------
    # select variables
    #' ```{r echo = FALSE, eval= TRUE }
    # Dont know how but this works
    # http://stackoverflow.com/questions/22028937/how-can-i-tell-select-in-dplyr-that-the-string-it-is-seeing-is-a-column-name-i
    sbSet <- dayta %>%
      select_(.dots = nms[] %>% unname)

    list(tag=tag,
         out=head(sbSet),
         select=tbl_df(as.data.frame(sbSet)))
    #' ```

  }
}


transform.orderRowsBy <- function(dayta,srtOrdr,veu)
{
  if (hasArg(veu)){tag=veu}else{tag="Selected Names"}

  if (hasArg(dayta)) {

    # DataTransformation.Arranging.RelevantData --------------------------------------
    # sort rows
    #' ```{r echo = FALSE, eval= TRUE }
    # Dont know how but this works
    # http://stackoverflow.com/questions/22028937/how-can-i-tell-select-in-dplyr-that-the-string-it-is-seeing-is-a-column-name-i
    sbSet <- dayta %>%
      arrange_(.dots = srtOrdr[] %>% unname)

    list(tag=tag,
         out=head(sbSet),
         select=tbl_df(as.data.frame(sbSet)))
    #' ```

  }
}


transform.groupRowsBy <- function(dayta,grpOrdr,veu)
{
  if (hasArg(veu)){tag=veu}else{tag="Grouped Names"}

  if (hasArg(dayta)) {

    # DataTransformation.Grouping.RelevantData --------------------------------------
    # sort rows
    #' ```{r echo = FALSE, eval= TRUE }
    # Dont know how but this works
    # http://stackoverflow.com/questions/22028937/how-can-i-tell-select-in-dplyr-that-the-string-it-is-seeing-is-a-column-name-i
    sbSet <- dayta %>%
      group_by_(.dots = grpOrdr[] %>% unname)

    list(tag=tag,
         out=head(sbSet),
         select=tbl_df(as.data.frame(sbSet)))
    #' ```

  }
}


transform.selectClass <- function(dayta,nms,clsss,veu)
{
  if (hasArg(veu)){tag=veu}else{tag="Selected Variable Classes"}

  if (hasArg(dayta)) {

    # DataTransformation.Classifying.RelevantData --------------------------------------
    # classifiy variables
    #' ```{r echo = FALSE, eval= TRUE }
    #'
    # http://stackoverflow.com/questions/27435873/changing-class-of-data-frame-columns-using-strings
    # add each new control to database
    classConfirm <-
      mapply(function(nm, cls) {
      class(dayta[nm]) <- cls
    },
    nms,
    clsss
    , SIMPLIFY  = FALSE)

    list(tag=tag,
         out=table(unlist(classConfirm[]),unlist(nms[])))
    #' ```

  }
}


transform.cleanNames <- function(dayta,veu)
{
  if (hasArg(veu)){tag=veu}else{tag="Clean Names"}

  if (hasArg(dayta)) {

    # DataTransformation.Naming.SyntacticallyCorrect --------------------------------------
    # change names
    #' ```{r echo = FALSE, eval= TRUE }
    newNames <- make.names(names(x = dayta))
    names(dayta) <- newNames
    list(tag=tag,
         out=names(dayta))
    #' ```

  } else{
    # get names of all data files in data folder

    dayta <- list.files(paste0(getwd(),c("/data")))

    sapply(dayta, function(daytaf) {

      #get rid of extension
      noExtensionName <- sub("^([^.]*).*", "\\1", daytaf )

      # clean name to match that loaded from Project Template
      properName <- clean.variable.name(noExtensionName)
      properDf = eval(parse(text = properName))

      # DataProcessing.ExamineData.Summary --------------------------------------
      #' ```{r echo = TRUE, eval= TRUE }
      newNames <- make.names(names(x = properDf),unique = TRUE)
      names(properDf) <- newNames
      list(tag=tag,
           out= newNames)
      #' ```
    },simplify = FALSE)
  }
  #  DataTransformation.Naming.End -----------------------------------------
}






#' # create a time series by adding the intervals in minutes to the date
#' dts <- as.POSIXct(tidyData$date) + minutes(as.numeric(tidyData$interval ))
#' #' > choose appropriate classes for features
#' tidyData <- mutate(tidyData,
#'                    steps= as.numeric(steps),
#'                    date = as.factor(date),
#'                    interval=as.numeric(interval))
#' #' > create a time series
#' tidyDataXTS <- xts(tidyData ,order.by = dts,unique = TRUE)
