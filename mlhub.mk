########################################################################
#
# Manage ML Hub Models
#
########################################################################

define MLHUB_HELP
Makefile for Managing ML Models

Local targets:

  test		Test the demo script.

endef
export MLHUB_HELP

help::
	@echo "$$MLHUB_HELP"

########################################################################
# MODEL ARCHIVE
########################################################################

ifneq ("$(wildcard MLHUB.yaml)","")
  DESCRIPTION = MLHUB.yaml
else
  DESCRIPTION = DESCRIPTION.yaml
endif

MODEL = $(shell basename `pwd`)
MODEL_VERSION = $(shell grep version $(DESCRIPTION) | awk '{print $$NF}')

README_HTML = README.html

HTML_MSG = <p>This package is part of the <a href="https://mlhub.ai">Machine Learning Hub</a> repository.</p>

test: demo.R
	Rscript demo.R

.PHONY: clean
clean::
	rm -f README.txt README.html TMP.R
