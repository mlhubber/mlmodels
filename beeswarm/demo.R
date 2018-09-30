########################################################################
# Introduce the concept of scatter plots using bee swarm through ML Hub
#
# Copyright 2018 Graham.Williams@togaware.com

#-----------------------------------------------------------------------
# Load required packages from local library into the R session.
#-----------------------------------------------------------------------

suppressMessages(
{
library(magrittr)     # Data pipelines: %>% %<>% %T>% equals().
library(rattle)       # Support: normVarNames(), weatherAUS. 
library(ggbeeswarm)   # 
library(ggplot2)      # Visualise data.
library(dplyr)        # Wrangling: sample_n()
library(randomForest) # Missing data: na.roughfix().
})

cat("\n===========================",
    "\nIntroducing Bee Swarm Plots",
    "\n===========================\n\n")

cat("The beeswarm package provides jittered scatter plots that avoid\n")
cat("the typical overplotting of traditional scatter plots.\n\n")

cat("The demonstration here is motivated by the examples published on\n")
cat("github: https://github.com/eclarke/ggbeeswarm/blob/master/README.md\n\n")

cat("Press the <Enter> key after each message to progress through each plot.\n")
cat("Close the graphic window (Ctrl-W) to continue on to the next plot.\n\n")

#-----------------------------------------------------------------------
# Identify the data source and refence using template variables.
#-----------------------------------------------------------------------

dsname    <- "weatherAUS"
ds        <- get(dsname) %>% sample_n(1000)
names(ds) %<>% normVarNames()

xv <- "rain_tomorrow"
yv <- "humidity_3pm"

vars <- c(xv, yv)

ds[vars] %<>% na.roughfix() # Removing missing values.

#-----------------------------------------------------------------------
# Start with a basic scatter plot.
#-----------------------------------------------------------------------

cat("We begin with a basic scatter plot of points that over-plots points: ")
invisible(readChar("stdin", 1))

# Plot a basic jitter plot.

fname <- "plot_scatter.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes_string(x=xv, y=yv)) +
  geom_point()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Compare that to a basic jitter plot
#-----------------------------------------------------------------------

cat("\nNow we use the jitter geometry to jitter the over-plotted points: ")
invisible(readChar("stdin", 1))

# Plot a basic jitter plot.

fname <- "plot_jitter.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes_string(x=xv, y=yv)) +
  geom_jitter()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Compare it to a quasirandom layout
#-----------------------------------------------------------------------

cat("\nNext we can compare this to the more informative geom_quasirandom(): ")
invisible(readChar("stdin", 1))

fname <- "plot_jitter_quasirandom.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes_string(x=xv, y=yv)) +
  geom_quasirandom()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# Compare it to a deeswarm layout
#-----------------------------------------------------------------------

cat("\nNext we use geom_beeswarm(): ")
invisible(readChar("stdin", 1))

fname <- "plot_jitter_beeswarm.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes_string(x=xv, y=yv)) +
  geom_beeswarm()
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# A tukey plot.
#-----------------------------------------------------------------------

cat("\nUse Tukey's method for jittering: ")
invisible(readChar("stdin", 1))

fname <- "plot_quasirandom_tukey.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes_string(x=xv, y=yv)) +
  geom_quasirandom(method="tukey")
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

#-----------------------------------------------------------------------
# A smiley plot.
#-----------------------------------------------------------------------

cat("\nHow about a smiley plot: ")
invisible(readChar("stdin", 1))

fname <- "plot_quasirandom_smiley.pdf"
pdf(file=fname, width=8)
ds %>%
  ggplot(aes_string(x=xv, y=yv)) +
  geom_quasirandom(method="smiley")
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)
