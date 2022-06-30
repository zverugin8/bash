#!/usr/bin/bash
while : ; do
  read -a lin
  cas=${lin[0]}
  case "$cas" in
  #"ls") 
  #${lin[@]}
  #;;
  "pwd") 
  ${lin[0]}
;;
  "exit")
  break
  ;;
"hi")
echo "Hello "$USER 
;;
*)
eval ${lin[@]}
esac
done #while