########################################################################
#
# Makefile for MLHub model Archive
#
########################################################################

APP=mlmodels
VER=1.0.0

DESCRIPTIONS = 					\
	audit/DESCRIPTION.yaml			\
	barchart/DESCRIPTION.yaml		\
	beeswarm/DESCRIPTION.yaml		\
	clothes/DESCRIPTION.yaml  		\
	colorize/DESCRIPTION.yaml 		\
	pets/DESCRIPTION.yaml 			\
	iris/DESCRIPTION.yaml	 		\
	movies/DESCRIPTION.yaml			\
	objects/DESCRIPTION.yaml		\
	ports/DESCRIPTION.yaml			\
	rain/DESCRIPTION.yaml			\
	scatter/DESCRIPTION.yaml		\

INC_BASE    = .
INC_PANDOC  = $(INC_BASE)/pandoc.mk
INC_GIT     = $(INC_BASE)/git.mk
INC_AZURE   = $(INC_BASE)/azure.mk
INC_CLEAN   = $(INC_BASE)/clean.mk

define HELP
Makefile for Hub of Machine Learning Models.

Local targets:

  localhub	Generate and install Packages.yaml on localhost.
  mlhub		Generate and install Packages.yaml on mlhub.ai.
  Packages.yaml Generate meta-data file for the repository.
  allclean	Clean all package subfolders.
  all		Update all packages and upload to mlhub.

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

.PHONY: all
all:
	for p in $(DESCRIPTIONS:/DESCRIPTION.yaml=); do \
	  (cd $$p; make mlhub); \
	done

allclean: realclean
	for p in $(DESCRIPTIONS:/DESCRIPTION.yaml=); do \
	  (cd $$p; make realclean); \
	done


########################################################################
# PACKAGES
########################################################################

#REPO_HOST = mlhub.ai
REPO_HOST = mlhub.togaware.com
#BASE_PATH = /var/www/html
BASE_PATH = webapps/mlhub2
REPO_PATH = pool/main
#REPO_USER = root
REPO_USER = gjw
REPO_SSH  = $(REPO_USER)@$(REPO_HOST)

.PHONY: localhub
localhub: Packages.yaml
	sudo cp $< $(BASE_PATH)/
	sudo chmod -R a+rX $(BASE_PATH)/

.PHONY: mlhub
mlhub: Packages.yaml Packages.html
	rsync -avzh $^ $(REPO_SSH):$(BASE_PATH)/
	ssh $(REPO_SSH) chmod -R a+rX $(BASE_PATH)/

allmlhub:
	for p in $(DESCRIPTIONS:/DESCRIPTION.yaml=); do \
	  echo "==========> $$p <=========="; \
	  (cd $$p; make mlhub); \
	done

Packages.yaml: $(DESCRIPTIONS)
	cat $^ > $@

Packages.html: pkgidx kwdidx.R pandoc.css Packages.yaml
	./pkgidx > $@

realclean::
	rm -f Packages.html Packages.yaml Packages.rst

allstatus:
	for p in audit iris rain colorize objects; do \
	  echo "==========> $$p <=========="; \
	  (cd $$p; make status); \
	done
