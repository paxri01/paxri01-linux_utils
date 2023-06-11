#!/bin/bash
#
# DESCRIPTION: Script to upload audiobook file via sweech to Android phone.
#              The script will also check to see if the audiobook has already
#              been uploaded and when.
#
#              This is used in conjunction with a nautilus drop-in script.
#

inDir=$1

mapfile -t inFiles < <(find "$inDir" -type f -printf '%h/%f\n')

author=$(basename "${inFiles[0]}" | awk -F'( - )' '{ print $1 }')
bookName=$(basename "${inFiles[0]%%.info}" | awk -F'( - )' '{ print $3 }')

check=0
check=$(grep -c "$bookName" /var/log/ccab/uploaded.log)
if (( check > 0 )); then
  echo "This book has already been uploaded:"
  grep "$bookName" /var/log/ccab/uploaded.log | awk '/\[.*\]/ { print $1 }'
  echo -e "Continue? [y] \c"
  read -r ANS
  ANS=${ANS:-'y'}
  if [[ $ANS != y ]]; then
    echo "Aborting upload."
    exit 0
  fi
fi

if [[ $author == '' ]]; then
  echo -e "Enter author/artist name: \c"
  read -r author
fi

if [[ $(sweech ls | grep -c "$author") -eq 0 ]]; then
  echo "Creating author directory..."
  sweech mkdir "$author"
fi

echo "Copying files..."
sweech push "$inDir" "$author" >/dev/null 2>&1
STATUS=$?

if (( STATUS < 1 )); then
  echo "[$(date +%F)] $bookName" >> /var/log/ccab/uploaded.log
fi

