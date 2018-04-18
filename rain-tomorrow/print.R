# Load model and display some useful informatoin about the model.

library(rpart)

load("rain-tomorrow-dt.RData")

# The following code based on rpart::printcp()
# Copyright (c) Brian Ripley

frame <- model$frame
leaves <- frame$var == "<leaf>"
used <- unique(frame$var[!leaves])

cat("\n============================================\n",
    "Variables actually used in the decision tree",
    "\n============================================\n\n",
    sep="")
cat("  ", paste(sort(as.character(used)), collapse=", "), ".\n", sep="")

# The following code based on rpart:::summary.rpart()
# Copyright (c) Brian Ripley

varimp <- model$variable.importance
varimp <- round(100 * varimp/sum(varimp))

cat("\n==================\n",
    "Variable imprtance",
    "\n==================\n\n",
    sep="")
print(varimp[varimp>0])

cat("\n========================\n",
    "The actual decision tree",
    "\n========================\n\n",
    sep="")
print(model)

# Suggest next step.

cat("\nYou may next like to display a visual representation of the model:\n",
    "\n  $ ml display rain-tomorrow-dt\n\n")

