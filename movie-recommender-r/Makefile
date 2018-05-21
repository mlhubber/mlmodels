########################################################################
#
# Makefile for AI Hub Repository for image-classification
#
########################################################################

# List the files to be included in the .aipk package.

AIPACK_FILES = 			\
	demo.R  		\
	merge.R  		\
	movie-recommender-r.R 	\
	print.R			\
	SAR_0.0.1.tar.gz	\
	sar_model.RData		\
	score.R			\
	train.R			\
	README.txt		\
	DESCRIPTION.yml 	\
	data

# Include the standard template for managing ai packages.

include ../aipk.mk
include ../git.mk

README.txt: README.md
	pandoc $^ -o $@
