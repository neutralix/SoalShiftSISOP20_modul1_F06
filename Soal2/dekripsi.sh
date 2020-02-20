#!/bin/bash

newfile=`basename -s .txt $1`
hour=$(date +"%H" -r $1)

while [ $hour -gt 0 ]
do
        newfile=$(echo "$newfile" | tr '[A-Za-z]' '[ZA-Yza-y]')
        hour=$((hour-1))
done

mv "$1" "$newfile.txt"


