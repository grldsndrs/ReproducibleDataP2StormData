library('ProjectTemplate')
reload.project()

# Run these commands to (send requests) find analysis scripts
# to build a script to compile into a .Rmd file (notebook)
# via the render command.

# List scripts to include in reports
analyst <- paste0(wd,c(
  "/src/gettingAndCleaningData.R",
  "/src/analyzingData.R",
  "/munge/10-plotViewHelp.R"
))

# make data table of source code
register <- process.makeReportTable(analyst)

# request get the views for the registered items in reportTable
registeredViews <- process.makeViews(register[register$part!="Exclude",])

# Build report by concatenating file pieces
# create an order to the out put by selecting and
# and sorting the report table
# report <- helper.makeReportDotR(reportView)
# report <- helper.makeReportDotR(register)

report.md <- rmarkdown::render(input=registeredViews,
                  output_format="md_document")
# rmarkdown::render(input=reportPath,
#                   output_format="md_document")



# Use knitr to generate report
report.html <- rmarkdown::render(input=registeredViews,
                  output_format="html_document")

report.pdf <- rmarkdown::render(input=registeredViews,
                  output_format="pdf_document")

ldData<-helper.loadData()
smry <- helper.summurize()
smry[[1]][1]
smry[[1]][2]
strc <- helper.structure()
strc[[1]][1]

simple_source <- function(file, envir = new.env()) {
  stopifnot(file.exists(file))
  stopifnot(is.environment(envir))

  lines <- readLines(file, warn = FALSE)
  exprs <- parse(text = lines)

  n <- length(exprs)
  if (n == 0L) return(invisible())

  for (i in seq_len(n - 1)) {
    eval(exprs[i], envir)
  }
  invisible(eval(exprs[n], envir))

  curr.pos <- which(df$Markers == "Start")[[1]]  # taking first "Start" in case you have more than one
  new.pos <- with(df, max(which(Seconds <= Seconds[[curr.pos]] + 0.5)))
  df$Markers[c(curr.pos, new.pos)] <- c("NA", "Start")
}
# rmarkdown::includes( after_body=TRUE)
 # rmarkdown::knitr_options_html()
# rmarkdown::tufte_handout()
