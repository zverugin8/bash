#!/usr/bin/bash

function inst_jq()
{
yum --version > /dev/null 2>&1
local os
if [[ $? -eq 0 ]] ; then os="cent7" ; fi
apt -v > /dev/null 2>&1
if [[ $? -eq 0 ]] ; then os="ubuntu" ; fi
dnf --version > /dev/null 2>&1
if [[ $? -eq 0 ]] ; then os="cent8" ; fi
echo $os
case "$os" in
ubuntu)
sudo apt install jq -y
;;
cent7)
sudo yum install -y epel-release
sudo yum install -y jq
;;
cent8)
sudo dnf install -y epel-release
sudo dnf install -y jq
esac
}

cat ./output.txt | head -n 1 | sed 's/, /;/g'| sed -E -e 's/\[ | \]//g'  > ./out_h.txt
#cat ./output.txt | tail -n+3 | head -n -2 | sed 's/not ok/false;/' |  sed 's/  */ /g' | sed 's/ok/true;/' |sed -e 's/), /);/'| sed -e 's/ \([0-9]\+\) /\1;/' >> ./out1.txt
cat ./output.txt | tail -n+3 | head -n -2 | sed 's/not ok/false;/
                                                 s/  */ /g
                                                 s/ok/true;/
                                                 s/), /);/
                                                 s/ \([0-9]\+\) /\1;/' > ./out_b.txt
cat ./output.txt | tail -n 1 | sed 's/ (of / success;/
                                    s/) tests passed/ total/
                                    s/tests failed/failed/
                                    s/ rated as / rating /
                                    s/, /;/g' | \
                                    sed -r 's/([1-9]+) ([a-zA-Z]+)/\2 \1/g' > ./out_t.txt

# read body
arr=()
readarray -t arr < ./out_b.txt
# function json
function test1() {
jq --help > /dev/null 2>&1 ; if [[ $? -ne 0 ]] ; then
echo "Jq not found, installing jq"
inst_jq
fi
#read vars
local name=$(echo $* | awk -F ";" '{print $3}')
local status=$(echo $* | awk -F ";" '{print $1}')
local duration=$(echo $* | awk -F ";" '{print $4}')

JSON_STRING=$(jq -n \
                  --arg name "$name" \
                  --arg status $status \
                  --arg duration "$duration" \
                   '$ARGS.named')
echo $JSON_STRING
}
test1 ${arr[0]}

function test3 () {
local name=$(echo $* | awk -F ";" '{print $3}')
echo $*
echo $name   
}
#test3 "${arr[0]}"

