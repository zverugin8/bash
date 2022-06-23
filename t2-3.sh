#!/usr/bin/bash
#function to format file to semicolon separated values
function format_file () {
  head -n 1 ./output.txt | sed 's/, /;/g'| sed -E -e 's/\[ | \]//g'  > ./out_1.txt
  tail -n+3 ./output.txt | head -n -2 | sed 's/not ok/false;/ # not ok to false
                                                  s/  */ /g
                                                  s/ok/true;/
                                                  s/), /);/
                                                  s/ \([0-9]\+\) /\1;/' > ./out_2.txt
  tail -n 1 ./output.txt | sed 's/ (of / success;/
                                      s/) tests passed/ total/
                                      s/tests failed/failed/
                                      s/ rated as / rating /
                                      s/\%//
                                      s/spent/duration/
                                      s/, /;/g' | \
                                      sed -r 's/([1-9]+) ([a-zA-Z]+)/\2 \1/g' > ./out_3.txt
}

#cfunction to convert formated body string to 1 json block
function json_body () {
  local name
  local status
  local duration
  name=$(echo "$*" | awk -F ";" '{print $3}')
  status=$(echo "$*" | awk -F ";" '{print $1}')
  duration=$(echo "$*" | awk -F ";" '{print $4}')
  printf -v var_test3 '%s{\n \"name\": '"\"$name\""',%s\n \"status\": '"$status"',\n%s \"duration\": '"\"$duration\""'\n}'
  echo "$var_test3"
}

format_file

function jbody_all () {
  # read body
  arr_b=()
  readarray -t arr_b < ./out_2.txt
  #interate body
  for((i=0;i<${#arr_b[@]};i++)); do
      if  (( i==(${#arr_b[@]}-1) )) ; then
      json_body ${arr_b[$i]}
      else echo "$(json_body ${arr_b[$i]})",
      fi
  done
}
#echo "$(json_body "${arr_b[0]}")",

function json_t () {
  local var1=()
  local var2=()
  local var3=()
  local var4=()
  var1=( $(awk -F ";" '{print $1}' ./out_3.txt) )
  var2=( $(awk -F ";" '{print $3}' ./out_3.txt) )
  var3=( $(awk -F ";" '{print $4}' ./out_3.txt) )
  var4=( $(awk -F ";" '{print $5}' ./out_3.txt) )
  #mapfile -d " " var1 <<< "$(awk -F ";" '{print $1}' ./out_3.txt)"
  #mapfile -d " " failed <<< $(awk -F ";" '{print $3}' ./out_3.txt)
  #mapfile -d " " rating <<< "$(awk -F ";" '{print $4}' ./out_3.txt)"
  #mapfile -d " " duration <<< "$(awk -F ";" '{print $5}' ./out_3.txt)"
  #s=$(echo ${success[1]})
  #echo "var1 is:${var1[1]}"qq
  #printf -v var_t '\"summary\":{\n\"'"${success[0]}"'\":'"${success[1]}"',\n}\n'
  printf -v var_t '\"summary\"{\n \"'${var1[0]}'\":'"${var1[1]}"',\n '\"${var2[0]}'\":'${var2[1]}',\n \"'${var3[0]}'\":'"${var3[1]}"',\n \"'${var4[0]}'\":'"${var4[1]}"'\n'}
  echo "$var_t"
}
jbody_all
json_t


#rm ./out_*.txt

function json_h () {
  local testName
  local tests=()
  testName="$(awk -F ";" '{print $1}' ./out_3.txt)"
  tests=( $(awk -F ";" '{print $2}' ./out_3.txt) )
  
}
json_h
