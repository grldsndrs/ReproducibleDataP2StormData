#' ---
#' title: "Strorm Data Effect"
#' author: grldsndrs
#' output: html_document
#' date: !r date()
#' params:
#'   start: !r FALSE
#' snapshot: !r as.POSIXct("2015-01-01 12:30:00")
#' ---
# Knitr.Options.WorkingDirectory -----------------------------------------------------------
#' `r opts_knit$set(root.dir='..')`
#'  ```{r}
helper.loadData()
params$region
#' ```
# test 1
# Introduction
# The Tufte-\LaTeX\ [^tufte_latex] document classes define a style similar to the style Edward Tufte uses in his books and handouts. Tufte's style is known for its extensive use of sidenotes, tight integration of graphics with text, and well-set typography.
# Headings
# This style provides a- and b-heads (that is, `#` and `##`), demonstrated above.
# An error is emitted if you try to use `###` and smaller headings.
# \newthought{In his later books}[^books_be], Tufte starts each section with a bit of vertical space, a non-indented paragraph, and sets the first few words of the sentence in small caps. To accomplish this using this style, use the `\newthought` command as demonstrated at the beginning of this paragraph.
# Figures
## Margin Figures
# Images and graphics play an integral role in Tufte's work. To place figures or tables in the margin you can use the `fig.margin` knitr chunk option. For example:
# test section ------------------------------------------------------------
# question.problem.part ---------------------------------------------------
#' ```{r, fig.margin = TRUE, fig.cap = "Sepal length vs. petal length, colored by species"}
library(ggplot2)
qplot(Sepal.Length, Petal.Length, data = iris, color = Species)
#' ```
#  -+----------------------------------------------------------------------
#' ```{r, fig.margin = TRUE, fig.cap = "Sepal length vs. petal length, colored by species"}
library(ggplot2)
qplot(Sepal.Length, Petal.Length, data = iris, color = Species)
#' ```
#  -+----------------------------------------------------------------------
