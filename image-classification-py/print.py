#######################################################
# Print the textual representation of the model
#######################################################

import os
from keras.preprocessing.image import ImageDataGenerator
from keras import applications
from keras.models import load_model, load_weights

# load model
base_dir = "/home/dlvmadmin/.mlhub/image-classification-py"
top_model_path = os.path.join(base_dir, "bottleneck_fc_model.h5")
top_model_weights_path = os.path.join(base_dir, "bottleneck_fc_model_weights.h5")
loaded_model = load_model(top_model_path)
loaded_model.load_weights(top_model_weights_path)

# print model summary
print("\n============\nModel Summary\n===========\n")
loaded_model.summary()