########################################################################
#
# Makefile for rain-tomorrow model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 			\
	rain-tomorrow-dt.RData	\
	build.R			\
	demo.R 			\
	print.R			\
	display.R		\
	score.R			\
	rattle.R		\
	README.txt		\
	DESCRIPTION.yaml

include ../mlhub.mk
include ../git.mk
include ../pandoc.mk

clean::
	rm -rf README.txt output

realclean:: clean
	rm -rf rain-tomorrow-dt_*.mlm
