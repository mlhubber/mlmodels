########################################################################
# AIPack Dependency Script - assumes user has sudo access.

# Ubuntu: Tested on Azure 16.04 DLVM

sudo apt-get install -y wajig
wajig update
wajig distupgrade -y
wajig install -y python-opencv python-requests python-matplotlib python-scipy python-sklearn eog

# BEST WAY TO INSTALL CNTK - SYSTEM OR USER?

#
########################################################################
