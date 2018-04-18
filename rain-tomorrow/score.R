# Load model, interactively request data, predict.

suppressMessages(
{
  library(rpart)
  library(magrittr)
  library(dplyr)
  library(tidyr)
  source("rattle.R")
})

load("weatherAUS.RData")

dsname <- "weatherAUS"
ds     <- get(dsname)

names(ds) %<>% normVarNames()

ds %<>%
  select(-date, -location, -risk_mm) %>%
  drop_na()

names(ds)[which(names(ds) == "rain_tomorrow")] <- "target"

load("rain-tomorrow.RData")

cat("\n===========================================\n",
    "Provide values for the following variables",
    "\n===========================================\n\n")

# The following code based on rpart::printcp()
# Copyright (c) Brian Ripley

frame <- model$frame
leaves <- frame$var == "<leaf>"
used <- unique(frame$var[!leaves])
unused <- setdiff(names(ds), used)

val <- vector()
for (i in seq_len(length(used)))
{
  v  <- used[i]
  cl <- class(ds[[v]])
  if (cl == "numeric")
  {
    cl <- sprintf("numeric %4.1f - %4.1f", min(ds[[v]]), max(ds[[v]]))
    asis <- "as.numeric"
  }
  cat(sprintf("%-15s [%s]: ", v, cl))
  entry <- scan("stdin", 0,  n=1, quiet=TRUE)
  val <- c(val, eval(parse(text=sprintf("%s(%s)", asis, entry))))
}

newdata <- ds[1,]
usedi <- sapply(used, function(x) which(x == names(ds)))
newdata[1,usedi] <- val
unusedi <- sapply(unused, function(x) which(x == names(ds)))
newdata[1,unusedi] <- NA

pr <- predict(model, newdata=newdata)[,"Yes"]

cat(sprintf("\nI predict the chance of rain tomorrow to be %2.0f%%.\n", 100*pr))

cat("\nThanks for exploring the rain-tomorrow model.\n\n")
