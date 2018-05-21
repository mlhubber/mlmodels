####################################################
# Title: Movie Recommender with SAR
# Author: Fang Zhou, Data Scientist, Microsoft
# Function: sample script
####################################################

# load package

library(caret)
library(plyr)
library(dplyr)
library(SAR)

# local copy of movielens data from https://grouplens.org/datasets/movielens/

ms_dir <- "C:/Users/dlvmadmin/.aipk/movie-recommender-r/data"
ms_ratings <- read.csv(file.path(ms_dir, "/ml-latest-small/ratings.csv"), header=TRUE)
ms_movies <- read.csv(file.path(ms_dir, "/ml-latest-small/movies.csv"), header=TRUE)

ms_movie <- join(ms_ratings, ms_movies, type="left")
head(ms_movie)

# generate demo data
#u <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
#dfu <- filter(ms_movie, userId %in% u)
#dfu
#write.csv(dfu, file=file.path(ms_dir, "/ml-latest-small/user10.csv"), row.names=F)

names(ms_movie) <- c("user", "item",  "rating", "time", "title", "genres")
ms_movie$time <- as.POSIXct(as.numeric(as.character(ms_movie$time)), origin="1970-01-01", tz="GMT")
head(ms_movie)

# build models with R_SAR package

loc_count <- sar(ms_movie, support_threshold=3, similarity="count")
loc_lift <- sar(ms_movie, support_threshold=3, similarity="lift")
loc_jac <- sar(ms_movie, support_threshold=3, similarity="jaccard")

# display models

loc_count
loc_lift
loc_jac

# prediction per item (movieId)

i <- 31

item_predict(loc_count, i, n=5)
item_predict(loc_lift, i, n=5)
item_predict(loc_jac, i, n=5)

# prediction per user (userId)

u <- 1
dfu <- subset(ms_movie, user == u)
dfu

user_predict(loc_count, userdata=dfu, n=5)
user_predict(loc_lift, userdata=dfu, n=5)
user_predict(loc_jac, userdata=dfu, n=5)
user_predict(loc_jac, userdata=dfu[-1], n=5)

# evaluation
# split data into recdata and testdata by user

intrain <- createDataPartition(y=ms_movie$user, p=0.7, list=FALSE)
traindata <- ms_movie[intrain, ]
testdata <- ms_movie[-intrain, ]

# build models with R_SAR package

loc_count <- sar(traindata, support_threshold=3, similarity="count")
loc_lift <- sar(traindata, support_threshold=3, similarity="lift")
loc_jac <- sar(traindata, support_threshold=3, similarity="jaccard")

# prediction per user (userId)

recdata_count <- user_predict(loc_count, userdata=testdata, n=5)
recdata_lift <- user_predict(loc_lift, userdata=testdata, n=5)
recdata_jac <- user_predict(loc_jac, userdata=testdata, n=5)

# evaluation
user_pred_metrics(recdata_count, testdata)
user_pred_metrics(recdata_lift, testdata)
user_pred_metrics(recdata_jac, testdata)

