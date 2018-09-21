#!/bin/bash

sudo apt-get install libv8-dev
sudo apt-get install python-pip
sudo pip install --upgrade pip

conda create --name r-tensorflow python=2.7
source activate r-tensorflow
pip install --ignore-installed --upgrade tensorflow
conda install -c conda-forge keras

pip install Image
