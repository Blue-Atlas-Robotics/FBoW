#!/bin/bash
echo "Inputfile(video list)/folder (image folder): $1"
echo "Input is videolist (true/false): $2"
echo "Outputfile: $3"
echo "K-> Amount of childs per node: $4"
echo -e "L-> Tree levels: $5 \n"

trackingJustLost=1
rm ./voc_performance.txt 2> /dev/null
stdbuf -oL ~/openvslam/build/run_video_slam -v ~/openvslam/build/orb_vocab.fbow -m ~/openvslam/build/dump_0_video3.mp4 -c ~/openvslam/example/aist/fishbot.yaml --no-sleep --map-db map.msg |
while true
do
IFS= read -t 0.5 -r line
if [[ $line =~ .*tracking.lost: ]]
    then
    # tracking was lost -> check if reinitialization succeeds
    if [[ $trackingJustLost == 1 ]]
    then
        trackingJustLost=0
        lost_frames=$(echo "$line"| cut -d' ' -f 6-7)
        echo "LOST TRACK"
        sleep 2 # does not work
        continue
    fi
fi

if [[ $trackingJustLost == 0 ]] && [[ "$line" == "" ]]
then
# tracking has been lost and could not be reinitialized
    echo "Tracking has been lost and could not be reinitialized: $lost_frames"
    echo "Tracking has been lost and could not be reinitialized: $lost_frames" >> voc_performance.txt
    pid=$!
    kill $pid 2> /dev/null
    break
fi

if [[ $trackingJustLost == 0 ]] && [[ "$line" != "" ]]
then
    # reinit suceeded
    trackingJustLost=1
    echo "Reinit suceeded, tracking lost on: $lost_frames"
    echo "Reinit suceeded, tracking lost on: $lost_frames" >> voc_performance.txt
    continue
fi

done  
pid=$!

# If this script is killed, kill the openvslam run.
trap "kill $pid 2> /dev/null" EXIT
trap - EXIT
