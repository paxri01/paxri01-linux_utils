#!/bin/bash

# This script sorts the files in a directory by their prefix.

baseDir='/data2/usenet/renamed/restricted'
rename=$1
inDir=${2:-2024}

C0=$(printf '\033[0;00m')
C1=$(printf '\033[38;5;040m')  # Green
C2=$(printf '\033[38;5;184m')  # Yellow
C3=$(printf '\033[38;5;160m')  # Red
C4=$(printf '\033[38;5;240m')  # Light Gray

cd "$baseDir/$inDir" || exit
rename '.1080p' '' ./*
rename '.720p' '' ./*
rename '.30fps' '' ./*
cd "$baseDir" || exit

moveIt()
{
    inFile="$1"
    outDir="$2"

    echo -e "${C0}$inFile${C1} => $baseDir/$outDir/${C0}"
    if [[ -n $rename ]]; then
      mkdir -p "$baseDir/$outDir" >/dev/null 2>&1
      mv "$baseDir/$inDir/$inFile"  "$baseDir/$outDir/"
    fi
}

mapfile -t inFile < <(find "$baseDir/$inDir/" -type f -printf '%f\n' | sort)

for file in "${inFile[@]}"; do
  if grep -q '^teenpies\|^perfect18\|^18lust\|^teen' <<< "$file"; then
    moveIt "$file" "teens"
  elif grep -q '^lustery' <<< "$file"; then
    moveIt "$file" "lustery"
  elif grep -q '^ladyvoyeurs' <<< "$file"; then
    moveIt "$file" "voyeurs"
  elif grep -q '^eroticax' <<< "$file"; then
    moveIt "$file" "eroticax"
  elif grep -q '^sexart' <<< "$file"; then
    moveIt "$file" "artful/sexart"
  elif grep -q '^metart' <<< "$file"; then
    moveIt "$file" "artful/metart"
  elif grep -q '^frolicme' <<< "$file"; then
    moveIt "$file" "frolicme"
  elif grep -q '^sharemybf' <<< "$file"; then
    moveIt "$file" "threesomes"
  elif grep -q '^nubile' <<< "$file"; then
    moveIt "$file" "nubile"
  elif grep -q '^perfectgirlfriend' <<< "$file"; then
    moveIt "$file" "perfectgirlfriend"
  elif grep -q '^freeuse' <<< "$file"; then
    moveIt "$file" "freeuse"
  elif grep -q '^onlyfans' <<< "$file"; then
    moveIt "$file" "onlyfans.zzz"
  elif grep -q '^stepsiblingscaught\|^myfamilypies\|^family\|^brattysis\|^sislovesme' <<< "$file"; then
    moveIt "$file" "taboo"
  elif grep -q '^mysistershotfriend' <<< "$file"; then
    moveIt "$file" "taboo"
  elif grep -q '^iknowthatgirl' <<< "$file"; then
    moveIt "$file" "amateur/iknowthatgirl"
  elif grep -q '^dateslam' <<< "$file"; then
    moveIt "$file" "amateur/dateslam"
  elif grep -q 'cfnm' <<< "$file"; then
    moveIt "$file" "cfnm"
  elif grep -q 'nuru' <<< "$file"; then
    moveIt "$file" "massage/nurumassage"
  elif grep -q 'creampie' <<< "$file"; then
    moveIt "$file" "cream"
  elif grep -q '^wank\|handjob' <<< "$file"; then
    moveIt "$file" "jerk"
  elif grep -q '^hucow\|lactat' <<< "$file"; then
    moveIt "$file" "lactate"
  elif grep -q 'massage' <<< "$file"; then
    moveIt "$file" "massage"
  elif grep -q 'threesome' <<< "$file"; then
    moveIt "$file" "threesomes"
  elif grep -q 'stepsister\|step\|taboo' <<< "$file"; then
    moveIt "$file" "taboo"
  elif grep -q 'amateur' <<< "$file"; then
    moveIt "$file" "amateur"
  else
    if [[ -z $rename ]]; then
      echo -e "$file ${C4}(no match)${C0}"
    fi
  fi
done
