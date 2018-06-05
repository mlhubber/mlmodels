# Load model, predict on a small dataset.

# load library

library(keras)
library(magrittr)
library(dplyr)

# load model

model <-
load_model_hdf5(filepath = "image-classification-vgg16-model.hdf5", 
                custom_objects = NULL, 
                compile = TRUE)

# file to score

args <- commandArgs(trailingOnly = TRUE)
fname <- args[1]

# get score data

base_dir <- "~/.mlhub/image-classification-r/data/cats_and_dogs_small"
test_dir <- file.path(base_dir, fname)
test_datagen <- image_data_generator(rescale = 1/255)

cat("====================\nPredict Image Classes\n====================\n\n")

test_generator <- flow_images_from_directory(
  test_dir,
  test_datagen,
  target_size = c(150, 150),
  batch_size = 20,
  class_mode = "binary"
)

pred_score <- model %>% predict_generator(test_generator, steps = 50)
pred_class <- ifelse(pred_score > 0.5, 1, 0)

img_names <- c(list.files(path = file.path(test_dir, "cats")), 
               list.files(path = file.path(test_dir, "dogs")))

img_names %>%
  as.data.frame() %>% 
  cbind(Predicted_Class = pred_class) %>%
  cbind(Predicted_Score = pred_score) %>%
  set_names(c("Image", "Predicted_Class", "Predicted_Score")) %>%
  head(n = 20) %T>%
  print() ->
  ev
