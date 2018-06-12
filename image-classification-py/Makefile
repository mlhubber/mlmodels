########################################################################
#
# Makefile for image-classification-py pre-built DL model
#
########################################################################

# List the files to be included in the .mlm package.

MODEL_FILES = 			\
	bottleneck_fc_model.h5	\
	bottleneck_fc_model_weights.h5 \
	configure.sh		\
        train.py		\
	demo.py 		\
	print.py		\
	display.py		\
	README.txt		\
	DESCRIPTION.yaml

# Include standard Makefile templates.

include ../mlhub.mk
include ../git.mk
include ../clean.mk
include ../pandoc.mk

$(MODEL).h5: train.py
	python $<

clean::
	rm -rf README.txt output

realclean:: clean
	rm -rf image-classification-py_*.mlm
