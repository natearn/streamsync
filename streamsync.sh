#!/bin/sh

# streamsync [OPTIONS] FILE LOCATION
# calls 'rsync --inplace OPTIONS FILE LOCATION' repeatedly until FILE stops being modified

#TODO: replace .* with a more specific list of extensions

# handling temporary file extensions should be optional, not assumed

OPTIONS="$1"
FILE="$2"
LOCATION="$3"
FILE_INFO=""
TIMEOUT="${4-10}" # if the third argument is empty, default to 10

# if $2 does not exist, look for $2.* (chrome uses .crdownload, firefox uses .part, etc.) 
# this needs to be more specific
if [! -e "$FILE" ]; then
	FILE="$2".*
fi

# what happens when a temporary file is deleted?
while [ "$FILE_INFO" = `ls -l $FILE` ]; do
	FILE_INFO=`ls -l $FILE`
	rsync --inplace "$OPTIONS" "$FILE" "$LOCATION"
	sleep $TIMEOUT
done
