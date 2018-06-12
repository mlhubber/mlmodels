#######################################################
# Load the pre-built model for prediction and evaluation
#######################################################

import os
import numpy as np
import pandas as pd
from keras.preprocessing.image import ImageDataGenerator
from keras import applications
from keras.models import *
from sklearn.metrics import confusion_matrix

# load model
base_dir = "/home/dlvmadmin/.mlhub/image-classification-py"
top_model_path = os.path.join(base_dir, "bottleneck_fc_model.h5")
top_model_weights_path = os.path.join(base_dir, "bottleneck_fc_model_weights.h5")
loaded_model = load_model(top_model_path)
loaded_model.load_weights(top_model_weights_path)

# data directory
test_data_dir = os.path.join(base_dir, "data/cats_and_dogs_small/test")

# parameter values
img_width, img_height = 150, 150
nb_test_samples = 1000
epochs = 30
batch_size = 20

# Define functions
def demo():
    '''
    Apply pre-built model on sample images.
    '''
    # initiate the VGG16 network
    model = applications.VGG16(
        include_top=False, 
        weights='imagenet'
    )

    datagen = ImageDataGenerator(rescale=1. / 255)

    test_generator = datagen.flow_from_directory(
        test_data_dir,
        target_size=(img_width, img_height),
        batch_size=batch_size,
        class_mode=None,
        shuffle=False
    )

    bottleneck_features_test = model.predict_generator(
        test_generator, 
        steps=nb_test_samples // batch_size
    )
    
    test_data = bottleneck_features_test
    test_labels = np.array(
        [0] * int(nb_test_samples / 2) + [1] * int(nb_test_samples / 2))

    loaded_model.compile(
        optimizer='rmsprop',
        loss='binary_crossentropy', 
        metrics=['accuracy']
    )
    
    pred_score = loaded_model.predict(
        test_data
    )
    
    pred_class = pred_score > 0.5
    pred_class = [int(x) for x in pred_class]  
    true_class = [x for x in test_generator.classes]

    cats_names = [f for f in os.listdir(test_data_dir + "/cats") if os.path.isfile(os.path.join(test_data_dir + "/cats", f))]
    dogs_names = [f for f in os.listdir(test_data_dir + "/dogs") if os.path.isfile(os.path.join(test_data_dir + "/dogs", f))]
    img_names = cats_names + dogs_names

    print("\n==========\nPredict image classes\n==========\n")
    d = {'Image':img_names, 'Predicted':pred_class, 'Actual':true_class}
    columns = ["Image", "Predicted", "Actual"]
    df = pd.DataFrame(d, columns=columns)
    print(df.head(n=20))
    
    print("\n========\nAccuracy\n========\n")
    eval_score = loaded_model.evaluate(
        test_data, 
        test_labels,
        steps=nb_test_samples // batch_size)
    print("%s: %.2f%%" % (loaded_model.metrics_names[1], eval_score[1]*100))
    
    print("\n=========\nConfusion Matrix\n==========\n")
    cm = confusion_matrix(true_class, pred_class)
    print(cm)


# demo
demo()



