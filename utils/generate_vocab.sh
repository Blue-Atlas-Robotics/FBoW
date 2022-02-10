#!/bin/bash
echo "Inputfile(video list)/folder (image folder): $1"
echo "Input is videolist (true/false): $2"
echo "Outputfile: $3"
echo "K-> Amount of childs per node: $4"
echo -e "L-> Tree levels: $5 \n"

# Add arg for threads?

if [ $# -ne 5 ]
then
    echo "Not enough/too many arguments provided. Stopping."
    exit 1
fi

feature_output=("feature_output")
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_path"
cd "../build/utils"
rm "$feature_output" "$3"

time ./fbow_dump_features orb "$feature_output" "$1" TRUE
if ! [ -f "$feature_output" ]
then
    echo "Features could not be generated."
    exit -1
fi
echo "Features have been extracted"
echo "Starting vocabulary generation now"
 time ./fbow_create_vocabulary feature_output "$3" -k "$4" -l "$5"