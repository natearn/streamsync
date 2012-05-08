#!/bin/sh

#TODO:
#	1. support file paths for $1
#	2. replace .* with appropriate part-file extensions
#	3. support arbitrary rsync options
#	4. use more efficient method of repeating the rsync command

while [ -e "$1".* ]; do
	rsync --inplace --progress "$1".* "$2"/"$1"
done
rsync --inplace --progress "$1" "$2"/"$1"
