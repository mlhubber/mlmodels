packages <- c("magrittr", "dplyr", "caret", "e1071")
install <- packages[!(packages %in% installed.packages()[, "Package"])]
if (length(install)) install.packages(install, lib=Sys.getenv("R_LIBS_USER"))

dev_packages <- c("tfruns", "reticulate", "keras")
dev_install <- dev_packages[!(dev_packages %in% installed.packages()[, "Package"])]
if (length(dev_install)) devtools::install_github(dev_install, lib=Sys.getenv("R_LIBS_USER"))
