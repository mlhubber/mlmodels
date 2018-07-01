packages <- c("magrittr", "dplyr", "caret", "e1071", "shiny", "shinyjs", "V8")
install <- packages[!(packages %in% installed.packages()[, "Package"])]
dir.create(Sys.getenv("R_LIBS_USER"), showWarnings=FALSE, recursive=TRUE)
if (length(install)) install.packages(install, lib=Sys.getenv("R_LIBS_USER"))

dev_packages <- c("tfruns", "reticulate", "keras")
dev_install <- dev_packages[!(dev_packages %in% installed.packages()[, "Package"])]
if (length(dev_install)) devtools::install_github(dev_install, lib=Sys.getenv("R_LIBS_USER"))
