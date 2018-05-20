library(rpart)
library(magrittr)

# The file to score.

args <- commandArgs(trailingOnly=TRUE)
fname <- args[1]

load("iris_model.RData")

read.csv(fname) %>%
  predict(m$finalModel, newdata=., type="class") %>%
  as.data.frame() %>%
  set_names("Class") %>%
  print()
