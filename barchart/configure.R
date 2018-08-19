packages <- c("rpart", "magrittr", "RColorBrewer")
install  <- packages[!(packages %in% installed.packages()[,"Package"])]
lib <- Sys.getenv("R_LIBS_USER")
dir.create(lib, showWarnings=FALSE, recursive=TRUE)
if (length(install))
{
  cat(sprintf("\nInstalling '%s' into '%s'...", paste(install, collapse="', '"), lib))
  install.packages(install, lib=lib)
} else
{
  cat("\nNo additional R packages need to be installed.")
}
cat("\n\n")
