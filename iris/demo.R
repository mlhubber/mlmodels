########################################################################
# Introduce the concept of decision tree model through MLHub
#
# Copyright 2018 Graham.Williams@togaware.com

cat("==========================
Predict Iris Plant Species
==========================

Below we show the predictions of species using the pre-built model.

")

# Load required packages.

suppressMessages(
{
library(rpart)        # Model: decision tree rpart().
library(magrittr)     # Data pipelines: %>% %<>% %T>% equals().
library(dplyr)        # Wrangling: tbl_df(), group_by(), print().
library(rattle)       # Support: normVarNames(), riskchart(), errorMatrix().
})

#-----------------------------------------------------------------------
# Load the pre-built model.
#-----------------------------------------------------------------------

load("iris_rpart_caret_model.RData")

model <- m$finalModel

set.seed(1427)

# Load a sample dataset, predict, and display a sample of predictions.

read.csv("data.csv") %T>%
  assign('ds', ., envir=.GlobalEnv) %>%
  predict(model, newdata=., type="class") %>%
  as.data.frame() %>%
  cbind(Actual=ds$Species) %>%
  set_names(c("Predicted", "Actual")) %>%
  select(Actual, Predicted) %>%
  mutate(Error=ifelse(Predicted==Actual, "", "<----")) %T>%
  {sample_n(., 15) %>% print()} ->
ev

#-----------------------------------------------------------------------
# Produce confusion matrix using Rattle.
#-----------------------------------------------------------------------

cat("\nPress Enter to continue on to the Confusion Matrix: ")
invisible(readChar("stdin", 1))

cat("
================
Confusion Matrix
================

A confusion matrix summarises the performance of the model on this
dataset. The figures here are percentages, aggregating the actual versus
predicted outcomes. The Error column represents the class error.

")

per <- errorMatrix(ev$Actual, ev$Predicted) %T>% print()

# Calculate the overall error percentage.

cat(sprintf("\nOverall error: %.0f%%\n", 100-sum(diag(per), na.rm=TRUE)))

# Calculate the averaged class error percentage.

cat(sprintf("Average class error: %.0f%%\n", mean(per[,"Error"], na.rm=TRUE)))

# No risk chart as we have a multiclass outcome.

cat("\nPress Enter to finish the demonstration: ")
invisible(readChar("stdin", 1))
