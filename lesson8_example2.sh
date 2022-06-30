#!/usr/bin/bash
array=( "$@" )
arraylength=${#array[@]}
for (( i=0; i<${arraylength}; i++ ));
do
   echo "${array[$i]}"
done
