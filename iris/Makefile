########################################################################
#
# Makefile for audit pre-built ML model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 				\
	train.R				\
	configure.R 			\
	demo.R 				\
	print.R 			\
	display.R 			\
	score.R 			\
	README.txt			\
	DESCRIPTION.yaml		\
	$(MODEL).csv			\
	data.csv 			\
	iris_rpart_caret_model.RData	\

# Include standard Makefile templates.

include ../git.mk
include ../pandoc.mk
include ../mlhub.mk

$(MODEL)_rpart_caret_model.RData: train.R $(MODEL).csv
	Rscript $<

clean::
	rm -rf README.txt output

realclean:: clean
	rm -rf $(MODEL)_*.mlm $(MODEL)_rpart_caret_model.RData
	rm -f  	$(MODEL)_rpart_caret_model.RData
