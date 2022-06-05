#!/usr/bin/bash
cat ./passwd | grep "/usr/bin/false" | sed 's!/usr/bin/false!/bin/bash!'