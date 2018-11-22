########################################################################
#
# Makefile template for Version Control - git
#
# Copyright 2018 (c) Graham.Williams@togaware.com
#
# License: Creative Commons Attribution-ShareAlike 4.0 International.
#
########################################################################

define GIT_HELP
GIT Version Control:

  info	  Identify the git repository;
  status  Status listing untracked files;
  qstatus A quieter status ignoring untracked files;
  push
  pull
  master  Checkout the master branch;
  dev     Checkout the dev branch;
  log
  flog	  Show the full log;
  diff
  vdiff	  Show a visual diff using meld.

endef
export GIT_HELP

########################################################################
#
# Using git - see https://gist.github.com/Chaser324/ce0505fbed06b947d962
#
# On github click Fork on the original repository
# Clone your fork to your local machine
#   $ git clone git@github.com:gjwgit/pname.git
#   $ cd pname
# Add 'upstream' repo to list of remotes
#   $ git remote add upstream https://github.com/UPSTREAM-USER/ORIGINAL-PROJECT.git
# Verify the new remote named 'upstream'
#   $ git remote -v
# Fetch from upstream remote
#   $ git fetch upstream
# View all branches, including those from upstream
#   $ git branch -va
# Checkout your master branch and merge upstream
#   $ git checkout master
#   $ git merge upstream/master
# Checkout the master branch - you want your new branch to come from master
#   $ git checkout master
# Create a new branch named newfeature (give your branch its own simple informative name)
#   $ git branch newfeature
# Switch to your new branch
#   $ git checkout newfeature
# DO YOUR WORK
# Fetch upstream master and merge with your repo's master branch
#   $ git fetch upstream
#   $ git checkout master
#   $ git merge upstream/master
# If there were any new commits, rebase your development branch
#   $ git checkout newfeature
#   $ git rebase master
# Rebase all commits on your development branch
#   $ git checkout 
#   $ git rebase -i master
# On github change to branch and click Pull Request

help::
	@echo "$$GIT_HELP"

info:
	@echo "-------------------------------------------------------"
	git config --get remote.origin.url
	@echo "-------------------------------------------------------"

status:
	@echo "-------------------------------------------------------"
	git status
	@echo "-------------------------------------------------------"

qstatus:
	@echo "-------------------------------------------------------"
	git status --untracked-files=no
	@echo "-------------------------------------------------------"

push:
	@echo "-------------------------------------------------------"
	git push
	@echo "-------------------------------------------------------"

pull:
	@echo "-------------------------------------------------------"
	git pull
	@echo "-------------------------------------------------------"

master:
	@echo "-------------------------------------------------------"
	git checkout master
	@echo "-------------------------------------------------------"

dev:
	@echo "-------------------------------------------------------"
	git checkout dev
	@echo "-------------------------------------------------------"

log:
	@echo "-------------------------------------------------------"
	git --no-pager log --stat --max-count=10
	@echo "-------------------------------------------------------"

flog:
	@echo "-------------------------------------------------------"
	git --no-pager log
	@echo "-------------------------------------------------------"

diff:
	@echo "-------------------------------------------------------"
	git --no-pager diff --color
	@echo "-------------------------------------------------------"

vdiff:
	git difftool --tool=meld
