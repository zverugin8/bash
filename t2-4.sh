function out_file () {
  local full_name
  local pth
  local f_file
  local s_file
  local out_fl
  full_name="$1"
  pth=${full_name%/*}
  f_file=${full_name##*/}
  s_file=${f_file%.*}
  out_fl=$pth"/"$s_file".json"

  if [[ -z $1 ]]; then
    echo "Input file required"
    exit 1 # check args
  fi

  if ! [ -f $1 ]; then echo "File $1 not exists" ; exit 1 ; fi

  #echo pth $pth
  #echo f_file: $f_file
  #echo s_file : $s_file
  echo "$out_fl"
}
out_file $1
