# Ubuntu system dependencies for the pre-built model. We choose to
# install user local packages rather than OS supplied packages to
# avoid the need for sys admin access from within mlhub. R is
# often operating system installed.

# Identify the required packages.

packages <- c("directlabels", "dplyr", "ggplot2", "grid", "magrittr",
              "rattle", "readr", "readxl", "scales", "stringi",
              "stringr", "tidyr")

# Determine which need to be installed.

install  <- packages[!(packages %in% installed.packages()[,"Package"])]

# Identify where they will be installed - the user's local R library.

lib <- file.path("./R")

# Ensure the user's local R library exists.

dir.create(lib, showWarnings=FALSE, recursive=TRUE)

# Install the packages into the local R library.

if (length(install))
{
  cat(sprintf("\nInstalling '%s' into '%s'...\n", paste(install, collapse="', '"), lib))
  install.packages(install, lib=lib)
} else
{
  cat("\nNo additional generic R packages need to be installed.\n")
}
