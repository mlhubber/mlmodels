########################################################################
#
# Makefile for resnet152
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 			\
	configure.sh		\
	demo.py 		\
	README.txt		\
	DESCRIPTION.yaml	\
	images			\
	resources		\
	objreg_utils.py         \
	print.py		\
	display.py		\
	score.py                \

include ../mlhub.mk
include ../git.mk
include ../pandoc.mk
include ../clean.mk

realclean::
	rm README.txt README.html
