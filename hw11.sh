#!/bin/bash
su=0
re='^[0-9]+$'
for a in "$@"; do
if ! [[ $1 =~ $re ]]; 
   then echo "error: Not a number" >&2; echo $a; break ; 
fi
su=$(($su+$a))
done
avg=$(($su/$#))
echo "Sum:"$su
echo "Args number:"$#
echo "Result:" $avg

