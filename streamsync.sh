#!/bin/sh

#TODO:
#	1. support file paths and names in all arguments
#	2. replace .* with a more specific list of extensions

while [ -e "$1" ]; do
	rsync --inplace --progress "$1" "$2"/"$1"
done
rsync --inplace --progress "$1" "$2"/"$1"
