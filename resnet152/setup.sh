#! /bin/bash
#
# Setup the model package. This is not required for the user
# deployment but included in the model package for reference. It can
# be run multiple times without issue.

########################################################################
# Resources

dr="resources"
if [ ! -d ${dr} ]; then
  echo "Obtain ${dr}..."
  mkdir ${dr}
fi

pushd ${dr}

if [ ! -f resnet_v1_152.ckpt ]; then
  echo "Download the model checkpoint..."
  wget http://download.tensorflow.org/models/resnet_v1_152_2016_08_28.tar.gz
  tar xvf resnet_v1_152_2016_08_28.tar.gz
  rm resnet_v1_152_2016_08_28.tar.gz
fi

if [ ! -f synset.txt ]; then
  echo "Download the synset for the model to translate model output to a specific label..."
  wget "http://data.dmlc.ml/mxnet/models/imagenet/synset.txt"
fi

popd

########################################################################
# Images

dr="images"
if [ ! -d ${dr} ]; then
  echo "Obtain ${dr}..."
  mkdir ${dr}
fi

pushd ${dr}

img="lynx.jpg"
if [ ! -f ${img} ]; then
  echo "... ${img}"
  wget -O ${img} https://upload.wikimedia.org/wikipedia/commons/thumb/6/68/Lynx_lynx_poing.jpg/220px-Lynx_lynx_poing.jpg
fi

img="sportscar.jpg"
if [ ! -f ${img} ]; then
  echo "... ${img}"
  wget -O ${img} 'https://upload.wikimedia.org/wikipedia/commons/3/3a/Roadster_2.5_windmills_trimmed.jpg'
fi

img="ship.jpg"
if [ ! -f ${img} ]; then
  echo "... ${img}"
  wget -O ${img} 'http://www.worldshipsociety.org/wp-content/themes/construct/lib/scripts/timthumb/thumb.php?src=http://www.worldshipsociety.org/wp-content/uploads/2013/04/stock-photo-5495905-cruise-ship.jpg&w=570&h=370&zc=1&q=100'
fi

img="croc.jpg"
if [ ! -f ${img} ]; then
  echo "... ${img}"
  wget -O ${img} 'http://yourshot.nationalgeographic.com/u/ss/fQYSUbVfts-T7pS2VP2wnKyN8wxywmXtY0-FwsgxpiZv_E9ZfPsNV5B0ER8-bOdruvNfMD5EbP4SznWz4PYn/'
fi

img="tarsier.jpg"
if [ ! -f ${img} ]; then
  echo "... ${img}"
  wget -O ${img} 'https://cdn.arstechnica.net/wp-content/uploads/2012/04/bohol_tarsier_wiki-4f88309-intro.jpg'
fi

img="robin.jpg"
if [ ! -f ${img} ]; then
  echo "... ${img}"
  wget -O ${img} 'http://i.telegraph.co.uk/multimedia/archive/03233/BIRDS-ROBIN_3233998b.jpg'
fi

popd
