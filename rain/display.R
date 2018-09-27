# The display command aims to provide a visualisation of the model in
# some form. This will differ from model to model.

# Display the sample decision tree model.

suppressMessages(
{
  library(rattle)       # Support: normVarNames(), weatherAUS. 
  library(rpart)        # Decision tree modeller.
})

load("rain.RData")

cat("\nTo display the decision tree press <Enter>: ")
invisible(readChar("stdin", 1))

fname <- "dtree.pdf"
pdf(fname)
fancyRpartPlot(model, sub="")
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)

cat("\nTo display the vairable importance plot press <Enter>: ")
invisible(readChar("stdin", 1))

fname <- "varimp.pdf"
pdf(fname)
print(ggVarImp(model))
invisible(dev.off())
system(sprintf("evince --preview %s", fname), ignore.stderr=TRUE, wait=FALSE)
