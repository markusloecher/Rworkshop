About this workshop
===================

Goals
-----

This 2.5 day workshop is intended to leave participants up and running with the R statistical software. It is an attempt to provide the solid foundation needed to begin using R in your data analysis and statistical needs. No previous experience is required, though some basic programming or data science experience is helpful.

Agenda
------

### Day 1: Basic R programming

-   data types, vectors, matrices, strings, factors
-   control structures (for, if else, while)
-   functions, R markdown
-   basic plotting
-   computing with probabilities and distributions

### Day 2: Intermediate and advanced R programming topics

-   Performing descriptive statistics
-   Basic statistical tests (t-tests, single regression, correlation, ANOVA, logistic regression)
-   data manipulation
-   Data visualization with ggplot2

### Day 3 Specialized Topics (optional half-day):

Options:

-   Packages for faster data manipulation (dplyr, data.table)
-   Panel data
-   Interactive javscript based plots
-   time series
-   Logistic regression
-   trees

------------------------------------------------------------------------

How you should prepare
----------------------

The workshop will contain plenty of hands-on, interactive explorations of real data sets with relevant spatial and temporal information.

You should install the [R](https://cran.r-project.org/) language and its popular IDE [RStudio](https://www.rstudio.com/products/rstudio/download/) prior.

### Required libraries

When you start RStudio you should see 3 panels, one of them the *Console* where you can type commands.

``` r
#mandatory
install.packages(c("knitr", "markdown", "rmarkdown","ggplot2", "dplyr","swirl", "RgoogleMaps", "nycflights13", "stringr", "ISLR"), dependencies = TRUE)
#nice-to-have
install.packages(c("dygraphs" "AER", "plm"), dependencies = TRUE)
```

After this, load the swirl library and install our course:

``` r
library(swirl)
install_course_github("markusloecher", "Rworkshop/Baruch_day1")
```

### Data sets

-   [Titanic](data/TitanicTrain.csv)
-   [Global Temperature](data/global.dat)
-   [birth weights](data/BirthWeights.rda)

------------------------------------------------------------------------

### Links

[Berlin School of Economics and Law](http://www.hwr-berlin.de "BSEL Homepage")

[Prof. Markus Loecher](http://www.hwr-berlin.de/fachbereich-wirtschaftswissenschaften/kontakt/personen/kontakt-info/2184/ "ML official university link")

[my blog](https://blog.hwr-berlin.de/codeandstats/ "blog")

[my RgoogleMaps package](http://rgooglemaps.r-forge.r-project.org/ "RgoogleMaps on Rforge")
