########################################################################
#
# Makefile for MLHub model Archive
#
########################################################################

APP=mlmodels
VER=1.0.0

MODELS = 		\
	animate		\
	audit		\
	aztext		\
	azspeech2txt	\
	barchart	\
	beeswarm	\
	colorize	\
	iris		\
	movies		\
	objects		\
	ports		\
	rain		\
	recommenders	\
	scatter		\

INC_BASE    = $(HOME)/.local/share/make
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

# .PHONY: all
# all:
# 	for p in $(MODELS); do \
# 	  (cd $$p; make mlhub); \
# 	done

allclean: realclean
	for p in $(MODELS); do \
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
	for p in $(MODELS); do \
	  echo "==========> $$p <=========="; \
	  (cd $$p; make mlhub); \
	done

Packages.yaml: MLMODELS.yaml
	@python3 -c "import mlhub;\
                     mlhub.utils.gen_packages_yaml(\
                         mlmodelsyaml='MLMODELS.yaml',\
                         packagesyaml='Packages.yaml')"

Packages.html: pkgidx kwdidx.R pandoc.css Packages.yaml
	./pkgidx > $@

realclean::
	rm -f Packages.html Packages.rst Packages.yaml Packages.tbl Packages.url

allstatus:
	@for p in $(MODELS); do \
	  echo "==========> $$p <=========="; \
	  (cd $$p; make status \
		| grep -v '^git status' \
		| grep -v 'nothing to commit' \
		| grep -v -- '-----------------' \
		| egrep -v '^$$' \
		| egrep -v ' \(use ' \
		| grep -v 'Entering directory' \
		| grep -v 'Leaving directory' \
	  ); \
	done

allfetch:
	@for p in $(MODELS); do \
	  echo "==========> $$p <=========="; \
	  (cd $$p; git fetch); \
	done

allpush:
	@for p in $(MODELS); do \
	  echo "==========> $$p <=========="; \
	  (cd $$p; git push); \
	done

alldiff:
	@for p in $(MODELS); do \
	  echo "==========> $$p <=========="; \
	  (cd $$p; git diff); \
	done

allrebase:
	@for p in $(MODELS); do \
	  echo "==========> $$p <=========="; \
	  (cd $$p; git rebase); \
	done

