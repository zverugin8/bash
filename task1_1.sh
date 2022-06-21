#!/usr/bin/bash
function fixit() {
local id=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $1}' <<<"$*")
local location_id=$(awk -F "," '{print $2}' <<< "$@")
local name=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $3}' <<<"$*")
local name=( ${name[*],,} ) # to lower
local name=${name[@]^} # capitalize first letter
local title=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $4}' <<<"$*")
#email=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $5}' <<<"$*")
local em_fl=$(echo $name | cut -c 1-1 | tr "[:upper:]" "[:lower:]")
local em_sur=$(echo ${name[1]}| tr "[:upper:]" "[:lower:]")
local email=$em_fl$em_sur$location_id"@abc.com"
local department=$(awk -F "," '{print $6}' <<<"$*")
local res_ln="$id,$location_id,$name,$title,$email,$department"
echo "Before: $*"
echo "After:  $res_ln"
}


if [[ -z $1 ]]; then echo "Input file required"; exit 1
fi
head ./$1 -n 1 >account1.csv # create new file with original header
arr_csv=()
while IFS= read -r line
do
    arr_csv+=("$line")
done <<< "$(cat "$1"|sed 1d)"

for record in "${arr_csv[@]}"
#for record in "${flc[@]}"
do
    fixit "$record" >> account1.csv
done
