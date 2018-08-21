#!/bin/sh

if [ ! -d models ]; then
  mkdir models
fi

if [ ! -f models/model.08-5.7380.hdf5 ]; then
  if [ ! -d ../.cache ]; then
    mkdir ../.cache
  fi
  if [ ! -f ../.cache/model.08-5.7380.hdf5 ]; then
    echo "Downloading the pre-built model itself (95M) which can take a minute or two..."
    wget --directory-prefix=../.cache https://github.com/foamliu/Simple-Colorization/releases/download/v1.0/model.08-5.7380.hdf5
    echo ""
  fi
  cp ../.cache/model.08-5.7380.hdf5 models/
fi

echo "Python dependencies include numpy, tensorflow, keras, opencv"


