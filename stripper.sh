#!/bin/bash

# DESCRIPTION: Script to strip all but title and artist tags from .mp3 files in the 
#              current directory.  It will also rename the files as:
#              (<ARTIST>) - <TRACK>.mp3

mapfile -t inFiles < <(find . -type f -iname '*.mp3' -printf '%h/%f\n')

i=0
while (( i < ${#inFiles[*]} )); do
  inFile="${inFiles[$i]}"
  echo "Clearing ID3 tags..."
  mid3v2 --delete-frames=TALB,TCON,TENC,TLEN,TRCK,TYER,MCDI,COMM,TDRC,WCOM,TPUB,TPE2,TSSE,TXXX "${inFiles[$i]}"
  ARTIST=$(mid3v2 -l "${inFiles[$i]}" | grep 'TPE1' | awk -F= '{ print $2 }')
  TRACK=$(mid3v2 -l "${inFiles[$i]}" | grep 'TIT2' | awk -F= '{ print $2 }')
  if [[ -z $ARTIST ]] || [[ -z $TRACK ]]; then
    echo "inFile: $inFile"
    _ARTIST=$(awk -F'[()]' '{ print $2 }' <<< "$inFile")
    echo -e "Enter artist name: ${_ARTIST}\c"
    read -r ARTIST
    ARTIST=${ARTIST:-$_ARTIST}
    _TRACK=$(awk -F. '{ print $1 }' <<< "${inFile##*- }")
    echo -e "Enter track title: ${_TRACK}\c"
    read -r TRACK
    TRACK=${TRACK:-$_TRACK}
    echo "Creating ID3 tags..."
    mid3v2 -a "$ARTIST" -t "$TRACK" "$inFile"
  fi
  outFile="(${ARTIST/\//-}) - ${TRACK}.mp3"
  if [[ ! -f "$outFile" ]]; then
    echo "Renaming file $inFile"
    mv "${inFiles[$i]}" "$outFile"
  else
    echo "Skipping ${outFile}"
  fi
  ((i++))
done

