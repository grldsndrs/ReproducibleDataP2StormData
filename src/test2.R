# test 2

wd <- getwd()

analyst <- paste0(wd,c(
  "/src/test1.R",
  "/src/test2.R"))
# question1.problemA.part5 ---------------------------------------------------


#`  ```{r, fig.margin = TRUE, fig.cap = "Sepal length "vs". petal length, colored by species"}
library(ggplot2)
qplot(Sepal.Length, Petal.Length, data = iris, color = Species)
#` ```

#  -+----------------------------------------------------------------------
