########################################################################
#
# Makefile for rain pre-built ML model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 		\
	rain.RData	\
	configure.R	\
	train.R		\
	demo.R 		\
	print.R		\
	display.R	\
	score.R		\
	README.txt	\
	DESCRIPTION.yaml

# Include standard Makefile templates.

include ../mlhub.mk
include ../git.mk
include ../pandoc.mk

$(MODEL).RData: train.R
	Rscript $<

clean::
	rm -rf README.txt dtree.pdf varimp.pdf

realclean:: clean
	rm -rf rain_*.mlm
