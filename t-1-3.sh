#!/usr/bin/bash
str='22,14,Andres Espinoza,"Manager, Commanding Officer",,'
res=$(awk -v FPAT='([^,]+)|(\"[^\"]+\")' -v OFS=, '{print $4}' <<<"$str");
echo "title is $res"
