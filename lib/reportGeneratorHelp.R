# Generate Reports Helper Class
wd <- getwd();
reportPath = paste0(wd,c("/reports/report.R"));

 commandWTemp <- tempfile()

helper.findSections <- function(dotRFile)
{
  all_data = readLines(dotRFile)
  # find the sections
  reportControlsL = grep("^[#][ ](\\w)+(\\.){1}(\\w)+(\\.){1}(\\w)+[ ]-*", all_data)

  c(dotRFile ,reportControlsL)

}

helper.parseSectionData <- function(dotRFile,reportControlsL)
{
  if (!is.na(reportControlsL)) {
  }else{
  }

  reportControlRangeL <-
    if (length(reportControlsL) > 1)
      diff(reportControlsL)
  else
    length(readLines(dotRFile)) - as.numeric(reportControlsL)

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

helper.makeReportTable <- function(userRequests) {
  reportRequestDF <- data.frame(
    question = character(),
    problem = character(),
    part = character(),
    section.start = integer(),
    section.range = integer(),
    controller = character(),
    stringsAsFactors = FALSE
  )

  sapply(userRequests, function(controllerResponse) {
    controller <-
      helper.findSections(controllerResponse)
    controllerParmeters <-
      helper.parseSectionData(controller[1],controller[2])

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
  },simplify = FALSE)

  reportRequestDF$problem <- as.factor(reportRequestDF$problem)
  reportRequestDF$part <- as.factor(reportRequestDF$part)
  reportRequestDF$section.start <- as.numeric(reportRequestDF$section.start)
  reportRequestDF$section.range <- as.numeric(reportRequestDF$section.range)
  tbl_df(reportRequestDF)
}

helper.makeReportDotR <- function(orderdReportTable) {
  file.create(reportPath)

  orderdReportTableCompleteCase <- orderdReportTable[complete.cases(orderdReportTable),]

  mapply(
    function(controller,start,range) {

      commandR <- read.table(file = controller, header =FALSE,sep ="\n", quote = "",
                             dec = ".", numerals = "no.loss",
                             na.strings = "NA", colClasses = NA, nrows = range,
                             skip = start, fill = FALSE,
                             strip.white = FALSE, blank.lines.skip = TRUE,
                             comment.char = "",
                             allowEscapes = FALSE, flush = TRUE,
                             stringsAsFactors = FALSE,skipNul = TRUE)

      write.table(x = commandR,file = commandWTemp, row.names = FALSE,
                  col.names = FALSE, sep = "\n", quote =FALSE,
                  dec = ".",na = "NA")

      file.append(reportPath,commandWTemp)

    },
    orderdReportTableCompleteCase$controller,
    orderdReportTableCompleteCase$section.start,
    orderdReportTableCompleteCase$section.range,
    SIMPLIFY  = FALSE
  )

file.remove(commandWTemp)
  reportPath
}

