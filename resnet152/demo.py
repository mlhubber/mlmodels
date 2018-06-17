# Import required libraries.

print("Loading the required Python modules for the ResNet152 model.\n")

import numpy as np
import tensorflow as tf
from PIL import Image
from tensorflow.contrib.slim.nets import resnet_v1
import glob

# Create a placeholder for a tensor.

input_tensor = tf.placeholder(tf.float32, shape=(None,224,224,3), name='input_image')

# Load the model.

print("Loading the pre-trained ResNet v1 152 model with 1000 classes.\n")

sess = tf.Session()
arg_scope = resnet_v1.resnet_arg_scope()
with tf.contrib.slim.arg_scope(arg_scope):
    logits, _ = resnet_v1.resnet_v1_152(input_tensor, num_classes=1000, is_training=False)

probabilities = tf.nn.softmax(logits)

print("Loading the ResNet v1 152 checkpoint file.\n")

checkpoint_file = 'resources/resnet_v1_152.ckpt'
saver = tf.train.Saver()
saver.restore(sess, checkpoint_file)

def create_label_lookup():
    with open('resources/synset.txt', 'r') as f:
        label_list = [l.rstrip() for l in f]
    def _label_lookup(*label_locks):
        return [label_list[l] for l in label_locks]
    return _label_lookup

print("Now predict the class for a collection of images.\n")

images = glob.glob("images/*.jpg")
images.sort()

print("image file           : prob : class\n")
for image in images:
    im = Image.open(image).resize((224,224))
    im = np.array(im)
    im = np.expand_dims(im, 0)
    pred, pred_proba = sess.run([logits,probabilities], feed_dict={input_tensor: im})
    label_lookup = create_label_lookup()
    top_results = np.flip(np.sort(pred_proba.squeeze()), 0)[:3]
    labels=label_lookup(*np.flip(np.argsort(pred_proba.squeeze()), 0)[:3])
    for i in range(0, 3):
        fmt = "{0:20} : {1:4.2f} : {2:}"
        print(fmt.format(image, top_results[i], labels[i]))
    print("")

msg = """The individual images and the predictions can be displayed:

 $ ml display resnet152
"""

print(msg)
