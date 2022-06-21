record="29,22,suzDDnne badnhooP,Tester,suzanne@example.com,Referrals"
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
  email=$em_fl$em_sur"@abc.com"
  department=${str_arr[5]}
  echo "id is "$id
  echo "location_id is "$location_id
  echo "name is "$name
  echo "title is "$title
   echo "email is "$email
  echo "department is "$department
 done <<< "$record"
echo suzaEZSne@example.com | sed 's/@.*/@abc\.com/' | tr "[:upper:]" "[:lower:]"
em_fl=$(echo $name | cut -c 1-1 | tr "[:upper:]" "[:lower:]")
echo $em_fl
em_sur=$(echo ${name[1]}| tr "[:upper:]" "[:lower:]")
echo $em_sur
IFS=$OIFS



