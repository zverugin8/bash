function fixit() {
while IFS="" read -ra str_arr; do
title=${str_arr[4]}
echo "title is" $title
done <<< "$@"
}

arr_csv=()
while IFS= read -r line
do
    arr_csv+=("$line")
done <<< $(cat $1)

IFS=','
for record in "${arr_csv[@]}"
do
  fixit $record
  done
