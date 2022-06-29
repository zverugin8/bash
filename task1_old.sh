#!/usr/bin/bash
function fixit() {
local id=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $1}' <<<"$*") #select id colunm
local location_id=$(awk -F "," '{print $2}' <<< "$@") # select location_id colunm
local name=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $3}' <<<"$*") # select name colunm
local name=( ${name[@],,} ) # careate array from name-surname and full name to lower
local name=${name[@]^} # capitalize name first letter
local title=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' '{print $4}' <<<"$*") # Title,comma inside quotes. Regex: not comma+(one or more times) OR quote-not quote+-quote
local em_fl=$(echo ${name[0]} | cut -c 1-1 | tr "[:upper:]" "[:lower:]") # prepare create e-mail, got name first letter and to lowercase it
local em_sur=$(echo ${name[1]}| tr "[:upper:]" "[:lower:]") # got surename and to lower it
local email=$em_fl$em_sur$location_id"@abc.com" # create e-mail column
local department=$(awk -F "," '{print $6}' <<<"$*") # got department column
local res_ln="$id,$location_id,$name,$title,$email,$department" # put all column into string (line) 
echo "$res_ln" # function output
}


if [[ -z $1 ]]; then echo "Input file required"; exit 1 # check args
fi
head ./$1 -n 1 >account_new.csv # create new file with original header

arr_csv=()
while IFS= read -r line
do
    arr_csv+=("$line")
done <<< "$(cat "$1"|sed 1d)" #read arg(file) to array without first line (header)

for record in "${arr_csv[@]}" # interate array 
do
    fixit "$record" >> account_new.csv  # applay fix to line, output fixed line to account_new.csv
done
#Script tested on Linux DESKTOP-45QSS3V 5.10.16.3-microsoft-standard-WSL2 #1 SMP Fri Apr 2 22:23:49 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
#not sure about exapmle 7,6,Peter Olson,Director,polson@abc.com, - location_id not added to e-mail in this example
