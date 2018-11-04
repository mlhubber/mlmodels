suppressMessages(
{
library(rattle)
})

load("iris_model.RData")

if (Sys.getenv("DISPLAY") != "")
{
  fname <- "iris_rpart_model.pdf"
  pdf(fname)
  fancyRpartPlot(m$finalModel, sub="")
  invisible(dev.off())
  system(paste("atril --preview", fname))
}
