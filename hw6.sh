echo $0
echo $*
for a in "$*"; do
echo $a;
done

echo $#
echo $2 $4

[[ $1 -eq $2  ]]
echo $?
