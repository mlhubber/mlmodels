library(rattle)

load("iris_model.RData")

results <- "results"
fname <- file.path(results, "dtree.pdf")
  
if (!dir.exists(results)) dir.create(results)

pdf(fname)
fancyRpartPlot(m$finalModel, sub="")
tmp <- dev.off() # Assign to avoid output.
system(paste("display -background white -flatten", fname))
