#!/bin/bash


# Ubuntu: Tested on Azure 16.04 DLVM

sudo apt-get install -y wajig
wajig update
wajig distupgrade -y
wajig install -y python-opencv python-requests python-matplotlib python-scipy python-sklearn eog
