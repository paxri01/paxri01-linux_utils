#!/bin/bash
#
# DESCRIPTION: Script to display 256 colors with color code.
#
# Color display
X=0; X2=0

while [ $X -lt 255 ]; do
	while [ $X2 -lt 8 ]; do
	#while [ $X2 -lt 16 ]; do
		COUNT=$(printf "%.3d" "$X")
		echo -e "\033[38;5;${X}m ${COUNT}\033[0,00m \c"
		((X++))
		((X2++))
	done
	echo " "
	X2=0
done

echo -e "\n"

