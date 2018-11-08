cat("=============
Decision Tree
=============

A visual representation of a model can be quite insightful, and often
more so than the printed textual representation. For a decision tree
model, representing the discovered knowledge as a decision tree, we
read the tree from top to bottom, traversing the path corresponding
to the answer at each node. The leaf node has the final decision
together with the probability.
")

suppressMessages(
{
library(rattle)
})

load("iris_rpart_caret_model.RData")

model <- m$finalModel

if (Sys.getenv("DISPLAY") != "")
{
  fname <- "iris_rpart_model.pdf"
  pdf(fname)
  fancyRpartPlot(model, sub="")
  invisible(dev.off())
  system(paste("atril --preview", fname), ignore.stderr=TRUE, wait=FALSE)
}

cat("\nPress Enter to continue: ")
invisible(readChar("stdin", 1))
