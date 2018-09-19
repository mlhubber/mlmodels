# Load model, predict on a small dataset, present evaluation.

# load library

library(keras)
library(magrittr)
library(dplyr)
library(caret)
library(e1071)

# load model

model <- load_model_hdf5(filepath       = "dogs-cats-vgg16-model.hdf5", 
                         custom_objects = NULL, 
                         compile        = TRUE)

model.weights <-load_model_weights_hdf5(object   = model,
                                        filepath = "dogs-cats-vgg16-model-weights.hdf5")

# Q: how to load model with training configuration?

load("dogs-cats-vgg16-history.RData")

# get demo data

base_dir <- "data/cats_and_dogs_small"
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

pred_score <- model %>% predict_generator(test_generator, steps = 5)
pred_class <- ifelse(pred_score > 0.5, "dogs", "cats")

actual_class <- ifelse(test_generator$classes == 1, "dogs", "cats")
  
img_names <- c(list.files(path = file.path(test_dir, "cats")), 
               list.files(path = file.path(test_dir, "dogs")))

img_names %>%
  as.data.frame() %>% 
  cbind(Predicted = pred_class) %>%
  cbind(Actual = actual_class) %>%
  set_names(c("Image", "Predicted", "Actual")) %>%
  mutate(Error = ifelse(Predicted == Actual, "", "<----")) %>%
  head(n = 20) %T>%
  print() ->
ev

cat("====================\nModel Loss and Accuracy\n====================\n\n")

model %>% evaluate_generator(test_generator, steps = 5)

cat("====================\nConfusion Matrix\n====================\n\n")

confusionMatrix(data = pred_class, 
                reference = actual_class, 
                positive = "dogs")
