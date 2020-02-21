#!/bin/bash

kenangancount=$(ls -l kenangan | wc -l)
duplicatecount=$(ls -l duplicate | wc -l)

for ((i=1 ; $i<=28 ; i++))
do
	wget "https://loremflickr.com/320/240/cat" -a "wget.log" -O "pdkt_kusuma_$i"
done

for ((i=1 ; $i<=28 ; i++))
do
	for ((j=$((i+1)) ; $j<=28 ; j++))
	do
		value=$(compare -metric AE pdkt_kusuma_$i pdkt_kusuma_$j null: 2>&1)
		if [[ $value == 0 ]]
		then
			mv pdkt_kusuma_$j duplicate/duplicate_$duplicatecount
			duplicatecount=$((duplicatecount+1))
		fi
	done
done

for ((i=1 ; $i<=28 ; i++))
do
	if [[ -f pdkt_kusuma_$i ]]
	then
		mv pdkt_kusuma_$i kenangan/kenangan_$kenangancount
		kenangancount=$((kenangancount+1))
	fi
done

cp wget.log wget.log.bak
