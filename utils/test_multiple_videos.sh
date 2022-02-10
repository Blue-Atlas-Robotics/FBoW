#!/bin/bash
echo "This script can be used for testing the feature extraction and vocabulary generation for multiple videos"
echo "Args:"
echo "Output (information will get stored there): $1"
echo "Args 2-X: video files to be analysed."

last_video="$#"
for (( c=2; c<="$last_video"; c++ ))
do
    var="$c"
    echo "Testing video: ${!var}"
    echo "${!var}" > tmp_video_list.txt
    file_size="$(wc -c <"${!var}")"
    echo "Video ${!var}:" >> "$1".txt
    echo "File size="$file_size" bytes" >> "$1".txt
    #duration_in_sec=$(ffprobe -i some_video -show_entries format=duration -v quiet -of csv="p=0")
    echo "Video duration: "$duration_in_sec"" >> "$1".txt
    START_TIME=$SECONDS
    #./generate_vocab.sh tmp_video_list.txt true outputvoc 10 6
    ../build/utils/fbow_dump_features orb feature_output tmp_video_list.txt TRUE
    ELAPSED_TIME=$(($SECONDS - $START_TIME))
    file_size="$(wc -c < feature_output)"
    echo "Feature output: File size="$file_size" bytes" >> "$1".txt
    echo "Time for feature extraction: "$ELAPSED_TIME" seconds" >> "$1".txt
    START_TIME=$SECONDS
    ../build/utils/fbow_create_vocabulary feature_output voc_output 10 6
    ELAPSED_TIME=$(($SECONDS - $START_TIME))
    file_size="$(wc -c < voc_output)"
    echo "Vocabulary output: File size="$file_size" bytes" >> "$1".txt
    echo -e "Time for generating vocabulary: "$ELAPSED_TIME" seconds \n" >> "$1".txt

done