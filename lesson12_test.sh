#!/usr/bin/bash
file=~/passwd
while IFS= read -r line; do  
echo $line
done < "$file"
