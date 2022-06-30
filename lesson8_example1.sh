#!/usr/bin/bash
FOO=$1
BAR=$2
if echo $FOO | grep $BAR; then echo "Bar is substring of foo"; echo $?
else echo "Bar isnt substrinf of foo"
fi

