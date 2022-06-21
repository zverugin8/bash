#!/usr/bin/bash

function fixit() {
OIFS=$IFS
while IFS=',' read -ra str_arr; do
  id=${str_arr[0]}
  location_id=${str_arr[1]}
  name=( ${str_arr[2],,} ) # to lower
  name=${name[@]^} # capitalize first letter
  title=${str_arr[3]}
  em_fl=$(echo $name | cut -c 1-1 | tr "[:upper:]" "[:lower:]")
  em_sur=$(echo ${name[1]}| tr "[:upper:]" "[:lower:]")
  email=$em_fl$em_sur$location_id"@abc.com"
  department=${str_arr[5]}
  #echo "id is "$id
  #echo "location_id is "$location_id
  #echo "name is "$name
  #echo "title is "$title
  #echo "email is "$email
  #echo "department is "$department
  res_ln="$id,$location_id,$name,$title,$email,$department"
 done <<< "$*"
echo $record
echo $res_ln
#echo suzaEZSne@example.com | sed 's/@.*/@abc\.com/' | tr "[:upper:]" "[:lower:]"
#em_fl=$(echo $name | cut -c 1-1 | tr "[:upper:]" "[:lower:]")
#echo $em_fl
#em_sur=$(echo ${name[1]}| tr "[:upper:]" "[:lower:]")
#echo $em_sur
IFS=$OIFS
}



if [[ -z $1 ]]; then echo "Input file required"; exit 1
fi
flc=$(cat $1)
#echo "$flc"
arr_csv=()
while IFS= read -r line
do
    arr_csv+=("$line")
done <<< "$flc"
for record in "${arr_csv[@]}"
do
    #echo "Record at index-${index} : $record[1]"
	#((index++))
    fixit $record
done
