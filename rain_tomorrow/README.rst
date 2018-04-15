========================
Predicting Rain Tomorrow
========================

The weather dataset from R's rattle package has been used to build a
predictive model, predicting the probability of it raining tomorrow.

The training dataset consists of daily weather observations from
weather stations across Australia, with a target (aka output,
predicted or dependent) variable under the column *target* of 0/1
indicating if it rained the following day. The input variables in the
actual dataset include measurements like the amount of sunshine, the
humity at 3pm, the amount of rain recorded today, etc.

This pre-built model uses R's *rpart* package to build a decision tree
as its knowledge representation language. The knowledge is discovered
using a so-called recursive partitioning algorithm. Decision trees are
easy to understand.

The **demo** command applies the pre-built model to a dataset with
known values of the target variable and presents an evaluation of the
performance of the model in terms of accuracy.

The **print** command displays a textual summary of the model and its
build parameters. A textual presentation is not always easy to read
and so the **display** command will draw the model as a decision tree.

The **rebuild** command allows us to provide our own csv dataset and
to then rebuild a model to predict the *target* variable. The dataset
can be any data really, as long as one column has the name *target*.

