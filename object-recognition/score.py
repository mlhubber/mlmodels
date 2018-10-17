# Import required libraries.

import glob
from testing_utilities import to_img, img_url_to_json, plot_predictions, plot_single_prediction
from driver import get_model_api
import json
import os
import sys

# Load model

predict_for = get_model_api()

def _score_for_one_img(img, label='image'):
    """Score for a single image in url.

    Args:
        url (str): a url to an image, or a path to an image.
    """

    jsonimg = img_url_to_json(img, label=label)
    json_lod= json.loads(jsonimg)
    output = predict_for(json_lod)
    plot_single_prediction(img, output)
    return output


def _score_for(url):
    """Score for the images in url.

    Args:
        url (str): a url to an image, or a path to an image, or a dir for images.
    """

    url = os.path.expanduser(url)
    if os.path.isdir(url):
        for img in os.listdir(url):
            img_file = os.path.join(url, '', img)
            _score_for_one_img(img_file, label=img_file)
    else:
        _score_for_one_img(url, label=url)


if len(sys.argv) < 2:
    url = None
    print('\nGive me a path or URL of the images to recognize:', end='\n> ')
    url = input()
    while url != '':
        _score_for(url)
        print('\nGive me another path or URL of the images to recognize:', end='\n> ')
        url = input()
        
else:
    for url in sys.argv[1:]:
        _score_for(url)
