#!/bin/sh

#TODO: replace .* with a more specific list of extensions

while [ -e "$1".* ]; do
	rsync --inplace --progress "$1".* "$2"/`basename "$1"`
	sleep 10
done
rsync --inplace --progress "$1" "$2"/`basename "$1"`
