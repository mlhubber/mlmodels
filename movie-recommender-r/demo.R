#################################################################################
# Title: Movie Recommender with SAR
# Author: Fang Zhou, Data Scientist, Microsoft
# Function: apply the SAR model to a sample dataset
#################################################################################

# load the package

library(caret)
library(plyr)
library(dplyr)
library(SAR)

# load the model

load("sar_model.RData")

# load the demo data

ms_dir <- "data/ml-latest-small"
dfu <- read.csv(file.path(ms_dir, "user10.csv"), header = TRUE)
names(dfu) <- c("user", "item",  "rating", "time", "title", "genres")
dfu$time <- as.POSIXct(as.numeric(as.character(dfu$time)), origin="1970-01-01", tz="GMT")

# prediction per user (userId)

recu <- user_predict(loc_count, userdata=dfu, n=5)

# evaluation

metrics <- user_pred_metrics(recu, dfu)

# more interpretable output

recu2 <- NULL
recu2$user <- rep(as.numeric(recu$user), each=5)
recu2$item <- as.vector(t(as.matrix(recu[, 2:6])))
recu2 <- as.data.frame(recu2)

ms_map <- read.csv(file.path(ms_dir, "map.csv"), header = TRUE)
mapu <- join(ms_map, recu2, type="right")
recu2$title <- mapu$title

cat("\n\n=====================
    \nUser 1
    \nWatched:\n\n *", paste(as.character(as.character(dfu$title[dfu$user==1])), collapse="\n * "), 
    "\n\nModel Recommends:\n\n *", paste(as.character(as.character(recu2$title[recu2$user==1])), collapse="\n * "), 
    "\n\n=====================
    \nUser 2 
    \nWatched:\n\n *", paste(as.character(as.character(dfu$title[dfu$user==2])), collapse="\n * "), 
    "\n\nModel Recommends:\n\n *", paste(as.character(as.character(recu2$title[recu2$user==2])), collapse="\n * "), 
    "\n\n=====================
    \nUser 3 
    \nWatched:\n\n *", paste(as.character(as.character(dfu$title[dfu$user==3])), collapse="\n * "), 
    "\n\nModel Recommends:\n\n *", paste(as.character(as.character(recu2$title[recu2$user==3])), collapse="\n * "),
    "\n\n=====================
    \nUser 4 
    \nWatched:\n\n *", paste(as.character(as.character(dfu$title[dfu$user==4])), collapse="\n * "), 
    "\n\nModel Recommends:\n\n *", paste(as.character(as.character(recu2$title[recu2$user==4])), collapse="\n * "),
    "\n\n=====================
    \nUser 5 
    \nWatched:\n\n *", paste(as.character(as.character(dfu$title[dfu$user==5])), collapse="\n * "), 
    "\n\nModel Recommends:\n\n *", paste(as.character(as.character(recu2$title[recu2$user==5])), collapse="\n * "),
    "\n\n=====================
    \nUser 6 
    \nWatched:\n\n *", paste(as.character(as.character(dfu$title[dfu$user==6])), collapse="\n * "), 
    "\n\nModel Recommends:\n\n *", paste(as.character(as.character(recu2$title[recu2$user==6])), collapse="\n * "),
    "\n\n=====================
    \nUser 7 
    \nWatched:\n\n *", paste(as.character(as.character(dfu$title[dfu$user==7])), collapse="\n * "), 
    "\n\nModel Recommends:\n\n *", paste(as.character(as.character(recu2$title[recu2$user==7])), collapse="\n * "),
    "\n\n=====================
    \nUser 8 
    \nWatched:\n\n *", paste(as.character(as.character(dfu$title[dfu$user==8])), collapse="\n * "), 
    "\n\nModel Recommends:\n\n *", paste(as.character(as.character(recu2$title[recu2$user==8])), collapse="\n * "),
    "\n\n=====================
    \nUser 9 
    \nWatched:\n\n *", paste(as.character(as.character(dfu$title[dfu$user==9])), collapse="\n * "), 
    "\n\nModel Recommends:\n\n *", paste(as.character(as.character(recu2$title[recu2$user==9])), collapse="\n * "),
    "\n\n=====================
    \nUser 10 
    \nWatched:\n\n *", paste(as.character(as.character(dfu$title[dfu$user==10])), collapse="\n * "), 
    "\n\nModel Recommends:\n\n *", paste(as.character(as.character(recu2$title[recu2$user==10])), collapse="\n * "),
    "\n\n=====================
    \nOverall Model Performance Evaluation",
    "\n\n=====================
    \nPrecision =", mean(metrics$prec), "The precision is the proportion of top 5 recommendations were actually suitable for the user",
    "\nRecall =", mean(metrics$rec), "The recall is the proportion of good recommendations that appear in top 5 recommendations",
    "\n\n=====================\n\n
    ")


