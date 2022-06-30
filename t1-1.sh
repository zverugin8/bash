#!/usr/bin/bash
#record="30,20,Sean Houston,Director of new Services,,"
record="3,2,Brenda brown,"Director, Second Career Services",,"
function fixit() {
echo $0
OIFS=$IFS
while IFS=',' read -ra str_arr; do
  id=${str_arr[0]}
  location_id=${str_arr[1]}
  name=( ${str_arr[2],,} ) # to lower
  name=${name[@]^} # capitalize first letter
  title=${str_arr[3]}
  em_fl=$(echo $name | cut -c 1-1 | tr "[:upper:]" "[:lower:]")
  em_sur=$(echo ${name[1]}| tr "[:upper:]" "[:lower:]")
  #email=${str_arr[4]}
  email=$em_fl$em_sur$location_id"@abc.com"
  department=${str_arr[5]}
  echo "id is "$id
  echo "location_id is "$location_id
  echo "name is "$name
  echo "title is "$title
  echo "email is "$email
  echo "department is "$department
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
fixit $record
