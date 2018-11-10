# A sample model build using the traditional iris dataset. We
# illustrate the model build and then save the model to file so that
# we can later load the model and use it to score new datasets.

suppressMessages(
{
library(rpart)
library(caret)
})

# write.csv(iris, file="iris.csv", row.names=FALSE)

ds <- read.csv("iris.csv")

m <- train(Species ~., method="rpart", data=ds)

# Identify the location of this script file and use that to know from
# where to load the actual model.

argv <- commandArgs(trailingOnly=FALSE)
base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
if (!length(base_dir)) base_dir <- "."


# FIXME Should save backup model first...

save(m, file=file.path(base_dir, "iris_rpart_caret_model.RData"))
