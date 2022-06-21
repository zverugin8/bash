#!/usr/bin/bash
cat ./output.txt | sed 's/not ok/false,/' |  sed 's/  */ /g' | sed 's/ok/true,/' > ./out1.txt
#cat ./output.txt | sed 's/not ok/nok/' | sed -n 3p |  sed 's/  */ /g'
arr=()
str_arr=()
readarray -t arr < ./out1.txt
str_arr=( ${arr[2]} )
str_arr[1]+=","
echo ${str_arr[@]}






















function test2() {
while IFS=$'\r\n' read -ra str_arr; do
echo $str_arr
str_arr1+="($str_arr)"
done <<< "$(cat ./output.txt)"
echo "${str_arr1[@]}"
}
function test1() {
BUCKET_NAME=testbucket
OBJECT_NAME=testworkflow-2.0.1.jar
TARGET_LOCATION=/opt/test/testworkflow-2.0.1.jar

JSON_STRING=$(jq -n \
                  --arg bucketname "$BUCKET_NAME" \
                  --arg objectname "$OBJECT_NAME" \
                  --arg targetlocation "$TARGET_LOCATION" \
                   '$ARGS.named')
echo $JSON_STRING
}