library(rattle)

if (Sys.getenv("DISPLAY") != "")
{
  load("iris_model.RData")

  results <- "results"
  fname <- file.path(results, "dtree.pdf")
  
  if (!dir.exists(results)) dir.create(results)
  
  pdf(fname)
  fancyRpartPlot(m$finalModel, sub="")
  dev.off()
  system(paste("display -background white -flatten", fname))
} else
{
  cat("No graphic display available or on a Windows machine (not currently supported).\n")
}
