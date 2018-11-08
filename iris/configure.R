# Ubuntu system dependencies for the pre-built model. We choose to
# install user local packages rather than OS supplied packages to
# avoid the need for sys admin access from within mlhub. R is
# often operating system installed.

# Use atril to display PDF files.

cat("Install system dependencises if needed...\n atril\n\n")
system("sudo apt-get install -y atril", ignore.stderr=TRUE, ignore.stdout=TRUE)

# Identify the required packages.

packages <- c("rpart", "magrittr", "caret", "rpart.plot", "RColorBrewer")

# Determine which need to be installed.

install  <- packages[!(packages %in% installed.packages()[,"Package"])]

# Report on what is already installed.

already <- setdiff(packages, install)
if (length(already))
{
    cat("The following required R packages are already installed:\n",
        paste(already, collapse=" "))
}

# Identify where they will be installed - the user's local R library.

lib <- file.path("./R")

# Ensure the user's local R library exists.

dir.create(lib, showWarnings=FALSE, recursive=TRUE)

# Install the packages into the local R library.

if (length(install))
{
  cat(sprintf("\nInstalling '%s' into '%s'...", paste(install, collapse="', '"), lib))
  install.packages(install, lib=lib)
}
cat("\n\n")

# Additional specific packages, often as an interim measure.

cat("We also need to install these specific package versions...\n")

pkgs <- c("https://cran.r-project.org/src/contrib/Archive/rpart.plot/rpart.plot_3.0.4.tar.gz")
for (pkg in pkgs)
{
  cat("", basename(pkg), "\n")
  install.packages(pkg, repos=NULL, lib=lib)
}
