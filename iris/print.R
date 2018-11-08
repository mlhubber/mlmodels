library(caret)
library(rpart)

load("iris_rpart_caret_model.RData")

model <- m$finalModel

print(m)
print(model)

cat("\nPress Enter to continue: ")
invisible(readChar("stdin", 1))
