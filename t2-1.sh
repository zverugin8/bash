#!/usr/bin/bash
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
#cat ./out1.txt
#cat ./out1.txt | awk -F ";" '{print $1}'
#cat ./output.txt | sed 's/not ok/nok/' | sed -n 3p |  sed 's/  */ /g'
arr=()
str_arr=()
readarray -t arr < ./out_b.txt
#str_arr=( ${arr[2]} )
#awk -F ";" '{print $1 $3 $4}' <<< "${arr[0]}" |

function splt_b () {
    echo "was: ${arr[0]}"
OIFS=$IFS
while IFS=";" read status number name duration
do
echo $number
#echo $status
#echo $name
#echo $duration
done <<< "$*"
IFS=$OIFS
}
#splt_b ${arr[0]}


#str_arr[1]+=","















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
#inst_jq

#vjq=$(rpm -q jqa) ; if [[ -n $vjq ]] ; then echo $vjq ; fi

function test1() {
jq --help > /dev/null 2>&1 ; if [[ $? -ne 0 ]] ; then
echo "Jq not found, installing jq"
inst_jq
fi
#read vars
OIFS=$IFS
while IFS=";" read status number name duration
do
BUCKET_NAME=$name
OBJECT_NAME=$status
TARGET_LOCATION=$duration
done <<< "$*"
IFS=$OIFS


JSON_STRING=$(jq -n \
                  --arg bucketname "$BUCKET_NAME" \
                  --arg objectname "$OBJECT_NAME" \
                  --arg targetlocation "$TARGET_LOCATION" \
                   '$ARGS.named')
echo $JSON_STRING
}
test1 ${arr[0]}

function test2() {
while IFS=$'\r\n' read -ra str_arr; do
echo $str_arr
str_arr1+="($str_arr)"
done <<< "$(cat ./output.txt)"
echo "${str_arr1[@]}"
}
