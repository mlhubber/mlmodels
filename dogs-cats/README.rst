==============================================
Dogs and Cats Image Classification using keras
==============================================

The Dogs-vs-Cats dataset from the Kaggle computer vision competition
was used to train a deep neural network model, predicting the
probability of the image being a dog or a cat using a pretrained
convnet model.

A newly created small dataset consists of 2,000 images of dogs and
cats (1000 from each class) is used to train the model. It contains
three subsets: a training set with 1,000 samples chosen from each
class, a validation set with 500 samples chosen from each class, and a
test set with 500 samples.

The pre-built model uses R's *keras* package to build a convolutional
neural network (CNN). The knowledge is discovered using a keras
sequential model constructed by using a pretrained vgg16 model as the
convolutional base and adding dense layers on top. A mathematical
measure of the information content of the model is used to guide the
network construction. CNNs are a popular deep neural network learner
for image classification because they are highly reusable.

The **demo** command applies the pre-built model to a test dataset with
known values of the labels and presents an evaluation of the
performance of the model in terms of loss, accuracy, and confusion matrix. 
Errors in the predictions are highlighted in the output. The model using 
feature extraction with a pretrained network results in an accuracy of 90% 
on the test set from Kaggle. Here, we replace the test set with 50 samples 
of each class from PEXELS for demonstraction purpose to avoid licensing issue.

The **print** command displays a textual summary of the model and its
model parameters. A textual presentation is not always easy to read
and so the **display** command will draw the model as a network plot.

The **score** command launches a shiny app to interactively provide new image from
the category of dogs and cats to obtain the prediction of belonging to dogs or cats.

You can **retrain** the model on your own labeled image datasets (training and validation data). 
Feature extraction with data augmentation is a valuable technique for working with 
small image datasets, as well as a powerful way to fight overfitting.
The model performance could be further improved by fine-tuning some of the layers.

This image classificaition example could be easily adapted to other types of images. 

You can go through the full tutorial 
`keras-image-classification-on-small-datasets <https://tensorflow.rstudio.com/blog/keras-image-classification-on-small-datasets>`_
on `Rstudio tensorflow <https://tensorflow.rstudio.com>`_ website.
