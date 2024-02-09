#!/bin/bash

#read input file from command line or default to images.txt
if [ -z "$1" ]; then
  FILE="images.txt"
else
  FILE=$1
fi

# make temp directory 
TIMESTAMP=$(date +%s)
mkdir $TIMESTAMP

# read list of container images from file
while read image; do
  echo "Processing $image"
  # pull the image
  docker pull $image
  # make image into a filename safe string
  imagefile=$(echo $image | tr / _)
  # save the image to a tar file
  docker save $image -o $TIMESTAMP/$imagefile.tar
done < $FILE

# tar up the contents of the temp directory without including the TIMESTAMP directory itself
tar -C $TIMESTAMP -czf $FILE-bundle.tgz .
