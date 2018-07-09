########################################################################
#
# Makefile for rain-tomorrow pre-built ML model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 			\
	demo.R 			\
	print.R			\
	ports.xlsx		\
	configure.R		\
	README.txt		\
	DESCRIPTION.yaml

# Include standard Makefile templates.

include ../mlhub.mk
include ../git.mk
include ../pandoc.mk

$(MODEL).RData: train.R
	Rscript $<

clean::
	rm -rf README.txt

realclean:: clean
	rm -rf *.pdf *~
