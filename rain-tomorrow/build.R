# Build/save a decision tree model to predict rain tomorrow (target).

suppressMessages(
{
  library(rattle.data)
  library(magrittr)
  library(dplyr)
  library(rpart)
  source("rattle.R")
})

set.seed(42)

data(weatherAUS)

dsname <- "weatherAUS"
ds     <- get(dsname)

names(ds) %<>% normVarNames()

ds %<>%
  select(-date, -location, -risk_mm)
  

names(ds)[which(names(ds) == "rain_tomorrow")] <- "target"

cat("\n===========================\nBuild a Decision Tree Model\n===========================\n\n")

model <- rpart(target ~ ., data=ds, parms=list(prior=c(0.6, 0.4)))

cat("====================\nModel Saved as RData\n====================\n\n")

save(model, file="rain-tomorrow-dt.RData")

# Suggest next step.

cat("\nYou may like to evaluate the model performance by running the demo:\n",
    "\n  $ ml demo rain-tomorrow-dt\n\n")
