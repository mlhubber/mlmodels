########################################################################
#
# Makefile for MLHub model Archive
#
########################################################################

APP=mlmodels
VER=1.0.0

INC_BASE    = .
INC_PANDOC  = $(INC_BASE)/pandoc.mk
INC_GIT     = $(INC_BASE)/git.mk
INC_AZURE   = $(INC_BASE)/azure.mk
INC_CLEAN   = $(INC_BASE)/clean.mk

define HELP
Makefile for Hub of Machine Learning Models.

Local targets:

  mlhub		Generate and install Packages.yaml on mlhub.ai.
  Packages.yaml Generate met-data file for the repository.

endef
export HELP

help::
	@echo "$$HELP"

ifneq ("$(wildcard $(INC_PANDOC))","")
  include $(INC_PANDOC)
endif
ifneq ("$(wildcard $(INC_GIT))","")
  include $(INC_GIT)
endif
ifneq ("$(wildcard $(INC_AZURE))","")
  include $(INC_AZURE)
endif
ifneq ("$(wildcard $(INC_CLEAN))","")
  include $(INC_CLEAN)
endif

########################################################################
# PACKAGES
########################################################################

REPO_HOST = mlhub.ai
BASE_PATH = /var/www/html
REPO_PATH = pool/main
REPO_USER = root
REPO_SSH  = $(REPO_USER)@$(REPO_HOST)

#DESCRIPTIONS = */DESCRIPTION.yaml
DESCRIPTIONS = rain-tomorrow/DESCRIPTION.yaml

.PHONY: mlhub
mlhub: Packages.yaml
	rsync -avzh $< $(REPO_SSH):$(BASE_PATH)/
	ssh $(REPO_SSH) chmod -R a+rX $(BASE_PATH)/$<

Packages.yaml: $(DESCRIPTIONS)
	cat $^ > $@

