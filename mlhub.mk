########################################################################
#
# Manage ML Hub Models
#
########################################################################

define MLHUB_HELP
Makefile for Managing ML Models

Local targets:

  dist          Build the model zip archive as .mlm file
  localhub      Update model to localhost 
  mlhub		Update model to https://mlhub.ai/
  test		Test the demo and print scripts.

endef
export MLHUB_HELP

help::
	@echo "$$MLHUB_HELP"

########################################################################
# REPOSITORY
########################################################################

#REPO_HOST = mlhub.ai
REPO_HOST = mlhub.togaware.com
#BASE_PATH = /var/www/html
BASE_PATH = webapps/mlhub2
REPO_PATH = pool/main
#REPO_USER = root
REPO_USER = gjw
REPO_URL  = https://$(REPO_HOST)$(BASE_PATH)$(REPO_PATH)
REPO_SSH  = $(REPO_USER)@$(REPO_HOST)

########################################################################
# MODEL ARCHIVE
########################################################################

ifneq ("$(wildcard MLHUB.yaml)","")
  DESCRIPTION = MLHUB.yaml
else
  DESCRIPTION = DESCRIPTION.yaml
endif

MODEL = $(shell basename `pwd`)
INIT_CHAR = $(shell printf %.1s "$(MODEL)")
MODEL_PATH = $(REPO_PATH)/$(INIT_CHAR)/$(MODEL)
MODEL_MLM = $(MODEL)_$(MODEL_VERSION).mlm
MODEL_VERSION = $(shell grep version $(DESCRIPTION) | awk '{print $$NF}')
MODEL_FILENAME = \ \ filename     : $(REPO_PATH)/$(INIT_CHAR)/$(MODEL)/$(MODEL_MLM)
MODEL_DATE =     \ \ date         : $(shell date +"%F %T")

README_HTML = README.html

HTML_MSG = <p>This package is part of the <a href="https://mlhub.ai">Machine Learning Hub</a> repository.</p>

test: demo.R print.R
	Rscript demo.R
	Rscript print.R > TMP.R
	Rscript TMP.R

# Don't create YAML file, just a temporary file???

.PHONY: local
local: $(MODEL_MLM)
	ml install $^

cleanlocal:
	rm -rf ~/.mlhub/$(MODEL)/

$(MODEL_YAML): $(MODEL_YML)
	sed -e "s|meta:|meta:\\n$(MODEL_FILENAME)|g" $^ |\
	tr -d "'" > $@
	echo "" >> $@

.PHONY: clean
clean::
	rm -f $(MODEL)_*.mlm README.txt README.html TMP.R

%.txt: %.rst
	pandoc -t plain $< | awk '/^Usage$$/{exit}{print}' | perl -00pe0 > $@

%.txt: %.md
	pandoc -t plain $< | awk '/^Usage$$/{exit}{print}' | perl -00pe0 > $@

