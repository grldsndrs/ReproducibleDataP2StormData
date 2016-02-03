helper.decision.View <- function(veu)
{
  paste0("> ###### ", "**", gsub(pattern = "\\n", replacement = " ",x = veu),"**")
}

# DataTransformation.ExamineData.ScaledDollarAmmounts1 ---------------------------------
# map to scale dollar amounts by based on documentation
#' ```{r echo = TRUE, eval= FALSE }
helper.getMultiplier.Model <- function(multiprs) {

    switch (ifelse(multiprs == "" | multiprs == 0, yes = "1",no = multiprs),
      "?" = 0,
      "-" = 1,
      "+" = 1,
      "0" = 1,
      "1" = 1,
      "2" = 100,
      "3" = 1000,
      "4" = 10000,
      "5" = 100000,
      "6" = 1000000,
      "7" = 10000000,
      "8" = 100000000,
      "h" = 100,
      "H" = 100,
      "k" = 1000,
      "K" = 1000,
      "m" = 1000000,
      "M" = 1000000,
      "b" = 1000000000,
      "B" = 1000000000
    )
  #' ```
  # DataTransformation.Transform.Units --------------------------------------
}
