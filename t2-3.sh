#!/usr/bin/bash

#function to format text file to semicolon separated values and split it to 3 temp files
function format_file () {
  sed -i '/^$/d' $1 # remove empty newlines
  head -n 1 $1 | sed 's/, /;/g'| sed -E -e 's/\[ | \]//g'  > ./out_1.tmp
  tail -n+3 $1 | head -n -2 | sed 's/not ok/false;/ # not ok to false
                                                  s/  */ /g
                                                  s/ok/true;/
                                                  s/), /);/
                                                  s/ \([0-9]\+\) /\1;/' > ./out_2.tmp
  tail -n 1 $1 | sed 's/ (of / success;/
                                      s/) tests passed/ total/
                                      s/tests failed/failed/
                                      s/ rated as / rating /
                                      s/\%//
                                      s/spent/duration/
                                      s/, /;/g' | \
                                      sed -r 's/([1-9]+) ([a-zA-Z]+)/\2 \1/g' > ./out_3.tmp
}

#function to convert formated body string to one json block
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

#Generate full body json block
function jbody_all () {
  # read body
  arr_b=()
  readarray -t arr_b < ./out_2.tmp #read file body to array
  #interate body
  for((i=0;i<${#arr_b[@]};i++)); do
      if  (( i==(${#arr_b[@]}-1) )) ; then
      json_body ${arr_b[$i]}                 # if last line - write without comma
      else echo "$(json_body ${arr_b[$i]})", #convert text body line to json block
      fi
  done
}

#Generate summary json block
function json_t () {
  local var1=()
  local var2=()
  local var3=()
  local var4=()
  var1=( $(awk -F ";" '{print $1}' ./out_3.tmp) ) #success, arr: name=value
  var2=( $(awk -F ";" '{print $3}' ./out_3.tmp) ) #failed, arr: name=value
  var3=( $(awk -F ";" '{print $4}' ./out_3.tmp) ) #rating, arr: name=value
  var4=( $(awk -F ";" '{print $5}' ./out_3.tmp) ) #duration, arr: name=value
  printf -v var_t '\"summary\":{\n \"'${var1[0]}'\":'"${var1[1]}"',\n '\"${var2[0]}'\":'${var2[1]}',\n \"'${var3[0]}'\":'"${var3[1]}"',\n \"'${var4[0]}'\":'\""${var4[1]}"'\"\n'}
  echo "$var_t"
}

#create json header and generate full output in json format
function json_h () {
  local testName_v
  local tests=()
  testName_v="$(awk -F ";" '{print $1}' ./out_1.tmp)" #get test name field
  tests=( $(awk -F ";" '{print $2}' ./out_1.tmp) )    #just get "test" field from txt header
  printf "{\n\"testName\":%s\n\"${tests[1]}\":%s\n" "\"$testName_v\"," "["   # generate json header and array begin symbol "["
  jbody_all
  printf "]%s\n" "," # close array
  json_t # summary block
  printf "%s\n" "}" #close json
}

#analize input file and generate output file full path
function out_file () {
  local full_name
  local pth
  local f_file
  local s_file
  local out_fl
  full_name="$1"
  pth=${full_name%/*} # get full path
  f_file=${full_name##*/} # get full name
  s_file=${f_file%.*} # get file name withot extension
  out_fl=$pth"/"$s_file".json" # generate output file name with path
  #echo pth $pth
  #echo f_file: $f_file
  #echo s_file : $s_file
  echo "$out_fl"
}

# arg check
if [[ -z $1 ]]; then echo "Input file required" ; exit 1 ; fi # no arg or incorect arg = exit 1
if ! [ -f $1 ]; then echo "File $1 not exist" ; exit 1 ; fi # no arg or incorect arg = exit 1

#user inform messages
out_fl=$(out_file "$1")
echo "Input  file: $1"
echo "Output file: $out_fl"

format_file "$1"
json_h > "$out_fl" # all blocks to output file
rm ./out_*.tmp

# tested at Linux 5.10.102.1-microsoft-standard-WSL2 #1 SMP Wed Mar 2 00:30:59 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
