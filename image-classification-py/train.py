###############################################
# Build an image classification model 
# with pre-trained network using Keras
###############################################

import os
import numpy as np
from keras.preprocessing.image import ImageDataGenerator
from keras.models import Sequential
from keras.layers import Dropout, Flatten, Dense
from keras import applications

# data directory
base_dir = "/home/dlvmadmin/.mlhub/image-classification-py"
train_data_dir = os.path.join(base_dir, "data/cats_and_dogs_small/train")
validation_data_dir = os.path.join(base_dir, "data/cats_and_dogs_small/validation")

# top model weights
bottleneck_features_train_path = os.path.join(base_dir, "bottleneck_features_train.npy")
bottleneck_features_validation_path = os.path.join(base_dir, "bottleneck_features_validation.npy")
top_model_path = os.path.join(base_dir, "bottleneck_fc_model.h5")
top_model_weights_path = os.path.join(base_dir, "bottleneck_fc_model_weights.h5")

# parameter values
img_width, img_height = 150, 150
nb_train_samples = 2000
nb_validation_samples = 1000
epochs = 30
batch_size = 20

# Define functions
def save_bottleneck_features():
    '''
    Create bottleneck features.
    '''
    # initiate the VGG16 network
    model = applications.VGG16(
        include_top=False, 
        weights='imagenet'
    )

    datagen = ImageDataGenerator(rescale=1. / 255)

    train_generator = datagen.flow_from_directory(
        train_data_dir,
        target_size=(img_width, img_height),
        batch_size=batch_size,
        class_mode=None,
        shuffle=False
    )

    bottleneck_features_train = model.predict_generator(
        train_generator, 
        steps=nb_train_samples // batch_size
    )

    np.save(open(bottleneck_features_train_path, 'wb'),
            bottleneck_features_train)

    validation_generator = datagen.flow_from_directory(
        validation_data_dir,
        target_size=(img_width, img_height),
        batch_size=batch_size,
        class_mode=None,
        shuffle=False
    )

    bottleneck_features_validation = model.predict_generator(
        validation_generator, 
        steps=nb_validation_samples // batch_size
    )

    np.save(open(bottleneck_features_validation_path, 'wb'),
            bottleneck_features_validation)


def train_top_model():
    '''
    Train top model.
    '''
    train_data = np.load(open(bottleneck_features_train_path, 'rb'))
    train_labels = np.array(
        [0] * int(nb_train_samples / 2) + [1] * int(nb_train_samples / 2))

    validation_data = np.load(open(bottleneck_features_validation_path, 'rb'))
    validation_labels = np.array(
        [0] * int(nb_validation_samples / 2) + [1] * int(nb_validation_samples / 2))

    model = Sequential()
    model.add(Flatten(input_shape=train_data.shape[1:]))
    model.add(Dense(256, activation='relu'))
    model.add(Dropout(0.5))
    model.add(Dense(1, activation='sigmoid'))

    model.compile(
        optimizer='rmsprop',
        loss='binary_crossentropy', 
        metrics=['accuracy']
    )

    model.fit(
        train_data, 
        train_labels,
        epochs=epochs,
        batch_size=batch_size,
        validation_data=(validation_data, 
                         validation_labels)
    )
    
    model.save(filepath=top_model_path, overwrite=True)
    model.save_weights(filepath=top_model_weights_path, overwrite=True)

# Create bottleneck features
save_bottleneck_features()

# Train top model
train_top_model()
