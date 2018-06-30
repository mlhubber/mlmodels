packages <- c("rpart", "magrittr")
install  <- packages[!(packages %in% installed.packages()[,"Package"])]
if (length(install)) install.packages(install, lib=Sys.getenv("R_LIBS_USER"))
