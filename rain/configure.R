# Ubuntu system dependencies for the pre-built model. We choose to
# install user local packages rather than OS supplied packages to
# avoid the need for sys admin access from within mlhub. R is
# often operating system installed.

# Use atril to display PDF files.

system("sudo apt-get install atril", ignore.stderr=TRUE, ignore.stdout=TRUE)

# Identify the required packages.

packages <- c("rpart", "magrittr", "dplyr", "tidyr", "rattle")

# Determine which need to be installed.

install  <- packages[!(packages %in% installed.packages()[,"Package"])]

# Identify where they will be installed - the user's local R library.

lib <- file.path("./R")

# Ensure the user's local R library exists.

dir.create(lib, showWarnings=FALSE, recursive=TRUE)

# Install the packages into the local R library.

if (length(install))
{
  cat(sprintf("\nInstalling '%s' into '%s'...", paste(install, collapse="', '"), lib))
  install.packages(install, lib=lib)
} else
{
  cat("No additional OS-based R packages need to be installed.")
}
cat("\n\n")

# Additional specific packages, often as an interim measure.

cat("We also need to install these non-OS available R packages...\n")

pkgs <- c("https://cran.r-project.org/src/contrib/rpart.plot_3.0.4.tar.gz")
for (pkg in pkgs)
{
  cat("  ", pkg, "\n")
  install.packages(pkg, repos=NULL, lib=lib)
}
