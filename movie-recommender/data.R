## prepare datasets used in this model archieve

# load package

library(caret)
library(plyr)
library(dplyr)
library(SAR)

# local copy of movielens data from https://grouplens.org/datasets/movielens/

data_dir <- "data"
ratings <- read.csv(file.path(data_dir, "/ml-latest-small/ratings.csv"), header=TRUE)
movies <- read.csv(file.path(data_dir, "/ml-latest-small/movies.csv"), header=TRUE)

# join ratings and movies

movielens <- join(ratings, movies, type="left")
head(movielens)
write.csv(movielens, file=file.path(data_dir, "/ml-latest-small/movielens.csv"), row.names=F)

# split data into train and test

# generate demo data

u <- seq(1:10)
dfu <- filter(movielens, userId %in% u)
head(dfu)
write.csv(dfu, file=file.path(data_dir, "/ml-latest-small/user10.csv"), row.names=F)

# generate mapping data for title and item

names(movielens) <- c("user", "item",  "rating", "time", "title", "genres")
map <- unique(movielens[, c("title", "item")])
head(map)

write.csv(map, file=file.path(data_dir, "/ml-latest-small/map.csv"), row.names=F)
