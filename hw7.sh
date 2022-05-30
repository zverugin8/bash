#!/usr/bin/bash
[[ "$1" -eq "$2" ]]
echo "Is $1 equal to $2? $?"

[[ $1 -gt $2 ]]
echo "Is $1 longer than $2? $?"

[[ -n $TEST ]]
echo "Is TEST variable present? $?"

[[ $3 -ne $4  ]]
echo "Is $3 not equal than $4? $?"

[[ $3 -ge $4  ]]
echo "Is $3 greater or equal than $4? $?"
