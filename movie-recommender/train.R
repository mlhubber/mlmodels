## build a SAR model on movielens dataset and save it for later usage

# load package

library(caret)
library(plyr)
library(dplyr)
library(SAR)

# local copy of movielens data from https://grouplens.org/datasets/movielens/
# load data

data_dir <- "~/.mlhub/movie-recommender-r/data"
movielens <- read.csv(file.path(data_dir, "/ml-latest-small/movielens.csv"), header=TRUE)
head(movielens)

names(movielens) <- c("user", "item",  "rating", "time", "title", "genres")
movielens$time <- as.POSIXct(as.numeric(as.character(movielens$time)), origin="1970-01-01", tz="GMT")
head(movielens)

# split data into train and test

intrain <- createDataPartition(y=movielens$user, p=0.8, list=FALSE)
train <- movielens[intrain, ]
test <- movielens[-intrain, ]

# build models with SAR package

loc_count <- sar(train, support_threshold=3, similarity="count")

# display model

loc_count

# prediction per user (user)

nrec <- 2
rect <- user_predict(loc_count, userdata=test, n=nrec)
head(rect)

# evaluation

metrics <- user_pred_metrics(rect, test)
metrics

# identify the location of this script file and use that to know from
# where to load the actual model.

argv <- commandArgs(trailingOnly=FALSE)
base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
if (!length(base_dir)) base_dir <- "."

# save models

save(loc_count, file=file.path(base_dir, "sar_model.RData"))

