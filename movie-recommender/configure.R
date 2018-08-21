packages <- c("ggplot2", "dplyr", "caret", "plyr")
install <- packages[!(packages %in% installed.packages()[, "Package"])]
dir.create(Sys.getenv("R_LIBS_USER"), showWarnings=FALSE, recursive=TRUE)
if (length(install)) install.packages(install, lib=Sys.getenv("R_LIBS_USER"))

