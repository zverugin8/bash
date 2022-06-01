#!/usr/bin/bash
sleep 100 &
qqq=$(ps -eo pid,cmd | grep sleep) ; echo $qqq ; echo ${#qqq}
IFS=' '
read -a strarr <<< "$qqq"
echo "There are ${#strarr[*]} words in the text."
for val in "${strarr[@]}";
do
  printf "$val\n"
done
jobs -l | grep "sleep 100" | awk '{print $2}'
kill ${strarr[0]}

