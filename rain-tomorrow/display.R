# Display the sample decision tree model.

library(rpart)
source("rattle.R")

if (Sys.getenv("DISPLAY") != "")
{
  load("rain-tomorrow.RData")

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

cat("\nYou may like to predict if it will rain tomorrow:\n",
    "\n  $ ml score rain-tomorrow\n\n")
