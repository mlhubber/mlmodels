Image Classification using ResNet152
====================================

This model is based on the [deep learning kubernetes
tutorial](https://blogs.technet.microsoft.com/machinelearning/2018/04/19/deploying-deep-learning-models-on-kubernetes-with-gpus/)
by Mathew Salvaris and Fidan Boylu Uz of Microsoft. The code comes
from their [github
repository](https://github.com/Microsoft/AKSDeploymentTutorial)
containing a number of tutorials in Jupyter notebooks that have
step-by-step instructions on how to deploy a pretrained deep learning
model on a GPU enabled Kubernetes cluster.

The pre-trained
[ResNet152](https://www.tensorflow.org/hub/modules/google/imagenet/resnet_v1_152/classification/1)
model is used. Sample images are provided, pre-processed to the
required format and classified using the model.

The **demo** command applies the pre-built model to the collection of
sample known images to classify them.

The **display** command will present a visualisation of the
classifications.
