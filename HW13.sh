#!/usr/bin/bash
read -a filename
#echo $filename
head -c 4KB /dev/urandom >> $filename
size1=$(ls -al | grep $filename | awk '{print $5}' | sed 's!000!!')
#echo $size1

until [ $size1 -gt 1024 ]
do
cat $filename $filename >file2
mv ./file2 ./$filename
size1=$(ls -al | grep $filename | awk '{print $5}' | sed 's!000!!') 
echo "Filesize: "$size1
done
rm ./$filename
