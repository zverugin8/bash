foo='22,14,Andres Espinoza,"Manager, Commanding Officer",,'
#echo $string
#eval 'for word in '$string'; do echo $word; done'
i=0
j=0
arr=()
#j=$((j+1))
while [ $i -lt ${#foo} ]
do
if [[ "${foo:$i:1}" == "\"" ]]; then
  quo=$quo${foo:$i:1}
fi
if [[ "${foo:$i:1}" == "," ]]; then
  j=$((j+1))
fi
arr+=("${foo:$i:1}")
i=$((i+1))
done
echo "comma count" $j
echo quo is $quo
echo ${arr[@]}
