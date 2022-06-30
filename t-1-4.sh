#!/usr/bin/bash

function fixit1() {
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


arr_csv1=()
while IFS= read -r line
do
    arr_csv1+=("$line")
done <<< "$(cat ./account_new.csv | sed 1d)" #read arg(file) to array without first line (header)
echo "${arr_csv1[@]}"



len_n=$((${#arr_csv1[@]}-1))
echo "n:$len_n"
len_m=${#arr_csv1[@]}
echo "m:$len_m"
dupl_str=""
for((i=0;i<len_n;i++)); do
  em_o="$(echo "${arr_csv1[$i]}" | awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $5}')"
  #echo "em_o:$em_o"
  flag=0
  if [[ ! "${dupl_str[*]}" =~ $i ]] ; then
    for((j=((i+1));j<len_m;j++ )); do
      #echo "i:${i}, j:${j}"
      #echo ${arr_csv1[$j]}
      em_c="$(echo "${arr_csv1[$j]}" | awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $5}')"
      if [[ "$em_o" == "$em_c" ]]; then
        dupl_str+="$j "
        flag=1
        arr_csv1[$j]=$(fixit1 "${arr_csv1[j]}")
      fi
      #echo "em_c:$em_c"
  done #for j
  fi # if dupl
 if [[ $flag == 1 ]]; then
      dupl_str+="$i "
       arr_csv1[$i]=$(fixit1 "${arr_csv1[i]}")
      fi
 flag=0
done #for i
echo "dubl_str:$dupl_str"
for record in "${arr_csv1[@]}" # interate array
do
   echo "$record" #>> account_new.csv  # applay fix to line, output fixed line to account_new.csv
done
