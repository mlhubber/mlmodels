# load packages

library(httr)
set_config(config(ssl_verifypeer=0L))

#library(tfruns)
#library(reticulate)
#use_virtualenv("r-tensorflow", required = TRUE)

library(keras)

# data directory

base_dir <- "~/.mlhub/dogs-cats-r-r/data/cats_and_dogs_small"
train_dir <- file.path(base_dir, "train")
validation_dir <- file.path(base_dir, "validation")

# instantiate the VGG16 model

conv_base <- application_vgg16(
  weights = "imagenet",
  include_top = FALSE,
  input_shape = as.integer(c(150, 150, 3))
)

summary(conv_base)

# create keras sequential model by adding base model and layers

model <- keras_model_sequential() %>% 
  conv_base %>% 
  layer_flatten() %>% 
  layer_dense(units = 256, activation = "relu") %>% 
  layer_dense(units = 1, activation = "sigmoid")

summary(model)

length(model$trainable_weights)

freeze_weights(conv_base)
length(model$trainable_weights)

# data augmentation on training data

train_datagen = image_data_generator(
  rescale = 1/255,
  rotation_range = 40,
  width_shift_range = 0.2,
  height_shift_range = 0.2,
  shear_range = 0.2,
  zoom_range = 0.2,
  horizontal_flip = TRUE,
  fill_mode = "nearest"
)

# note that the validation data shouldn't be augmented

test_datagen <- image_data_generator(rescale = 1/255)  

# train model using the image data generator

train_generator <- flow_images_from_directory(
  train_dir,                  # Target directory  
  train_datagen,              # Data generator
  target_size = c(150, 150),  # Resizes all images to 150 × 150
  batch_size = 20,
  class_mode = "binary"       # binary_crossentropy loss for binary labels
)

validation_generator <- flow_images_from_directory(
  validation_dir,
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

history <- model %>% fit_generator(
  train_generator,
  steps_per_epoch = 100,
  epochs = 30,
  validation_data = validation_generator,
  validation_steps = 50
)

# plot training history

plot(history)

cat("====================\nModel Saved as HDF5\n====================\n\n")

save_model_hdf5(model, 
                filepath = "dogs-cats-r-vgg16-model.hdf5", 
                overwrite = TRUE,
                include_optimizer = FALSE)

# Q: how to save model with training configuration?

save_model_weights_hdf5(model,
                        filepath = "dogs-cats-r-vgg16-model-weights.hdf5",
                        overwrite=TRUE)

cat("====================\nHistory Saved as RData and PNG\n====================\n\n")

save(history, file="dogs-cats-r-vgg16-history.RData")

png(filename = "history.png")
plot(history)
dev.off()
