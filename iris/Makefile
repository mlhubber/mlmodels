########################################################################
#
# Makefile for iris r pre-build ML model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 		\
	iris_model.RData\
	configure.R 	\
	demo.R 		\
	score.R 	\
	print.R 	\
	display.R 	\
	train.R		\
	iris.csv	\
	data.csv 	\
	README.txt	\
	DESCRIPTION.yaml

# Include standard Makefile templates.

include ../mlhub.mk
include ../git.mk
include ../pandoc.mk

$(MODEL).RData: train.R iris.csv
	Rscript $<

clean::
	rm -rf README.txt output

realclean:: clean
	rm -rf rain-tomorrow_*.mlm
