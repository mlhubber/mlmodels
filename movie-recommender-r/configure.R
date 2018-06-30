packages <- c("ggplot2", "dplyr", "caret", "plyr")
install <- packages[!(packages %in% installed.packages()[, "Package"])]
if (length(install)) install.packages(install, lib=Sys.getenv("R_LIBS_USER"))

