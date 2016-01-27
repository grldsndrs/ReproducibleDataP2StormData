library('ProjectTemplate')
load.project()

# Run these commands to (send requests) find analysis scripts
# to build a script to compile into a .Rmd file (notebook)
# via the render command.

# List scripts to include in reports

analyst <- paste0(wd,c(
  "/src/test1.R",
  "/src/test2.R"))
# make data table of source code
reportTable <- helper.makeReportTable(analyst)

# Build report by concatenating files pieces
report <- helper.makeReportDotR(reportTable)





# Use knitr to generate report
rmarkdown::render(input=reportPath,
                  output_format="html_document")

rmarkdown::render(input=reportPath,
                  output_format="pdf_document")

rmarkdown::render(input=reportPath,
                  output_format="md_document")

# rmarkdown::includes( after_body=TRUE)
 # rmarkdown::knitr_options_html()
# rmarkdown::tufte_handout()
