# Load model, predict on a small dataset, present evaluation.

suppressMessages(
{
  library(rpart)
  library(magrittr)
  library(dplyr)
  library(tidyr)
  source("rattle.R")
})

set.seed(423)

load("rain-tomorrow.RData")

cat("\n=====================\nPredict Rain Tomorrow\n=====================\n\n")

cat("Applied to a validation dataset\nto estimate model accuracy.\n\n")

load("weatherAUS.RData")

dsname <- "weatherAUS"
ds     <- get(dsname)

names(ds) %<>% normVarNames()

ds %<>%
  select(-date, -location, -risk_mm) %>%
  drop_na()

names(ds)[which(names(ds) == "rain_tomorrow")] <- "target"

ds %>% filter(target == "Yes") %>% sample_n(10) -> dsy
ds %>% filter(target == "No") %>% sample_n(10) -> dsn

ds <- rbind(dsn, dsy)

predict(model, newdata=ds, type="class") %>%
  as.data.frame() %>%
  cbind(Actual=ds$target) %>%
  set_names(c("Predicted", "Actual")) %>%
  mutate(Error=ifelse(Predicted==Actual, "", "<----")) %T>%
  print() ->
ev
  
# Produce confusion matrix using Rattle?

cat("\n================\nConfusion Matrix\n================\n\n")

per <- errorMatrix(ev$Actual, ev$Predicted)

per/100

# Calculate the overall error percentage.

cat(sprintf("\nOverall error: %d%%\n", 100-sum(diag(per), na.rm=TRUE)))

# Calculate the averaged class error percentage.

cat(sprintf("Average class error: %.1f%%\n", mean(per[,"Error"], na.rm=TRUE)))

# Suggest next step.

cat("\nYou may like to view a summary of the model with:\n",
    "\n  $ ml print rain-tomorrow\n\n")
