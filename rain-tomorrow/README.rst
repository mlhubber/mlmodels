========================
Predicting Rain Tomorrow
========================

The weather dataset from R's rattle package was used to train a
predictive model, predicting the probability of it raining tomorrow
based on today's weather observations.

The training dataset consists of daily weather observations from
weather stations across Australia, with a target (aka output,
predicted or dependent) variable under the column *target* which has
the values of Yes/No indicating if it rained the following day. The
input variables in the actual dataset include measurements from today
like the amount of sunshine, the humidity at 3pm, the amount of rain
recorded, etc.

This pre-built model uses R's *rpart* package to build a decision tree
as its knowledge representation language. The knowledge is discovered
using a so-called recursive partitioning algorithm. A mathematical
measure of the information content of the model is used to guide the
tree construction. Decision trees are a popular knowledge
representation because they are easy to understand and explain.

The **demo** command applies the pre-built model to a dataset with
known values of the target variable and presents an evaluation of the
performance of the model in terms of accuracy. Errors in the
predictions are highlighted in the output. None but the most trivial
of models is ever 100% accurate.

The **print** command displays a textual summary of the model and its
build parameters. A textual presentation is not always easy to read
and so the **display** command will draw the model as a decision tree.

Run the **score** command to interactively provide observations from
today's weather to obtain the chance of rain tomorrow from the model.

You can **retrain** the model on your own csv dataset containing a
*target* variable. The dataset can be any data really, as long as one
column has the name *target*.

