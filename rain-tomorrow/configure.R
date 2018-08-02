# Ubuntu system dependencies for the pre-built model. We choose to
# install user local packages rather than OS supplied packages to
# avoid the need for sys admin access from within mlhub. Nontheless we
# assume R is operating system installed.

# Identify the required packages.

packages <- c("rpart", "magrittr")

# Determine which need to be installed.

install  <- packages[!(packages %in% installed.packages()[,"Package"])]

# Ensure the user's local R library exists.

dir.create(Sys.getenv("R_LIBS_USER"), showWarnings=FALSE, recursive=TRUE)

# Install the packages local to the user.

if (length(install)) install.packages(install, lib=Sys.getenv("R_LIBS_USER"))
