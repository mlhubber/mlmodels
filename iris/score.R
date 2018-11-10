library(rpart)
library(magrittr)

# The file to score.

args <- commandArgs(trailingOnly=TRUE)
fname <- args[1]

load("iris_model.RData")
model <- m$finalModel

read.csv(fname) %>%
  predict(model, newdata=., type="class") %>%
  as.data.frame() %>%
  set_names("Class") %>%
  print()
