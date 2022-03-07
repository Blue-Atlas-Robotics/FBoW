#!/bin/bash
echo "This script can be used for testing params for the vocabulary"
echo "Args:"
echo "Output (information will get stored there): $1"
echo "Feature input file: $2"
echo "k min: $3"
echo "k max: $4"
echo "l min: $5"
echo "l max: $6"

for (( k="$3"; k<="$4"; k++ ))
do
    for (( l="$5"; l<="$6"; l++ ))
    do
        echo "Now: k="$k", l="$l""
        echo "For k="$k" and l="$l":" >>"$1".txt
        echo "-k "$k""
        START_TIME=$SECONDS
        ../build/utils/fbow_create_vocabulary "$2" "voc_output_k$k'_l'$l" -k "$k" -l "$l"
        echo "voc_output_k$k'_l'$l" >> k_l_voc_names.txt
        ELAPSED_TIME=$(($SECONDS - $START_TIME))
        file_size="$(wc -c < "voc_output_k$k'_l'$l")"
        echo "Vocabulary output: File size="$file_size" bytes" >> "$1".txt
        echo -e "Time for generating vocabulary: "$ELAPSED_TIME" seconds \n" >> "$1".txt
    done
done