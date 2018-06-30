packages <- c("magrittr", "dplyr", "caret", "e1071", "shiny", "shinyjs", "V8")
install <- packages[!(packages %in% installed.packages()[, "Package"])]
if (length(install)) install.packages(install)

dev_packages <- c("tfruns", "reticulate", "keras")
dev_install <- dev_packages[!(dev_packages %in% installed.packages()[, "Package"])]
if (length(dev_install)) devtools::install_github(dev_install)