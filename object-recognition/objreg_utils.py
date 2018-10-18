import base64
import json
import urllib
import os
import timeit as t
from io import BytesIO

import numpy as np
import tensorflow as tf
from tensorflow.contrib.slim.nets import resnet_v1

import matplotlib.gridspec as gridspec
import matplotlib.pyplot as plt
import toolz
from PIL import Image, ImageOps
import random
import re
import glob

# ----------------------------------------------------------------------
# Model functions
# ----------------------------------------------------------------------

_MODEL_FILE = os.getenv('MODEL_FILE', "resources/resnet_v1_152.ckpt")
_LABEL_FILE = os.getenv('LABEL_FILE', "resources/synset.txt")
_NUMBER_RESULTS = 3


def _create_label_lookup(label_path):
    with open(label_path, 'r') as f:
        label_list = [l.rstrip() for l in f]
        
    def _label_lookup(*label_locks):
        return [label_list[l] for l in label_locks]
    
    return _label_lookup


def _load_tf_model(checkpoint_file):
    # Placeholder
    input_tensor = tf.placeholder(tf.float32, shape=(None,224,224,3), name='input_image')
    
    # Load the model
    sess = tf.Session()
    arg_scope = resnet_v1.resnet_arg_scope()
    with tf.contrib.slim.arg_scope(arg_scope):
        logits, _ = resnet_v1.resnet_v1_152(input_tensor, num_classes=1000, is_training=False, reuse=tf.AUTO_REUSE)
    probabilities = tf.nn.softmax(logits)
    
    saver = tf.train.Saver()
    saver.restore(sess, checkpoint_file)
    
    def predict_for(image):
        pred, pred_proba = sess.run([logits,probabilities], feed_dict={input_tensor: image})
        return pred_proba
    
    return predict_for


def _base64img_to_numpy(base64_img_string):
    if base64_img_string.startswith('b\''):
        base64_img_string = base64_img_string[2:-1]
    base64Img = base64_img_string.encode('utf-8')

    # Preprocess the input data 
    startPreprocess = t.default_timer()
    decoded_img = base64.b64decode(base64Img)
    img_buffer = BytesIO(decoded_img)

    # Load image with PIL (RGB)
    pil_img = Image.open(img_buffer).convert('RGB')
    pil_img = ImageOps.fit(pil_img, (224, 224), Image.ANTIALIAS)
    return np.array(pil_img, dtype=np.float32)


def create_scoring_func(model_path=_MODEL_FILE, label_path=_LABEL_FILE):

    print("\nLoading the pre-trained ResNet v1 152 model with 1000 classes.")
    start = t.default_timer()
    labels_for = _create_label_lookup(label_path)
    predict_for = _load_tf_model(model_path)
    end = t.default_timer()

    loadTimeMsg = "    Model loading time: {0} ms".format(round((end-start)*1000, 2))
    print(loadTimeMsg)

    def call_model(image_array, number_results=_NUMBER_RESULTS):
        pred_proba = predict_for(image_array).squeeze()
        selected_results = np.flip(np.argsort(pred_proba), 0)[:number_results]
        labels = labels_for(*selected_results)
        return list(zip(labels, pred_proba[selected_results].astype(np.float64)))
    return call_model


def get_model_api():
    scoring_func = create_scoring_func()
    
    def process_and_score(images_dict, number_results=_NUMBER_RESULTS):
        start = t.default_timer()

        results = {}
        for key, base64_img_string in images_dict.items():
            print("\nRecognizing the image\n'{}'".format(key))
            rgb_image = _base64img_to_numpy(base64_img_string)
            batch_image = np.expand_dims(rgb_image, 0)
            results[key] = scoring_func(batch_image, number_results=_NUMBER_RESULTS)
        
        end = t.default_timer()

        timemsg = 'Computed in {0} ms'.format(round((end-start)*1000, 2))
        print("    {}".format(timemsg))
        print("    Predictions:")
        for l, p in results[key]:
            print("      {0:>5.2f}%: {1}".format(p*100, ' '.join(l.split()[1:])))

        return (results, timemsg)
    return process_and_score

# ----------------------------------------------------------------------
# I/O and plot functions
# ----------------------------------------------------------------------

def validateURL(url):
    """Check if url is a valid URL."""

    urlregex = re.compile(
        r'^(?:http|ftp)s?://' # http:// or https://
        r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' #domain...
        r'localhost|' #localhost...
        r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' # ...or ip
        r'(?::\d+)?' # optional port
        r'(?:/?|[/?]\S+)$', re.IGNORECASE)

    if re.match(urlregex, url) is not None:
        return True
    else:
        return False

def read_image_from(url):
    return toolz.pipe(
        url,
        urllib.request.urlopen if validateURL(url) else lambda x: open(x, 'rb'),
        lambda x: x.read(),
        BytesIO)


def to_rgb(img_bytes):
    return Image.open(img_bytes).convert('RGB')


@toolz.curry
def resize(img_file, new_size=(100, 100)):
    return ImageOps.fit(img_file, new_size, Image.ANTIALIAS)


def to_base64(img):
    imgio = BytesIO()
    img.save(imgio, 'PNG')
    imgio.seek(0)
    dataimg = base64.b64encode(imgio.read())
    return dataimg.decode('utf-8')


def to_img(img_url):
    return toolz.pipe(img_url,
                      read_image_from,
                      to_rgb,
                      resize(new_size=(224,224)))


def img_url_to_json(url, label='image'):
    img_data = toolz.pipe(url,
                          to_img,
                          to_base64)
    return json.dumps({label:'\"{0}\"'.format(img_data)})


def  _plot_image(ax, img):
    ax.imshow(to_img(img))
    ax.tick_params(axis='both',       
                   which='both',      
                   bottom='off',      
                   top='off',         
                   left='off',
                   right='off',
                   labelleft='off',
                   labelbottom='off') 
    return ax


def _plot_prediction_bar(ax, r):
    res = list(r[0].values())[0]
    perf = list(c[1] for c in res)
    ax.barh(range(3, 0, -1), perf, align='center', color='#55DD55')
    ax.tick_params(axis='both',       
                   which='both',      
                   bottom='off',      
                   top='off',         
                   left='off',
                   right='off',
                   labelbottom='off') 
    tick_labels = reversed(list(' '.join(c[0].split()[1:]).split(',')[0] for c in res))
    ax.yaxis.set_ticks([1,2,3])
    ax.yaxis.set_ticklabels(tick_labels, position=(0.5,0), minor=False, horizontalalignment='center')


def plot_predictions(images, classification_results):
    if len(images)!=6:
        raise Exception('This method is only designed for 6 images')
    gs = gridspec.GridSpec(2, 3)
    fig = plt.figure(figsize=(12, 9))
    gs.update(hspace=0.1, wspace=0.001)
    
    for gg, r, img in zip(gs, classification_results, images):
        gg2 = gridspec.GridSpecFromSubplotSpec(4, 10, subplot_spec=gg)
        ax = fig.add_subplot(gg2[0:3, :])
        _plot_image(ax, img)
        ax = fig.add_subplot(gg2[3, 1:9])
        _plot_prediction_bar(ax, r)

    plt.show()


def plot_single_prediction(img, result):
    gs = gridspec.GridSpec(4, 10)
    gs.update(hspace=0.1, wspace=0.001)
    fig = plt.figure(figsize=(4, 4.5))
    ax = fig.add_subplot(gs[0:3, :])
    _plot_image(ax, img)
    ax = fig.add_subplot(gs[3, :])
    _plot_prediction_bar(ax, result)
    plt.show()


def write_json_to_file(json_dict, filename, mode='w'):
    with open(filename, mode) as outfile:
        json.dump(json_dict, outfile, indent=4, sort_keys=True)
        outfile.write('\n\n')
        
def gen_variations_of_one_image(IMAGEURL, num, label='image'):
    out_images = []
    img = to_img(IMAGEURL).convert('RGB')
    # Flip the colours for one-pixel
    # "Different Image"
    for i in range(num):
        diff_img = img.copy()
        rndm_pixel_x_y = (random.randint(0, diff_img.size[0]-1), 
                          random.randint(0, diff_img.size[1]-1))
        current_color = diff_img.getpixel(rndm_pixel_x_y)
        diff_img.putpixel(rndm_pixel_x_y, current_color[::-1])
        b64img = to_base64(diff_img)
        out_images.append(json.dumps({label:'\"{0}\"'.format(b64img)}))
    return out_images

# ----------------------------------------------------------------------
# Input path completion
# ----------------------------------------------------------------------

def tab_complete_path(text, state):

    if '~' in text:
        text = os.path.expanduser('~')

    if os.path.isdir(text):
        text += '/'

    return [x for x in glob.glob(text+'*')][state]
