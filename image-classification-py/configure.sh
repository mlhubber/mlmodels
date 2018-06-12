#!/bin/bash


# Ubuntu: Tested on Azure 16.04 DLVM

sudo apt-get install -y wajig
wajig update
wajig distupgrade -y
wajig install -y keras
