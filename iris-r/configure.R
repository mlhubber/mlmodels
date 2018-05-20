packages <- c("rpart", "magrittr", "caret", "rpart.plot", "RColorBrewer")
install  <- packages[!(packages %in% installed.packages()[,"Package"])]
if (length(install)) install.packages(install)
