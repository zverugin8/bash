#!/usr/bin/bash

if [ -z "${1}" ]; then 
  echo "One option required!"
  exit 1
fi

func1(){
  echo "${1}"
}

func2(){
  echo "${2} ${1}"
}

func1 "${1}"
func2 "a" "b"