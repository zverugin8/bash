#!/usr/bin/bash
if [[ -z $1 ]]; then arg1="qwerty"
else arg1=$1
fi
num=${#arg1}
#echo $num
if [[  $(($num%2)) -eq 1 ]]; then echo "Odd"
else echo "Even"
fi
#echo $?
