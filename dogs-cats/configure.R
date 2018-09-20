# Ubuntu system dependencies for the pre-built model. We choose to
# install user local packages rather than OS supplied packages to
# avoid the need for sys admin access from within mlhub. R is
# often operating system installed.

# Identify the required packages.

packages <- c("magrittr", "dplyr", "caret", "e1071", "shiny", "shinyjs", "V8", "devtools", "httr")

# Determine which need to be installed.

install  <- packages[!(packages %in% installed.packages()[,"Package"])]

# Identify where they will be installed - the user's local R library.

#lib <- file.path("./R")
lib <- .libPaths()[1]

# Ensure the user's local R library exists.

dir.create(lib, showWarnings=FALSE, recursive=TRUE)

# Install the packages into the local R library.

if (length(install))
{
  cat(sprintf("\nInstalling '%s' into '%s'...", paste(install, collapse="', '"), lib))
  install.packages(install, lib=lib)
} else
{
  cat("\nNo additional generic R packages need to be installed.")
}
cat("\n\n")

# Configure ssl

library(httr)
set_config(config(ssl_verifypeer=0L))

# Additional specific packages, often as an interim measure.

cat("We also need to install these specific packages...\n")

# Identify the required packages from github repo.

dev_packages <- c("rstudio/tfruns", "rstudio/reticulate", "rstudio/keras")

# Determine which need to be installed.

dev_install <- dev_packages[!(dev_packages %in% installed.packages()[, "Package"])]

# Install the packages into the local R library.

if (length(dev_install)) 
{
  cat(sprintf("\nInstalling '%s' into '%s'...", paste(dev_install, collapse="', '"), lib))
  devtools::install_github(dev_install, lib = lib)
} else
{
  cat("\nNo additional generic R packages need to be installed.")
}
cat("\n\n")


