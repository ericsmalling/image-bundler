#!/bin/bash

# read tgz file as first argument and validate it exists
if [ -z "$1" ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

if [ ! -f "$1" ]; then
  echo "File not found: $1"
  exit 1
fi

# make temp directory
TIMESTAMP=$(date +%s)
mkdir $TIMESTAMP

# extract the tgz file into the temp directory
tar -C $TIMESTAMP -xzf $1

# loop through the files in the temp directory and load them into docker
for file in $TIMESTAMP/*; do
  echo "Loading $file"
  docker load -i $file
done

# ask if the user wants to delete the temp directory, defaulting to yes
read -p "Delete temp directory? [Y/n] " -n 1 -r
echo