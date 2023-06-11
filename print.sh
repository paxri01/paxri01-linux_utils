#!/bin/bash
#
# DESCRIPTION: Sample script to right justify statuses with variable line lengths.

C1='\033[38;5;040m'  # Green
C2='\033[38;5;243m'  # Grey
C3='\033[38;5;254m'  # White
C4='\033[38;5;184m'  # Yellow
C5='\033[38;5;160m'  # Red
C6='\033[38;5;165m'  # Purple
C0='\033[0;00m'      # Reset

## # Display a 256 color grid
## X=0; X2=0
## while [ $X -lt 255 ]; do
##    while [ $X2 -lt 8 ]; do
##       COUNT=$(printf "%.3d" "$X")
##       echo -e "\033[38;5;${X}m ${COUNT}\033[0,00m \c"
##       ((X++))
##       ((X2++))
##    done
##    echo " "
##    X2=0
## done
## echo -e "\n"

pad=$(printf '%0.1s' "."{1..80})
padlength=80
text=( file_name-1 file_name_two file_three null )
msgOkay="${C1}  OK  ${C0}"
msgWarn="${C4} WARN ${C0}"
msgErr="${C5}ERROR!${C0}"
adjust="${C1}${C0}"
interval=.5
rPID=""
# i=0


# Display ruler
echo "0++++++++1+++++++++2+++++++++3+++++++++4+++++++++5+++++++++6+++++++++7+++++++++8"

## pad=$(printf '%0.1s' "."{1..80})
## padlength=80
## string2='bbbbbbb'
## for string1 in ${text[*]}
## do
##    printf '%s' "$string1"
##    printf '%*.*s' 0 $((padlength - ${#string1} - ${#string2} )) "$pad"
##    printf '%s\n' "$string2"
##    string2=${string2:1}
## done

displayIt ()
{

   Text1=$1
   Text2=$2

   if (( $# > 1 )); then
      printf "${C2}$Text1${C0} ${C3}$Text2${C0}"
      printf '%*.*s' 0 $((padlength - ${#Text1} - ${#Text2} - 7 )) "$pad"
   else
      printf "${C2}${Text1}${C0}"
      printf '%*.*s' 0 $((padlength - ${#Text1} - 6 )) "$pad"
   fi
   #   printf "[${flag}]\n"
   rotate &
   rPID=$!
   return 0
}

rotate ()
{

   while : 
   do
      tput civis
      ((z++))
      case $z in
         "1") echo -e "-\b\c"
            sleep $interval
            ;;
         "2") echo -e '\\'"\b\c"
            sleep $interval
            ;;
         "3") echo -e "|\b\c"
            sleep $interval
            ;;
         "4") echo -e "/\b\c"
            sleep $interval
            ;;
         *) z=0 ;;
      esac
   done
}

killWait ()
{

   FLAG=$1

   kill -9 $rPID
   wait $rPID 2>/dev/null
   echo -e "\b\b\c"
   tput cnorm

   case $FLAG in
      "0") echo -e "[${C1}  OK  ${C0}]"
         ;;
      "1") echo -e "[${C5}ERROR!${C0}]"
         ;;
      "2") echo -e "[${C4} WARN ${C0}]"
         ;;
      *) echo -e "[${C6}UNKWN!${C0}]"
         ;;
   esac
   return 0
}


## # Method #1
## i=0
## while (( i < ${#text[*]} )); do
##    printf "${C2}${text[$i]}${C0}"
##    # Need hard adjustment for color code escape code.
##    printf '%*.*s' 0 $((padlength - ${#text[$i]} - ${#msgOkay} + ${#adjust} - 2 )) "$pad"
##    printf "[${msg1}]\n"
##    ((i++))
## done
## 
## # Method #2
## i=0
## while (( i < ${#text[*]} )); do
##    printf "text: ${C2}%-40s${C0} [${C1}  OK  ${C0}]\n" ${text[$i]}
##    printf "text: ${C2}%-40s${C0} [${C4} WARN ${C0}]\n" ${text[$i]}
##    printf "text: ${C2}%-40s${C0} [${C5}ERROR!${C0}]\n" ${text[$i]}
##    ((i++))
## done

displayIt "Processing file:" "xxxxxx.zzz"
sleep 5
killWait 0 # 0 = Okay


displayIt "Processing file:" "yyyyy.vv"
sleep 5
killWait 2 # 2 = Warning

displayIt "Processing file:" "uuuuuuu.wwwww"
sleep 5
killWait 1 # 1 = Error

displayIt "This is a lot of text on the line, but should be okay."
sleep 3
killWait 4 # 4+ = Undeclared


