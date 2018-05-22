########################################################################
#
# Makefile for movie-recommender-r pre-built ML model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 			\
	configure.sh		\
	demo.R  		\
	merge.R  		\
	movie-recommender-r.R 	\
	print.R			\
	SAR_0.0.1.tar.gz	\
	sar_model.RData		\
	score.R			\
	train.R			\
	README.txt		\
	DESCRIPTION.yaml 	\
	data

# Include the standard Makefile template.

include ../mlhub.mk
include ../git.mk
include ../pandoc.mk

clean::
	rm -rf README.txt output

realclean:: clean
	rm -rf movie-recommender-r_*.mlm
