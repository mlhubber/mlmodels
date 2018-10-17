import base64
import json
import os
import timeit as t
from io import BytesIO

import numpy as np
import tensorflow as tf
from PIL import Image, ImageOps
from tensorflow.contrib.slim.nets import resnet_v1

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
            print("\nRecognizing the image '{}'".format(key))
            rgb_image = _base64img_to_numpy(base64_img_string)
            batch_image = np.expand_dims(rgb_image, 0)
            results[key] = scoring_func(batch_image, number_results=_NUMBER_RESULTS)
        
        end = t.default_timer()

        timemsg = 'Computed in {0} ms'.format(round((end-start)*1000, 2))
        print("    {}".format(timemsg))
        print("    Predictions:")
        for l, p in results[key]:
            print("        {0:>5.2f}%: {1}".format(p*100, ' '.join(l.split()[1:])))

        return (results, timemsg)
    return process_and_score

def version():
    return tf.__version__

