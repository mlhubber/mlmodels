# Load model, predict on a small dataset, present evaluation.

# load library

library(keras)
library(magrittr)
library(dplyr)
library(caret)
library(e1071)

# load model

model <- 
load_model_hdf5(filepath = "image-classification-vgg16-model.hdf5", 
                custom_objects = NULL, 
                compile = TRUE)

# Q: how to load model with training configuration?

load("image-classification-vgg16-history.RData")

# get demo data

base_dir <- "~/.mlhub/image-classification-r/data/cats_and_dogs_small"
test_dir <- file.path(base_dir, "test")
test_datagen <- image_data_generator(rescale = 1/255)

cat("====================\nPredict Image Classes\n====================\n\n")

test_generator <- flow_images_from_directory(
  test_dir,
  test_datagen,
  target_size = c(150, 150),
  batch_size = 20,
  class_mode = "binary"
)

model %>% compile(
  loss = "binary_crossentropy",
  optimizer = optimizer_rmsprop(lr = 2e-5),
  metrics = c("accuracy")
)

pred_score <- model %>% predict_generator(test_generator, steps = 50)
pred_class <- ifelse(pred_score > 0.5, 1, 0)

img_names <- c(list.files(path = file.path(test_dir, "cats")), 
               list.files(path = file.path(test_dir, "dogs")))

img_names %>%
  as.data.frame() %>% 
  cbind(Predicted = pred_class) %>%
  cbind(Actual = test_generator$classes) %>%
  set_names(c("Image", "Predicted", "Actual")) %>%
  mutate(Error = ifelse(Predicted == Actual, "", "<----")) %>%
  head(n = 20) %T>%
  print() ->
ev

cat("====================\nModel Loss and Accuracy\n====================\n\n")

model %>% evaluate_generator(test_generator, steps = 50)

cat("====================\nConfusion Matrix\n====================\n\n")

confusionMatrix(data = pred_class, reference = test_generator$classes, positive = "1")
