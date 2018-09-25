## apply the SAR model to a supplied dataset

# load the package

library(caret)
library(plyr)
library(dplyr)
library(SAR)

# The file to score.

args <- commandArgs(trailingOnly=TRUE)
fname <- args[1]

# load the model

load("sar_model.RData")

# load the score data

data_dir <- "data"
data_subdir <- file.path(data_dir, "ml-latest-small")
dfu <- read.csv(file.path(data_subdir, fname), header = TRUE)
names(dfu) <- c("user", "item",  "rating", "time", "title", "genres")
dfu$time <- as.POSIXct(as.numeric(as.character(dfu$time)), origin="1970-01-01", tz="GMT")

# prediction per user (user)

nrec <- 2
recu <- user_predict(loc_count, userdata=dfu, n=nrec)

# evaluation

metrics <- user_pred_metrics(recu, dfu)

# more interpretable output

recu2 <- NULL
recu2$user <- rep(as.numeric(recu$user), each=nrec)
recu2$item <- as.vector(t(as.matrix(recu[, 2:(nrec+1)])))
recu2 <- as.data.frame(recu2)

map <- read.csv(file.path(data_dir, "/ml-latest-small/map.csv"), header = TRUE)
mapu <- join(map, recu2, type="right")
recu2$title <- mapu$title

nid <- length(unique(recu2[, 1]))
nuser <- 2
cat("\nThe model is applied to", nid, "users to suggest their next movies to watch.")
cat("\nHere we show a random", nuser, "users, listing watched movies and recommendation.\n\n")

for (i in sample(nid, nuser))
{
  cat("========\n")
  cat("User", sprintf("%03d", i))
  cat("\n========\n\n")
  
  wsmpl <- 5
  cat("Watched\n  * ")
  watched <- dfu$title[dfu$user==i] %>% sort()
  if (wsmpl <= length(watched))
    smpl <- sample(length(watched), wsmpl) %>% sort()
  else
    smpl <- 1:length(watched)
  as.character(watched[smpl]) %>% paste(collapse="\n  * ") %>% cat()
  cat("\n  * ...", length(watched)-wsmpl, "more ...")
  
  cat("\n\nRecommend\n  * ")
  recommend <- recu2$title[recu2$user==i]
  as.character(recommend[1:nrec]) %>% paste(collapse="\n  * ") %>% cat()
  cat("\n\n")
}