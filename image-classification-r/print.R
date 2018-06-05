# print textual representation of the model

# load library

library(keras)

# load model

model <-
load_model_hdf5(filepath = "image-classification-vgg16-model.hdf5", 
                custom_objects = NULL, 
                compile = TRUE)

# print model summary

cat("====================\nModel Summary\n====================\n\n")

summary(model)
