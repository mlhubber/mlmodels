library(caret)
library(rpart)

load("iris_rpart_caret_model.RData")
model <- m$finalModel

print(m)
print(model)

cat("
Press Enter to finish: ")
invisible(readChar("stdin", 1))
