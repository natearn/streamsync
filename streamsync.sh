#!/bin/sh

# Description:
#   Creates a link to the file and then repeatedly calls rsync --inplace until
#   the link stops existing. This means that the only way to stop the script is
#   to either kill the process or delete the autogenerated hard link that it
#   depends on.

# OPTIONS can be any options string that would be passed to rsync. --inplace
# is enabled by default, and should be considered required for this script to
# be useful. OPTIONS must be quoted or it will be interpreted as streamsync
# options instead of rsync options.

# The proper way to terminate the script is with SIG_INT (ctrl-c). The script
# will clean-up the temporary link and exit gracefully. Alternatively, the
# user can simply delete the link file to achieve the same effect.

# If the user does not specify the destination file name, the link name will be
# used. There is enough information in that temporary name to work, but it wont
# look pretty.

USAGE='streamsync [-t TIMEOUT] [-o OPTIONS] FILE DEST'
if [ $# -lt 2 -o $# -gt 6 ]; then
	echo $USAGE && exit 1
fi

TIMEOUT=10
OPTIONS=""

while getopts ho:t: ARG; do
	case $ARG in
	h) echo $USAGE && exit 0 ;;
	o) OPTIONS=$OPTARG ;;
	t) TIMEOUT=$OPTARG ;;
	?) echo $USAGE; exit 1 ;;
	esac
done

shift $(( $OPTIND - 1 ))

FILE="$1"
BASE=`basename $FILE`
DEST="$2"

host="$(echo "$DEST" | cut -d ':' -f 1)"

if [ '!' "$host" = "$DEST" ]; then
	# We are copying to a remote location
	ssh -MNf -O "exit" "$host"
fi

STREAM=`mktemp --tmpdir streamsync.$BASE.XXXXX`
ln -f "$FILE" "$STREAM"
trap "rm $STREAM && exit 0" INT
while [ -e "$STREAM" ]; do
	rsync --inplace -t $OPTIONS "$STREAM" "$DEST"
	sleep $TIMEOUT
done
