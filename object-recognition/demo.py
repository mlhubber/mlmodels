# Import required libraries.

print("Loading the required Python modules for the ResNet152 model.")

from objreg_utils import (
    to_img,
    img_url_to_json,
    plot_predictions,
    plot_single_prediction,
    get_model_api,
)
import glob
import json
import os

folder = os.path.dirname(os.path.realpath(__file__))
images = glob.glob("images/*.jpg")
images.sort()

print("\nThe ResNet152 model will be used for recognizing the images in\n'{}'".format(folder))

results = []

# Load model

predict_for = get_model_api()

# Predict

for image in images:
    jsonimg = img_url_to_json(image, label=os.path.join(folder, image))
    json_lod = json.loads(jsonimg)
    output = predict_for(json_lod)

    # Plot the result

    plot_single_prediction(image, output)
    results += [output, ]

# Plot the results together

plot_predictions(images, results)
