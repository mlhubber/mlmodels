########################################################################
#
# Generic Makefile
#
# Time-stamp: <Tuesday 2022-04-26 09:53:38 +1000 Graham Williams>
#
# Copyright (c) Graham.Williams@togaware.com
#
# License: Creative Commons Attribution-ShareAlike 4.0 International.
#
########################################################################

# App version numbers
#   Major release
#   Minor update
#   Trivial update or bug fix

APP=mlhub-testing
VER=0.0.1
DATE=$(shell date +%Y-%m-%d)

########################################################################
# Supported Makefile modules.

# Often the support Makefiles will be in the local support folder, or
# else installed in the local user's shares.

INC_BASE=support
INC_BASE=$(HOME)/.local/share/make

# Specific Makefiles will be loaded if they are found in
# INC_BASE. Sometimes the INC_BASE is shared by multiple local
# Makefiles and we want to skip specific makes. Simply define the
# appropriate INC to a non-existant location and it will be skipped.

INC_DOCKER=skip

# Load any modules available.

INC_MODULE=$(INC_BASE)/modules.mk

ifneq ("$(wildcard $(INC_MODULE))","")
  include $(INC_MODULE)
endif

########################################################################
# HELP
#
# Help for targets defined in this Makefile.

define HELP
MLHub Testing:

  test	Run all tests for all models.

Specific model tests currently supported:

  plantdis
  rembg

endef
export HELP

help::
	@echo "$$HELP"

########################################################################
# LOCAL TARGETS

test: plantdis rembg

# PLANTDIS
#
# 20220426 Ugly stderr messages
# 20220426 File location logic is bad

plantdis:
	ml install   spsaswat/plantdis # NEED TO CURATE INTO MLHUB
	ml configure plantdis
	ml readme    plantdis
	ml commands  plantdis
	ml demo      plantdis 2>/dev/null # NEED TO FIX MESSAGES
	ml diagnose plantdis leaf.jpg 2>/dev/null # NEED TO FIX MESSAGES
	ml diagnose plantdis --view leaf.jpg 2>/dev/null # NEED TO FIX MESSAGES
	ml diagnose plantdis leaf.jpg  2>/dev/null |\
	    sed 's|,|: |' |\
	    xargs -I % convert leaf.jpg -draw "text 0,10 '%'" annotated.jpg
	display annotated.jpg

# REMBG
#
# 20220426 Download is failing

rembg:
	ml install   StafferOliver/rembg
	ml rename    rembg u2net
	ml configure u2net
	ml readme    u2net
	ml commands  u2net
	ml demo      u2net
