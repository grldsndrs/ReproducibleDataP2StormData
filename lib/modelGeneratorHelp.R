# Load Data Helper Class

process.loadData <- function(veu)
{
  if (hasArg(veu)){tag=veu}else{tag="Data Processing: Load Data via ProjectTemplate"}
  # DataProcessing.LoadData.LoadProjectTemplate -----------------------------
  #' ```{r echo = TRUE, eval= TRUE }
  library('ProjectTemplate')
  load.project()
  #' ```
  loadProjOutput <- NA

  #' ```{r echo = FALSE, eval= TRUE }
  cache.project()
  #' ```
  #  DataProcessing.LoadData.End --------------------------------------------
  list(tag=tag,
       out=loadProjOutput)
}


clean.variable.name <- function(variable.name)
{
# Translate a file name into a valid R variable name.

# This function will translate a file name into a name that is a valid
# variable name in R. Non-alphabetic characters on the boundaries of the
# file name will be stripped; non-alphabetic characters inside of the file
# name will be replaced with dots.

# @param variable.name A character vector containing a variable's proposed
# name that should be standardized.

# @return A translated variable name.

# @examples
# library('ProjectTemplate')
  variable.name <- gsub('^[^a-zA-Z0-9]+', '', variable.name, perl = TRUE)
  variable.name <- gsub('[^a-zA-Z0-9]+$', '', variable.name, perl = TRUE)
  variable.name <- gsub('_+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('-+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('\\s+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('\\.+', '.', variable.name, perl = TRUE)
  variable.name <- gsub('[\\\\/]+', '.', variable.name, perl = TRUE)
  variable.name <- make.names(variable.name)
  return(variable.name)
}

process.summurize <- function(dayta,veu)
{
  if (hasArg(veu)){tag=veu}else{tag="Summary"}

  if (hasArg(dayta)) {
    # DataProcessing.ExamineData.Summary --------------------------------------
    #' ```{r echo = FALSE, eval= TRUE }
    list(tag=tag,
         out=summary(dayta))
    #' ```

  } else{
    # get names of all data files in data folder

    dayta <- list.files(paste0(getwd(),c("/data")))

    sapply(dayta, function(daytaf) {

      #get rid of extension
      noExtensionName <- sub("^([^.]*).*", "\\1", daytaf )

      # clean name to match that loaded from Project Template
      properName <- clean.variable.name(noExtensionName)

      # DataProcessing.ExamineData.Summary --------------------------------------
      #' ```{r echo = TRUE, eval= TRUE }
      list(tag=tag,
      out=summary(eval(parse(text = properName))))
      #' ```
    },simplify = FALSE)
  }
  #  DataProcessing.ExamineData.End -----------------------------------------
}

process.structure <- function(dayta,veu)
{
  if (hasArg(veu)){tag=veu}else{tag="Structure"}

  if (hasArg(dayta)) {

    #' ```{r echo = FALSE, eval= TRUE }
    list(tag=tag,
         out=capture.output(str(dayta)))
    #' ```
  } else{
    # get names of all data files in data folder

    dayta <- list.files(paste0(getwd(),c("/data")))

    sapply(dayta, function(daytaf) {
      #get rid of extension
      noExtensionName <- sub("^([^.]*).*", "\\1", daytaf )

      # clean name to match that loaded from Project Template
      properName <- clean.variable.name(noExtensionName)

      #' ```{r echo = TRUE, eval= TRUE }
      list(tag=tag,
            out=capture.output(str(eval(parse(text = properName)))))
      #' ```
    },simplify = FALSE)
  }
  #  DataProcessing.ExamineData.End -----------------------------------------
}

analysis.getData <- function(dayta){

}
# The two functions implement a repositiory pattern in R.  The
# makeDataFrameRepository function gets and sets the data, while the
# dataframeContext implements the business logic that acts on the data

# makeDataFrameRepository creates a special object that stores a dataframe and
# cache's its inverse.  makeDataFrameRepository retrieves the data and maps it to the
# entity model, which is the returned specialObject.  The
# specialObject is a low level class that has an interface
# defined by makeDataFrameRepository  It is the repository.

process.makeDataFrameRepository <- function(x = data_frame()) {
  get <- function()
    x
  set <- function(newDF)
    x <<- newDF
  dfContext <- list(set = set, get = get)

  # dataframeContext  implements the business logic for the solution to the problem.
  # The model (data) is passed to it encapsulated in the makeCacheMatrix repository.
  # It operates on the model and returns an inverted matrix.


  process.dfContext <<- function(x, ...) {
    ## get or set dataframe
    if (!hasArg(x)) {
     # message("getting model data")
        dfContext$get()
    }
    else{
      dfContext$set(x)
      message("setting model data")
    }
  }
}
