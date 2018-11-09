########################################################################
#
# Makefile for rain-tomorrow pre-built ML model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 			\
	demo.R 			\
	print.R			\
	configure.R		\
	README.txt		\
	DESCRIPTION.yaml

# Include standard Makefile templates.

include ../git.mk
include ../pandoc.mk
include ../mlhub.mk

$(MODEL).RData: train.R
	Rscript $<

clean::
	rm -rf README.txt

realclean:: clean
	rm -rf *.pdf *~
