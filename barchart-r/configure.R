packages <- c("rpart", "magrittr", "RColorBrewer", "rattle.data")
install  <- packages[!(packages %in% installed.packages()[,"Package"])]
if (length(install)) install.packages(install)
