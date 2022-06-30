#!/usr/bin/bash
function fixit() {      #Fix names, generate e-mails without doubles check
    local id=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $1}' <<<"$*") #select id colunm
    local location_id=$(awk -F "," '{print $2}' <<< "$@") # select location_id colunm
    local name=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $3}' <<<"$*") # select name colunm
    local name=( ${name[@],,} ) # create array from name-surname and full name to lower
    #local name=${name[@]^} # capitalize name first letter
    local name=$(echo "${name[@]}" |sed -r 's/\b(.)/\u\1/g')
    local title=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $4}' <<<"$*") # Title,comma inside quotes. Regex: not comma+(one or more times) OR quote-not quote+-quote
    local em_fl=$(echo ${name[0]} | cut -c 1-1 | tr "[:upper:]" "[:lower:]") # prepare create e-mail, got name first letter and to lowercase it
    local em_sur=$(echo ${name[1]}| tr "[:upper:]" "[:lower:]") # got surename and to lower it
    #local email=$em_fl$em_sur$location_id"@abc.com" # create e-mail column
    local email=$em_fl$em_sur$"@abc.com" # create e-mail column
    local department=$(awk -F "," '{print $6}' <<<"$*") # got department column
    local res_ln="$id,$location_id,$name,$title,$email,$department" # put all column into string (line)
    echo "$res_ln" # function output
}

function fixit1() {     #Generate string for e-mail dubles (add location_id to email_name)
    local id=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $1}' <<<"$*") #select id colunm
    local location_id=$(awk -F "," '{print $2}' <<< "$@") # select location_id colunm
    local name=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $3}' <<<"$*") # select name colunm
    local name=( ${name[@],,} ) # create array from name-surname and full name to lower
    local name=${name[@]^} # capitalize name first letter
    local title=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $4}' <<<"$*") # Title,comma inside quotes. Regex: not comma+(one or more times) OR quote-not quote+-quote
    local em_fl=$(echo ${name[0]} | cut -c 1-1 | tr "[:upper:]" "[:lower:]") # prepare create e-mail, got name first letter and to lowercase it
    local em_sur=$(echo ${name[1]}| tr "[:upper:]" "[:lower:]") # got surename and to lower it
    local email=$em_fl$em_sur$location_id"@abc.com" # create e-mail column
    #local email=$em_fl$em_sur$"@abc.com" # create e-mail column
    local department=$(awk -F "," '{print $6}' <<<"$*") # got department column
    local res_ln="$id,$location_id,$name,$title,$email,$department" # put all column into string (line)
    echo "$res_ln" # function output
}

#analize input file and generate output file full path
function out_file () {
  local full_name
  local pth
  local f_file
  local s_file
  local out_fl
  full_name="$1"
  #pth=${full_name%/*} # get input file full path
  pth=$(dirname "$full_name")
  f_file=${full_name##*/} # get input file full name
  s_file=${f_file%.*} # get input file name withot extension
  out_fl=$pth"/"$s_file"_new.csv" # generate output file name with path
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
if [[ -z $1 ]]; then echo "Input file required"; exit 1 # check args
fi
head $1 -n 1 >"$out_fl" # create new file with original header

arr_csv=()
while IFS= read -r line
do
    arr_csv+=("$line")
done <<< "$(cat "$1"|sed 1d)" #read arg(file) to array without (header)-first line


len_i=${#arr_csv[@]}
for ((i=0;i<len_i;i++)); do
    arr_csv[$i]=$(fixit "${arr_csv[i]}") # generate array with main changes without doubles-email check
done


len_n=$((${#arr_csv[@]}-1))
#echo "n:$len_n"
len_m=${#arr_csv[@]}
#echo "m:$len_m"
dupl_str=""
for((i=0;i<len_n;i++)); do
  em_o="$(echo "${arr_csv[$i]}" | awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $5}')" # get e-mail_1 for compare
  #echo "em_o:$em_o"
  flag=0
  if [[ ! "${dupl_str[*]}" =~ $i ]] ; then
    for((j=((i+1));j<len_m;j++ )); do
      #echo "i:${i}, j:${j}"
      #echo ${arr_csv[$j]}
      em_c="$(echo "${arr_csv[$j]}" | awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $5}')" # get e-mail_2 for compare
      if [[ "$em_o" == "$em_c" ]]; then   #if em1=em2(em_o=em_c) - mark index as doubled
        dupl_str+="$j "                   #if em1=em2(em_o=em_c) - mark index as doubled
        flag=1                            # didnt forget fix em_o
        arr_csv[$j]=$(fixit1 "${arr_csv[j]}") # fix em_c
      fi
      #echo "em_c:$em_c"
  done #for j
  fi # if dupl
 if [[ $flag == 1 ]]; then
       dupl_str+="$i "
       arr_csv[$i]=$(fixit1 "${arr_csv[i]}") #fix em_o
      fi
 flag=0
done #for i
#echo "dubl_str:$dupl_str"


for record in "${arr_csv[@]}" # interate array
do
   echo "$record" >> "$out_fl"  # output double-fixed array to disk per line
done
#Script tested on Linux DESKTOP-45QSS3V 5.10.16.3-microsoft-standard-WSL2 #1 SMP Fri Apr 2 22:23:49 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
