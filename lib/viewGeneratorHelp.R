# Generate Views Helper Class
# set the report file directory
wd <- getwd()


reportPath = paste0(wd, c("/reports/report.Rmd"))


reportViewOptionsPath = paste0(wd, c("/reports/reportViewOptionsHelp.Rmd"))


# create temp file for use as a clipboard
commandWTemp <- tempfile()
commandWTemp2 <- tempfile()

# remove #' from .R files and set any neccessary parameters
process.makeViews <- function(orderdReportTable) {
  # initialize report
  file.create(reportPath)
  # add Header data
  file.append(reportPath, reportViewOptionsPath)
  # create space between controls/sections
  cat("  ",
      file = reportPath,
      sep = "\n",
      append = TRUE)

  # if any controls are blank( no commands)
  orderdReportTableCompleteCase <-
    orderdReportTable[complete.cases(orderdReportTable), ]

  mapply(
    function(controller, start, range) {
      controllerViewRequest <-
        scan(
          file = controller,
          what = "character",
          sep = "\n",
          quote = "",
          dec = ".",
          na.strings = "NA",
          nlines = range,
          skip = start,
          fill = FALSE,
          strip.white = FALSE,
          blank.lines.skip = FALSE,
          comment.char = "",
          allowEscapes = FALSE,
          flush = FALSE,
          skipNul = FALSE
        )


      if (sum(nchar(controllerViewRequest)))
      {
        commandR <-
          read.table(
            file = controller,
            header = FALSE,
            sep = "\n",
            quote = "",
            dec = ".",
            numerals = "no.loss",
            na.strings = "NA",
            colClasses = NA,
            nrows = range,
            skip = start,
            fill = FALSE,
            strip.white = FALSE,
            blank.lines.skip = FALSE,
            comment.char = "",
            allowEscapes = FALSE,
            flush = FALSE,
            stringsAsFactors = FALSE,
            skipNul = FALSE
          )
      }
      else
      {
        commandR <- data.frame(nothing = character())
      }

      # find .View requests
      viewRequestsNdc <- grep("^.+[.][View(]", commandR[[1]])

      # recursive function to build command from lines in a file
      srcRqst <<- function(ndx) {
        # create script for evaluation
        writeLines(commandR[[1]][ndx], commandWTemp)

        # try to source it
        out <- try(source(commandWTemp),silent = TRUE)

        # if line is incomplete try to add next line
        if (identical(class(out), "try-error")) {
          # if line is
          if (any(nrow(commandR) == ndx)) {
            # end of data or real error apparently
            return
          }
          else{
            # call self with additional line
            srcRqst(c(ndx, ndx[length(ndx)] + 1))
          }
        }
        else
        {
          # delete the command and replace with output
          commandR[ndx,] <- NA
          commandR[ndx[1],] <- out[[1]]
          commandR <<- commandR[complete.cases(commandR),]
        }
      }

      # try and source the View requests
      sapply(viewRequestsNdc, srcRqst, simplify = FALSE)

      write.table(
        x = commandR,
        file = commandWTemp,
        row.names = FALSE,
        col.names = FALSE,
        sep = "\n",
        quote = FALSE,
        dec = ".",
        na = "NA"
      )
      # find all #' and delete
      commandViewWTemp <-
        gsub("^[#]['][ ]", "", readLines(commandWTemp))

      cat(
        commandViewWTemp ,
        file = reportPath,
        sep = "\n",
        append = TRUE
      )
      cat("  ",
          file = reportPath,
          sep = "\n",
          append = TRUE)

    },
    orderdReportTableCompleteCase$controller,
    orderdReportTableCompleteCase$section.start,
    orderdReportTableCompleteCase$section.range,
    SIMPLIFY  = FALSE
  )

  file.remove(commandWTemp)
  reportPath
}
