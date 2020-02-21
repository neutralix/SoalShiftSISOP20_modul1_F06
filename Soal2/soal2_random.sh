#!/bin/bash

name=$(echo $1 | tr -dc 'a-zA-Z')

cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 28 | head -n 1 > "$name".txt
