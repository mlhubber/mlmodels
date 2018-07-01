packages <- c("directlabels", "magrittr", "readxl")
install  <- packages[!(packages %in% installed.packages()[,"Package"])]
dir.create(Sys.getenv("R_LIBS_USER"), showWarnings=FALSE, recursive=TRUE)
dir.create(Sys.getenv("R_LIBS_USER"), showWarnings=FALSE, recursive=TRUE)
if (length(install)) install.packages(install, lib=Sys.getenv("R_LIBS_USER"))
