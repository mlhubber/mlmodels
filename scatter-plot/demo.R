########################################################################
# Introduce the concept of scatter plots through ML Hub
#
# Copyright 2018 Graham.Williams@togaware.com

#-----------------------------------------------------------------------
# Load required packages from local library into the R session.
#-----------------------------------------------------------------------

suppressMessages(
{
library(magrittr)     # Data pipelines: %>% %<>% %T>% equals().
library(rattle)       # Support: normVarNames(), weatherAUS. 
library(ggplot2)      # Visualise data.
library(dplyr)        # Wrangling: tbl_df(), group_by(), print().
library(randomForest) # Model: randomForest() na.roughfix() for missing data.
})

cat("\n========================================",
    "\nIntroducing Scatter Plots with R ggplot2",
    "\n========================================\n\n")

cat("The iris dataset is used to introduce scatter plots.\n\n")

cat("These examples come from the book, Essentials of Data Science, by Graham Williams.\n")
cat("Used with permission. Visit https://essentials.togaware.com\n\n")

cat("Press the <Enter> key after each message to progress through each plot.\n")
cat("Close the graphic window (Ctrl-W) to continue on to the next plot.\n\n")

#-----------------------------------------------------------------------
# Identify the data source and refence using template variables.
#-----------------------------------------------------------------------

dsname    <- "iris"
ds        <- get(dsname)
names(ds) %<>% normVarNames()

cat("We begin with a basic scatter plot of points for two dimensions (variables): ")
invisible(readChar("stdin", 1))

# Plot a basic scatter plot.

fname <- "iris_scatter.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes(x=sepal_length, y=sepal_width)) +
  geom_point()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Add a line to the scatter plot.
#-----------------------------------------------------------------------

cat("\nNext we can add a line to the plot though it is rather jagged: ")
invisible(readChar("stdin", 1))

fname <- "iris_scatter_line.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes(x=sepal_length, y=sepal_width)) +
  geom_point() +
  geom_line()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Add a smoothed fitted line to the scatter plot.
#-----------------------------------------------------------------------

cat("\nThe line can be smoothed using a statistical fit function: ")
invisible(readChar("stdin", 1))

fname <- "iris_scatter_smooth.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes(x=sepal_length, y=sepal_width)) +
  geom_point() +
  stat_smooth(method="loess")
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Colour the dots on the scatter plot.
#-----------------------------------------------------------------------

cat("\nWe can choose to colour the points on the plot accroding to the species: ")
invisible(readChar("stdin", 1))

fname <- "iris_scatter_colour.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes(x=sepal_length, y=sepal_width, colour=species)) +
  geom_point()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Identify the weatherAUS dataset as the template dataset now.
#-----------------------------------------------------------------------

cat("\n====================\nPlot Weather Dataset\n====================\n\n")
cat("The Australian weather dataset from the Rattle package provides more data to explore.\n")

#-----------------------------------------------------------------------
# Prepare the dataset.
#-----------------------------------------------------------------------

cat("\nA scatter plot can get clutterd with many points so this is a sample of 1000: ")
invisible(readChar("stdin", 1))

dsname <- "weatherAUS"
ds     <- get(dsname)

# Cleanup the dataset.

names(ds) %<>% normVarNames()

vars   <- names(ds)
target <- "rain_tomorrow"
vars   <- c(target, vars) %>% unique()
risk   <- "risk_mm"
id     <- c("date", "location")
ignore <- c(risk, id)
vars   <- setdiff(vars, ignore)

ds[vars] %<>% na.roughfix()

#-----------------------------------------------------------------------
# A simple scatter plot of the data.
#-----------------------------------------------------------------------

fname <- "weather_scatter_colour.pdf"
pdf(file=fname, width=8)
ds %>%
  sample_n(1000) %>%
  ggplot(aes(x=min_temp, y=max_temp, colour=rain_tomorrow)) +
  geom_point() +
  scale_colour_brewer(palette="Set2")
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Identify structure in the data from a scatter plot.
#-----------------------------------------------------------------------

cat("\nA scatter plot can clearly convey some kinds of structure",
    "(e.g., seasonality) in the data: ")
invisible(readChar("stdin", 1))

fname <- "weather_scatter_seasons.pdf"
pdf(file=fname, width=8)
ds %>%
  filter(location=="Canberra") %>%
  ggplot(aes(x=date, y=max_temp)) +
  geom_point(shape=".") +
  geom_smooth(method="gam", formula=y~s(x, bs="cs"))
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# A faceted plot of scatter plots.
#-----------------------------------------------------------------------

cat("\nNext we present multiple scatter plots for different regions as a faceted plot: ")
invisible(readChar("stdin", 1))

fname <- "weather_scatter_faceted.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes(x=date, y=max_temp)) +
  geom_line(alpha=0.1, size=0.05) +
  geom_smooth(method="gam", formula=y~s(x, bs="cs"), size=0.05) +
  facet_wrap(~location) +
  theme(axis.text.x=element_text(angle=45, hjust=1))
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)
