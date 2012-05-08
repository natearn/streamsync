#!/bin/sh

while [ -e "$1".* ]; do
	rsync --inplace --progress "$1".* "$2"/"$1"
done
rsync --inplace --progress "$1" "$2"/"$1"
