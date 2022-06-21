#!/usr/bin/bash
if [[ -z $1 ]]; then echo "Input file required"; exit 1
fi
flc=$(cat $1)
#echo "$flc"
arr_csv=() 
while IFS= read -r line 
do
    arr_csv+=("$line")
done <<< "$flc"

echo "Displaying the contents of array mapped from csv file:"
index=0
for record in "${arr_csv[@]}"
do
    echo "Record at index-${index} : $record[1]"
	((index++))
done
