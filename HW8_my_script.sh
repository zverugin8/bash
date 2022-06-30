#!/usr/bin/bash
ar1=("$@")
num=${#ar1[@]}
if [[ $num -lt 2 ]]; then echo ${ar1[@]}
elif [[ $num -gt 2 ]] && [[ $num -lt 4 ]]; then echo ${ar1[$num-1]}
else echo "Invalid number of arguments"
fi


