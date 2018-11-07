========================
Predicting Rain Tomorrow
========================

The weatherAUS dataset from R's `Rattle
<https://rattle.togaware.com>`_ package was used to train a predictive
model for the probability of it raining tomorrow based on today's
weather observations.  The training dataset consists of daily weather
observations from weather stations across Australia. The input
variables in the dataset include measurements from today like the
amount of sunshine, the humidity at 3pm, the amount of rain recorded,
etc.

This `MLHub <https://mlhub.ai>`_ pre-built model uses R's *rpart*
package to build the decision tree using a recursive partitioning
algorithm.  The information content of the model is used to guide the
tree construction. Decision trees are a popular knowledge
representation because they are easy to understand and explain.

Visit the github repository for examples of its usage:
https://github.com/mlhubber/mlmodels/tree/master/rain

-----
Usage
-----

To install and run the pre-built model::

  $ pip install mlhub
  $ ml install rain
  $ ml configure rain
  $ ml demo rain

This model comes from the Essentials of Data Science by Graham
Williams `<https://bit.ly/essentials_data_science>`_. Further support
material is also available from `<https://essentials.togaware.com/>`_.
