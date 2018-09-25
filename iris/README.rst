==============================
Classifying Iris Plant Species
==============================

The famous iris dataset is a traditional statistics demonstration
dataset for building classification models. It contains data for 3
different classes (species) of iris (Setosa, Versicolour, and
Virginica) with 50 observations of each class. Each observation
records the flower's petal length and width and the sepal length and
width, together with the known class. The goal is to build a
classification model to classify new observations of flowers.

This `MLHub <https://mlhub.ai>`_ pre-built model package uses the R
language to build a classification (decision) tree model to represent
the knowledge discovered using a so-called recursive partitioning
algorithm. The knowledge representation language (decision tree) is
recognised as an easily understandable language.

To install and run the pre-built model::

  $ pip install mlhub
  $ ml install iris
  $ ml configure iris
  $ ml demo iris
