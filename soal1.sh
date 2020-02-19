#!/bin/bash

echo "Region dengan profit paling sedikit:"
min_region=$(awk 'BEGIN {FS="\t"; PROCINFO["sorted_in"]="@val_num_asc"}
	FNR>1 {reg[$13]+=$21}
	END {for(i in reg) print i, reg[i]}' Sample-Superstore.tsv |
	awk '{print $1}' | head -1)
echo "$min_region"

echo -e "\nDua negara bagian dengan profit paling sedikit:"
arr=$(awk -v min_region="$min_region" 'BEGIN {FS="\t";
 PROCINFO["sorted_in"]="@val_num_asc"}
($13~min_region) {state[$11]+=$21}
END{for(i in state) print i, state[i]}' Sample-Superstore.tsv |
        awk '{print $1}' | head -2)
echo "$arr"

echo -e "\nSepuluh produk dengan profit paling sedikit:"
state1="Texas"
state2="Illinois"
awk -v arr="$arr" -v state1="$state1" -v state2="$state2" 'BEGIN {FS="\t"; OFS="\t";
 PROCINFO["sorted_in"]="@val_num_asc"}
($11~state1 || $11~state2) {produk[$17]+=$21}
END{for(i in produk)print i,produk[i]}' Sample-Superstore.tsv |
awk 'BEGIN{FS="\t"}; {print $1}' | head -10

