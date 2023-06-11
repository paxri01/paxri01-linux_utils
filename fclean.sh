#!/bin/bash

INFILES=''
LC='false'
RENAME='false'

usage()
{
  cat <<EOF
DESCRIPTION
    This script will rename files based on following.  Note if no file is
    supplied, will process all files in current directory.

SYNOPSIS
    fclean [OPTION]... [FILENAME]

OPTIONS
    --lc              Lowercase filename and replace spaces with periods.
    -r  |  --rename   Rename the files versus just display rename change.
    --help            Print this message and exit.

EOF
}

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --lc) # lowercase filename and replace spaces with '.'s
      LC='true'
      shift
      ;;
    -r | --rename) # rename files.
      RENAME='true'
      shift
      ;;
    --help) # display help.
      usage
      exit 0
      ;;
    *) # Define single file to process if supplied.
      INFILES="$1"
      shift
      ;;
  esac
done

if [[ -z $INFILES ]]; then
  mapfile -t INFILES < <(find . -maxdepth 1 -type f)
fi

i=0
while [[ $i -lt ${#INFILES[*]} ]]; do
  #echo "File$((i+1)) = ${INFILES[$i]}"
  EXTENSION[$i]=${INFILES[$i]##*.}
  BASENAME[$i]=$(basename "${INFILES[$i]%.*}")
  #echo "  Basename$((i+1)) = ${BASENAME[$i]}"
  #echo "  Extension$((i+1)) = ${EXTENSION[$i]}"
  #echo "  Dirname$((i+1)) = $(dirname "${INFILES[$i]}")"
  echo "Infile$((i+1))  = ${BASENAME[$i]}.${EXTENSION[$i]}"
  #shellcheck disable=SC2001
  OUTFILE[$i]=$(sed -E 's/\(official.*video\)//I
    s/youtube//I
    s/redtu.*//I
    s/free stock//I
    s/dream.ticket//I
    s/[ \.]xerotica.*//I
    s/[ \.]xvideos.*//I
    s/[ \.]free porn.*//I
    s/[ \.]sexy videos.*//I
    s/[ \.]xnxx.*//I
    s/[ \.]1080p//I
    s/[ \.]720p//I
    s/[ \.]x26[45]//I
    s/ $//
    s/!//
    s/  / /
    s/\.\./\./
    s/\.$//
    s/ ·$//
    s/ -$//' <<< "${BASENAME[$i]}") 
  if [[ $LC != false ]]; then
    OUTFILE[$i]=$(tr '[:upper:]' '[:lower:]' <<< "${OUTFILE[$i]}" | tr ' ' '.')
  fi
  echo "Outfile$((i+1)) = ${OUTFILE[$i]}.${EXTENSION[$i]}"
  echo ""
  ((i++))
done

if [[ $RENAME == 'true' ]]; then
  i=0
  while [[ $i -lt ${#INFILES[*]} ]]; do
    _INFILE="${BASENAME[$i]}"
    _OUTFILE="${OUTFILE[$i]}"
    if [[ "$_INFILE" != "${_OUTFILE}" ]]; then
      mv "${INFILES[$i]}" "${OUTFILE[$i]}.${EXTENSION[$i]}"
    else
      echo "skipping, no rename needed."
    fi
    ((i++))
  done
fi
