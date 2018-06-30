packages <- c("directlabels", "magrittr", "readxl")
install  <- packages[!(packages %in% installed.packages()[,"Package"])]
if (length(install)) install.packages(install)
