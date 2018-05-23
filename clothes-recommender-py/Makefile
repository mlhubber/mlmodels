########################################################################
#
# Makefile for clothes-recommender-py pre-build ML model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 		\
	configure.sh	\
	demo.py		\
	display.py	\
	helpers_cntk.py \
	helpers.py	\
	print.py	\
	score.py	\
	PARAMETERS.py	\
	README.txt	\
	DESCRIPTION.yaml\
	data		\
	proc

# Include the standard Makefile template.

include ../mlhub.mk
include ../git.mk
include ../clean.mk
include ../pandoc.mk

clean::
	rm -rf README.txt output

realclean:: clean
	rm -rf clothes-recommender-py_*.mlm
