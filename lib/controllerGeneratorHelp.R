# Populate the Registery with .R chunks
# set the report file directory
wd <- getwd();
reportPath = paste0(wd,c("/reports/report.Rmd"));

# create temp file for use as a clipboard
commandWTemp <- tempfile()

# find all sections in given file
process.findSections <- function(dotRFile)
{
  all_data = readLines(dotRFile)
  # find the sections
  reportControlsL = grep("^[#][ ](\\w)+(\\.){1}(\\w)+(\\.){1}(\\w)+[ ]-*", all_data)

  # check if there is more than 1 section
  # if there is only one range is to the end of file
  numCntl =length(reportControlsL)
  reportControlRangeL <-
    if (numCntl > 1)
      c(diff(reportControlsL)-1, length(readLines(dotRFile)) - as.numeric(reportControlsL[numCntl]))
  else
    length(readLines(dotRFile)) - as.numeric(reportControlsL)

  # return file path and indicies of the sections
  c("controller"=dotRFile ,data.frame("control"=reportControlsL,"range"=reportControlRangeL))
}
# extract data fro, section head
process.parseSectionData <- function(dotRFile,reportControlsL,reportControlRangeL)
{
  # missing data case
  if (!is.na(reportControlsL)) {
  }else{
  }

# find the descriptions in the section text
  parseSectionData  <-
    mapply(function(reportControl,reportControlRange) {
      reportAnalysisNdc <-
        str_split(grep(
          "(\\w)+(\\.){1}(\\w)+(\\.){1}(\\w)+", # find the section descriptions
          scan(
            dotRFile,
            what = "list",
            quote = "",
            skip = reportControl - 1,
            nlines = 1,
            multi.line = TRUE,
            sep = ""
          ),
          value = TRUE
        ),
        pattern = "\\.")

      if (length(reportAnalysisNdc) == 0)
        reportAnalysisNdc[1:3] <- NA
      # return the 3 components of section description
      # as well as the index and range of its location
      # and the file path
      c(
        reportAnalysisNdc[[1]][1],
        reportAnalysisNdc[[1]][2],
        reportAnalysisNdc[[1]][3],
        reportControl,
        reportControlRange,
        dotRFile
      )
    },
    as.numeric(reportControlsL),
    reportControlRangeL,
    SIMPLIFY = FALSE)

  parseSectionData
}

process.makeReportTable <- function(filesToExtractSections) {
  # initalize a dataframe
  reportRequestDF <- data.frame(
    question = character(),
    problem = character(),
    part = character(),
    section.start = integer(),
    section.range = integer(),
    controller = character(),
    stringsAsFactors = FALSE
  )
  # use the fields in the dataframe passed in to
  # find and append sections to a report
  # user requests the filesToExtractSections
  # this routing engine first parses the files for sections
  sapply(filesToExtractSections, function(allControllers) {

    # find sections
    controllers <-
      process.findSections(allControllers)

    # add each new control to database
    mapply(function(control,range) {
      controllerParmeters <-
      process.parseSectionData(controllers$controller,control,range)

    # add to the data base
    newControl <-
      as.data.frame(
        matrix(
          unlist(controllerParmeters),
          nrow = 1 ,ncol = 6,byrow = FALSE
        ),
        byrow = TRUE,stringsAsFactors = FALSE
      )

    reportRequestDF[nrow(reportRequestDF) + 1,] <<- newControl

    newControl
    },controllers$control,controllers$range
    ,SIMPLIFY  = FALSE)
  },simplify = FALSE)

  reportRequestDF$problem <- as.factor(reportRequestDF$problem)
  reportRequestDF$part <- as.factor(reportRequestDF$part)
  reportRequestDF$section.start <- as.numeric(reportRequestDF$section.start)
  reportRequestDF$section.range <- as.numeric(reportRequestDF$section.range)
  tbl_df(reportRequestDF)
}



