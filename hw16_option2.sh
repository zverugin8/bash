#!/usr/bin/bash
#Tasks:
#- create a script that does the following:
#•	has a function that multiplies the argument passed to it by itself
#•	has a second function that passes each argument passed to the script to the first function and increases the result by 1 and outputs to the console

if [ -z "${1}" ]; then 
  echo "One option required!" # check arguments
  exit 1
fi
function mult() {
    local i=0
    local a
for a in "$@"; do #iterate arguments
    local i+=1
    local arr[$i]=$(($a*$a)) #multiplies arguments by itself
    #echo ${arr[i]}
done
echo ${arr[@]} # function output
} 
function addon() { #iterate arguments
 for a in "$@"; do
    arr2+=" "$((a+=1)) # add 1 to each arguments(imply mult-function result as argument)
    echo $a
done
#echo $arr2
}
#echo $(mult $@)
addon $(mult $@)