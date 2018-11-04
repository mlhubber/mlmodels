==================
Object Recognition
==================

This model is based on the `deep learning kubernetes
tutorial <https://blogs.technet.microsoft.com/machinelearning/2018/04/19/deploying-deep-learning-models-on-kubernetes-with-gpus/>`__
by Mathew Salvaris and Fidan Boylu Uz of Microsoft. The code comes from
their `github
repository <https://github.com/Microsoft/AKSDeploymentTutorial>`__
containing a number of tutorials in Jupyter notebooks that have
step-by-step instructions on how to deploy a pretrained deep learning
model on a GPU enabled Kubernetes cluster.

The pre-trained `ResNet152
<https://www.tensorflow.org/hub/modules/google/imagenet/resnet_v1_152/classification/1>`__
model is used. Sample images are provided, pre-processed to the
required format and classified using the model.  It can be used to
recognise `1000 different kinds of classes
<http://data.dmlc.ml/mxnet/models/imagenet/synset.txt>`__.  To name a few::

  n01440764 tench, Tinca tinca
  n01443537 goldfish, Carassius auratus
  n01484850 great white shark, white shark, man-eater, man-eating shark, Carcharodon carcharias
  n01491361 tiger shark, Galeocerdo cuvieri
  n01494475 hammerhead, hammerhead shark
  n01496331 electric ray, crampfish, numbfish, torpedo
  n01498041 stingray
  n01514668 cock
  n01514859 hen
  n01518878 ostrich, Struthio camelus

Visit the `github repository
<https://Github.com/mlhubber/mlmodels/tree/master/object-recognition>`_  for
the sample code.

-----
Usage
-----

* To install and run the pre-built model::

  $ pip install mlhub
  $ ml install object-recognition
  $ ml configure object-recognition
  $ ml demo object-recognition

* To classify:

  - An image from a local file::

      $ ml score object-recognition ~/.mlhub/object-recognition/images/lynx.jpg

  - Images in a folder::

      $ ml score object-recognition ~/.mlhub/object-recognition/images/

  - An image from the web (See https://en.wikipedia.org/wiki/Aciagrion_occidentale) ::

      $ ml score object-recognition https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Aciagrion_occidentale-Kadavoor-2017-05-08-002.jpg/440px-Aciagrion_occidentale-Kadavoor-2017-05-08-002.jpg

  - Interatively without repeatedly reloading the model::

      $ ml score object-recognition

* To visualise the network graph of the model::

    $ ml display object-recognition

  The default browser will be opened to display the graph rendered by
  `TensorBoard <https://www.tensorflow.org/guide/graph_viz>`__.

