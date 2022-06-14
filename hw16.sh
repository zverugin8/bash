#!/usr/bin/bash
function mult() {
    local i=0
    local a
for a in "$@"; do
    #echo $a;
    i+=1
    arr[$i]=$(($a*$a))
    #echo ${arr[i]}
done

} 
function addon() {
if [ -z "${1}" ]; then 
  echo "One option required!"
  exit 1
fi
 mult $@
 echo "arr0 is:"${arr[@]}
 for a in "${arr[@]}"; do
    arr2+=" "$((a+=1))
done
echo $arr2
}
addon $@