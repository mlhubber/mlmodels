# Display the sample decision tree model.

library(rpart)
source("rattle.R")

if (Sys.getenv("DISPLAY") != "")
{
  load("rain-tomorrow-dt.RData")

  output <- "output"
  fname <- file.path(output, "dtree.pdf")
  
  if (!dir.exists(output)) dir.create(output)
  
  pdf(fname)
  fancyRpartPlot(model, sub="")
  dev.off()
  system(paste("display -background white -flatten", fname))
} else
{
  cat("Graphic display not available.\n")
}

# Suggest next step.

cat("\nYou may like to build a decision tree model on your own csv file with:\n",
    "\n  $ ml rebuild rain-tomorrow-dt mydata.csv\n\n")
