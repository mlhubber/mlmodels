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


# ----------------------------------------------------------------------
# ResNet152 model for Keras
# ----------------------------------------------------------------------

"""ResNet152 model for Keras.

# Reference:

- [Deep Residual Learning for Image Recognition](https://arxiv.org/abs/1512.03385)

Adaptation of code from flyyufelix, mvoelk, BigMoyan, fchollet at https://github.com/adamcasson/resnet152

"""

import numpy as np
import warnings

from keras.layers import Input
from keras.layers import Dense
from keras.layers import Activation
from keras.layers import Flatten
from keras.layers import Conv2D
from keras.layers import MaxPooling2D
from keras.layers import GlobalMaxPooling2D
from keras.layers import ZeroPadding2D
from keras.layers import AveragePooling2D
from keras.layers import GlobalAveragePooling2D
from keras.layers import BatchNormalization
from keras.layers import add
from keras.models import Model
import keras.backend as K
from keras.engine.topology import get_source_inputs
from keras.utils import layer_utils
from keras import initializers
from keras.engine import Layer, InputSpec
from keras.preprocessing import image
from keras.utils.data_utils import get_file
from keras.applications.imagenet_utils import decode_predictions
from keras.applications.imagenet_utils import preprocess_input
import sys
from packaging import version
if version.parse(sys.modules['keras'].__version__) > version.parse('2.2.0'):
    from keras_applications.imagenet_utils import _obtain_input_shape
else:
    from keras.applications.imagenet_utils import _obtain_input_shape

sys.setrecursionlimit(3000)

WEIGHTS_PATH = 'https://github.com/adamcasson/resnet152/releases/download/v0.1/resnet152_weights_tf.h5'
WEIGHTS_PATH_NO_TOP = 'https://github.com/adamcasson/resnet152/releases/download/v0.1/resnet152_weights_tf_notop.h5'

class Scale(Layer):
    """Custom Layer for ResNet used for BatchNormalization.
    
    Learns a set of weights and biases used for scaling the input data.
    the output consists simply in an element-wise multiplication of the input
    and a sum of a set of constants:

        out = in * gamma + beta,

    where 'gamma' and 'beta' are the weights and biases larned.

    Keyword arguments:
    axis -- integer, axis along which to normalize in mode 0. For instance,
        if your input tensor has shape (samples, channels, rows, cols),
        set axis to 1 to normalize per feature map (channels axis).
    momentum -- momentum in the computation of the exponential average 
        of the mean and standard deviation of the data, for 
        feature-wise normalization.
    weights -- Initialization weights.
        List of 2 Numpy arrays, with shapes:
        `[(input_shape,), (input_shape,)]`
    beta_init -- name of initialization function for shift parameter 
        (see [initializers](../initializers.md)), or alternatively,
        Theano/TensorFlow function to use for weights initialization.
        This parameter is only relevant if you don't pass a `weights` argument.
    gamma_init -- name of initialization function for scale parameter (see
        [initializers](../initializers.md)), or alternatively,
        Theano/TensorFlow function to use for weights initialization.
        This parameter is only relevant if you don't pass a `weights` argument.
        
    """
    def __init__(self, weights=None, axis=-1, momentum = 0.9, beta_init='zero', gamma_init='one', **kwargs):
        self.momentum = momentum
        self.axis = axis
        self.beta_init = initializers.get(beta_init)
        self.gamma_init = initializers.get(gamma_init)
        self.initial_weights = weights
        super(Scale, self).__init__(**kwargs)

    def build(self, input_shape):
        self.input_spec = [InputSpec(shape=input_shape)]
        shape = (int(input_shape[self.axis]),)

        self.gamma = K.variable(self.gamma_init(shape), name='%s_gamma'%self.name)
        self.beta = K.variable(self.beta_init(shape), name='%s_beta'%self.name)
        self.trainable_weights = [self.gamma, self.beta]

        if self.initial_weights is not None:
            self.set_weights(self.initial_weights)
            del self.initial_weights

    def call(self, x, mask=None):
        input_shape = self.input_spec[0].shape
        broadcast_shape = [1] * len(input_shape)
        broadcast_shape[self.axis] = input_shape[self.axis]

        out = K.reshape(self.gamma, broadcast_shape) * x + K.reshape(self.beta, broadcast_shape)
        return out

    def get_config(self):
        config = {"momentum": self.momentum, "axis": self.axis}
        base_config = super(Scale, self).get_config()
        return dict(list(base_config.items()) + list(config.items()))

def identity_block(input_tensor, kernel_size, filters, stage, block):
    """The identity_block is the block that has no conv layer at shortcut
    
    Keyword arguments
    input_tensor -- input tensor
    kernel_size -- defualt 3, the kernel size of middle conv layer at main path
    filters -- list of integers, the nb_filters of 3 conv layer at main path
    stage -- integer, current stage label, used for generating layer names
    block -- 'a','b'..., current block label, used for generating layer names
    
    """
    eps = 1.1e-5
    
    if K.image_dim_ordering() == 'tf':
        bn_axis = 3
    else:
        bn_axis = 1
    
    nb_filter1, nb_filter2, nb_filter3 = filters
    conv_name_base = 'res' + str(stage) + block + '_branch'
    bn_name_base = 'bn' + str(stage) + block + '_branch'
    scale_name_base = 'scale' + str(stage) + block + '_branch'

    x = Conv2D(nb_filter1, (1, 1), name=conv_name_base + '2a', use_bias=False)(input_tensor)
    x = BatchNormalization(epsilon=eps, axis=bn_axis, name=bn_name_base + '2a')(x)
    x = Scale(axis=bn_axis, name=scale_name_base + '2a')(x)
    x = Activation('relu', name=conv_name_base + '2a_relu')(x)

    x = ZeroPadding2D((1, 1), name=conv_name_base + '2b_zeropadding')(x)
    x = Conv2D(nb_filter2, (kernel_size, kernel_size), name=conv_name_base + '2b', use_bias=False)(x)
    x = BatchNormalization(epsilon=eps, axis=bn_axis, name=bn_name_base + '2b')(x)
    x = Scale(axis=bn_axis, name=scale_name_base + '2b')(x)
    x = Activation('relu', name=conv_name_base + '2b_relu')(x)

    x = Conv2D(nb_filter3, (1, 1), name=conv_name_base + '2c', use_bias=False)(x)
    x = BatchNormalization(epsilon=eps, axis=bn_axis, name=bn_name_base + '2c')(x)
    x = Scale(axis=bn_axis, name=scale_name_base + '2c')(x)

    x = add([x, input_tensor], name='res' + str(stage) + block)
    x = Activation('relu', name='res' + str(stage) + block + '_relu')(x)
    return x

def conv_block(input_tensor, kernel_size, filters, stage, block, strides=(2, 2)):
    """conv_block is the block that has a conv layer at shortcut
    
    Keyword arguments:
    input_tensor -- input tensor
    kernel_size -- defualt 3, the kernel size of middle conv layer at main path
    filters -- list of integers, the nb_filters of 3 conv layer at main path
    stage -- integer, current stage label, used for generating layer names
    block -- 'a','b'..., current block label, used for generating layer names
        
    Note that from stage 3, the first conv layer at main path is with subsample=(2,2)
    And the shortcut should have subsample=(2,2) as well
    
    """
    eps = 1.1e-5
    
    if K.image_dim_ordering() == 'tf':
        bn_axis = 3
    else:
        bn_axis = 1
    
    nb_filter1, nb_filter2, nb_filter3 = filters
    conv_name_base = 'res' + str(stage) + block + '_branch'
    bn_name_base = 'bn' + str(stage) + block + '_branch'
    scale_name_base = 'scale' + str(stage) + block + '_branch'

    x = Conv2D(nb_filter1, (1, 1), strides=strides, name=conv_name_base + '2a', use_bias=False)(input_tensor)
    x = BatchNormalization(epsilon=eps, axis=bn_axis, name=bn_name_base + '2a')(x)
    x = Scale(axis=bn_axis, name=scale_name_base + '2a')(x)
    x = Activation('relu', name=conv_name_base + '2a_relu')(x)

    x = ZeroPadding2D((1, 1), name=conv_name_base + '2b_zeropadding')(x)
    x = Conv2D(nb_filter2, (kernel_size, kernel_size),
                      name=conv_name_base + '2b', use_bias=False)(x)
    x = BatchNormalization(epsilon=eps, axis=bn_axis, name=bn_name_base + '2b')(x)
    x = Scale(axis=bn_axis, name=scale_name_base + '2b')(x)
    x = Activation('relu', name=conv_name_base + '2b_relu')(x)

    x = Conv2D(nb_filter3, (1, 1), name=conv_name_base + '2c', use_bias=False)(x)
    x = BatchNormalization(epsilon=eps, axis=bn_axis, name=bn_name_base + '2c')(x)
    x = Scale(axis=bn_axis, name=scale_name_base + '2c')(x)

    shortcut = Conv2D(nb_filter3, (1, 1), strides=strides,
                             name=conv_name_base + '1', use_bias=False)(input_tensor)
    shortcut = BatchNormalization(epsilon=eps, axis=bn_axis, name=bn_name_base + '1')(shortcut)
    shortcut = Scale(axis=bn_axis, name=scale_name_base + '1')(shortcut)

    x = add([x, shortcut], name='res' + str(stage) + block)
    x = Activation('relu', name='res' + str(stage) + block + '_relu')(x)
    return x

def ResNet152(include_top=True, weights=None,
              input_tensor=None, input_shape=None,
              large_input=False, pooling=None,
              classes=1000):
    """Instantiate the ResNet152 architecture.
    
    Keyword arguments:
    include_top -- whether to include the fully-connected layer at the 
        top of the network. (default True)
    weights -- one of `None` (random initialization) or "imagenet" 
        (pre-training on ImageNet). (default None)
    input_tensor -- optional Keras tensor (i.e. output of `layers.Input()`)
        to use as image input for the model.(default None)
    input_shape -- optional shape tuple, only to be specified if 
        `include_top` is False (otherwise the input shape has to be 
        `(224, 224, 3)` (with `channels_last` data format) or 
        `(3, 224, 224)` (with `channels_first` data format). It should 
        have exactly 3 inputs channels, and width and height should be 
        no smaller than 197. E.g. `(200, 200, 3)` would be one valid value.
        (default None)
    large_input -- if True, then the input shape expected will be 
        `(448, 448, 3)` (with `channels_last` data format) or 
        `(3, 448, 448)` (with `channels_first` data format). (default False)
    pooling -- Optional pooling mode for feature extraction when 
        `include_top` is `False`.
        - `None` means that the output of the model will be the 4D 
            tensor output of the last convolutional layer.
        - `avg` means that global average pooling will be applied to 
            the output of the last convolutional layer, and thus
            the output of the model will be a 2D tensor.
        - `max` means that global max pooling will be applied.
        (default None)
    classes -- optional number of classes to classify image into, only 
        to be specified if `include_top` is True, and if no `weights` 
        argument is specified. (default 1000)
            
    Returns:
    A Keras model instance.
        
    Raises:
    ValueError: in case of invalid argument for `weights`,
        or invalid input shape.
    """
    if weights not in {'imagenet', None}:
        raise ValueError('The `weights` argument should be either '
                         '`None` (random initialization) or `imagenet` '
                         '(pre-training on ImageNet).')

    if weights == 'imagenet' and include_top and classes != 1000:
        raise ValueError('If using `weights` as imagenet with `include_top`'
                         ' as true, `classes` should be 1000')
    
    eps = 1.1e-5
    
    if large_input:
        img_size = 448
    else:
        img_size = 224
    
    # Determine proper input shape
    input_shape = _obtain_input_shape(input_shape,
                                      default_size=img_size,
                                      min_size=197,
                                      data_format=K.image_data_format(),
                                      require_flatten=include_top)
    
    if input_tensor is None:
        img_input = Input(shape=input_shape)
    else:
        if not K.is_keras_tensor(input_tensor):
            img_input = Input(tensor=input_tensor, shape=input_shape)
        else:
            img_input = input_tensor

    # handle dimension ordering for different backends
    if K.image_dim_ordering() == 'tf':
        bn_axis = 3
    else:
        bn_axis = 1
            
    x = ZeroPadding2D((3, 3), name='conv1_zeropadding')(img_input)
    x = Conv2D(64, (7, 7), strides=(2, 2), name='conv1', use_bias=False)(x)
    x = BatchNormalization(epsilon=eps, axis=bn_axis, name='bn_conv1')(x)
    x = Scale(axis=bn_axis, name='scale_conv1')(x)
    x = Activation('relu', name='conv1_relu')(x)
    x = MaxPooling2D((3, 3), strides=(2, 2), name='pool1')(x)

    x = conv_block(x, 3, [64, 64, 256], stage=2, block='a', strides=(1, 1))
    x = identity_block(x, 3, [64, 64, 256], stage=2, block='b')
    x = identity_block(x, 3, [64, 64, 256], stage=2, block='c')

    x = conv_block(x, 3, [128, 128, 512], stage=3, block='a')
    for i in range(1,8):
        x = identity_block(x, 3, [128, 128, 512], stage=3, block='b'+str(i))

    x = conv_block(x, 3, [256, 256, 1024], stage=4, block='a')
    for i in range(1,36):
        x = identity_block(x, 3, [256, 256, 1024], stage=4, block='b'+str(i))

    x = conv_block(x, 3, [512, 512, 2048], stage=5, block='a')
    x = identity_block(x, 3, [512, 512, 2048], stage=5, block='b')
    x = identity_block(x, 3, [512, 512, 2048], stage=5, block='c')

    if large_input:
        x = AveragePooling2D((14, 14), name='avg_pool')(x)
    else:
        x = AveragePooling2D((7, 7), name='avg_pool')(x)
    
    # include classification layer by default, not included for feature extraction 
    if include_top:
        x = Flatten()(x)
        x = Dense(classes, activation='softmax', name='fc1000')(x)
    else:
        if pooling == 'avg':
            x = GlobalAveragePooling2D()(x)
        elif pooling == 'max':
            x = GlobalMaxPooling2D()(x)
    
    # Ensure that the model takes into account
    # any potential predecessors of `input_tensor`.
    if input_tensor is not None:
        inputs = get_source_inputs(input_tensor)
    else:
        inputs = img_input
    # Create model.
    model = Model(inputs, x, name='resnet152')
    
    return model
