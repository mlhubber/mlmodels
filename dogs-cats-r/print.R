# print textual representation of the model

# load library

library(keras)

# load model

model <-
  load_model_hdf5(filepath = "dogs-cats-vgg16-model.hdf5", 
                  custom_objects = NULL, 
                  compile = TRUE)

model.weights <-
  load_model_weights_hdf5(model,
                          filepath = "dogs-cats-vgg16-model-weights.hdf5")

# print model summary

cat("====================\nModel Summary\n====================\n\n")

summary(model)
