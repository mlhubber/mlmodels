library(caret)
library(rpart)

load("iris_model.RData")

print(m)
print(m$finalModel)

# Informative next step suggestion.

cat("\nYou may next like to display a visual representation of the model:\n",
    "\n  $ aipk display iris-r\n\n")

