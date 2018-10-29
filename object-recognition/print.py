print("Loading the required Python modules for the ResNet152 model.")
import tensorflow as tf
import keras
from objreg_utils import ResNet152

print("\nLoading the ResNet model.")
model = ResNet152(weights='imagenet')

model.summary()
