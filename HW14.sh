#!/usr/bin/bash
i=0
for a in "$@"; do
i=$(($i + 1))
echo "Arg$i: "$a
done

for ((j=1; j <= $#; j++))
    do  
       # gcc -o "$2" "${!i}"
       n=$(($j+1))
       if [[ $n -gt $# ]]; then n=1
       else n=$(($j+1))
       fi
       #echo $(( ${!j} + ${!n} ))
       res=$res" "$(( ${!j} + ${!n} ))
    done
    echo $res



