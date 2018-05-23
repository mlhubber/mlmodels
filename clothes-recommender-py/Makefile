########################################################################
#
# Makefile for AI Hub Repository for image-classification
#
########################################################################

# List the files to be included in the .aipk package.

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

# Include the standard template for managing ai packages.

include ../mlhub.mk
include ../git.mk
include ../clean.mk

README.txt: README.md
	pandoc $^ -o $@
