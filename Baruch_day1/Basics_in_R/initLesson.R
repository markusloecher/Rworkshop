# Code placed in this file fill be executed every time the
      # lesson is started. Any variables created here will show up in
      # the user's working directory and thus be accessible to them
      # throughout the lesson.

load_packages <- function(x){
  for(i in 1:length(x)){  
    if(!require(x[i], character.only = TRUE)) {
      install.packages(x[i], repos="http://cran.us.r-project.org")
      require(x[i], character.only = TRUE)
    }
  }
}

load_packages(c("dplyr", "ISLR", "ggplot2"))

assign("Auto", ISLR::Auto, envir=globalenv())

swirl_options(swirl_logging = TRUE)