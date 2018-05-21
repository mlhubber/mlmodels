#################################################################################
# Title: Movie Recommender with SAR
# Author: Fang Zhou, Data Scientist, Microsoft
# Function: prepare mapping dataset
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

# generate demo data

u <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
dfu <- filter(ms_movie, userId %in% u)
dfu
write.csv(dfu, file=file.path(ms_dir, "/ml-latest-small/user10.csv"), row.names=F)

names(ms_movie) <- c("user", "item",  "rating", "time", "title", "genres")
ms_map <- unique(ms_movie[, c("title", "item")])
head(ms_map)

write.csv(ms_map, file=file.path(ms_dir, "/ml-latest-small/map.csv"), row.names=F)
