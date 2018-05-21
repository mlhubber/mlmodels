#################################################################################
# Title: Movie Recommender with SAR
# Author: Fang Zhou, Data Scientist, Microsoft
# Function: build a SAR model on movielens dataset and save it for later usage
#################################################################################

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

names(ms_movie) <- c("user", "item",  "rating", "time", "title", "genres")
ms_movie$time <- as.POSIXct(as.numeric(as.character(ms_movie$time)), origin="1970-01-01", tz="GMT")
head(ms_movie)

# build models with R_SAR package

loc_count <- sar(ms_movie, support_threshold=3, similarity="count")

# display model

loc_count

# Identify the location of this script file and use that to know from
# where to load the actual model.

argv <- commandArgs(trailingOnly=FALSE)
base_dir <- dirname(substring(argv[grep("--file=", argv)], 8))
if (!length(base_dir)) base_dir <- "."

# save models

save(loc_count, file=file.path(base_dir, "sar_model.RData"))

