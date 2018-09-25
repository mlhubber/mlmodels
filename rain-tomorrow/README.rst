========================
Predicting Rain Tomorrow
========================

The weatherAUS dataset from R's `rattle
<https://rattle.togaware.com>`_ package was used to train a predictive
model, predicting the probability of it raining tomorrow based on
today's weather observations.

The training dataset consists of daily weather observations from
weather stations across Australia, with a target (aka output,
predicted or dependent) variable under the column *target* which has
the values of Yes/No indicating if it rained the following day. The
input variables in the actual dataset include measurements from today
like the amount of sunshine, the humidity at 3pm, the amount of rain
recorded, etc.

This `MLHub <https://mlhub.ai>`_ pre-built model uses R's *rpart*
package to build a decision tree as its knowledge representation
language. The knowledge is discovered using a so-called recursive
partitioning algorithm. A mathematical measure of the information
content of the model is used to guide the tree construction. Decision
trees are a popular knowledge representation because they are easy to
understand and explain.

To install and run the pre-built model::

  $ pip install mlhub
  $ ml install rain-tomorrow
  $ ml configure rain-tomorrow
  $ ml demo rain-tomorrow

This model comes from the Essentials of Data Science by Graham
Williams `<https://bit.ly/essentials_data_science>`_. Further support
material is also available from `<https://essentials.togaware.com/>`_.
