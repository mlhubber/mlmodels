# The display command aims to provide a visualisation of the model in
# some form. This will differen from model to model.

# Display the sample decision tree model.

library(rpart)

# We include a simple rattle script so as not to require loading all
# of rattle.

source("rattle.R")

# If a display is available then make use of it.

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

# It is always polite to suggest the next step for the user.

cat("\nYou may like to predict if it will rain tomorrow:\n",
    "\n  $ ml score rain-tomorrow\n\n")
