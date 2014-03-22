#!/bin/bash                                                                                                     
 
#PA.sh
#1 argument: name of a song (e.g. song\ title.mp3)

home=~/
dir=$home"Music/iTunes/iTunes Music/Music/"

find "${dir}" -type f > ~/Documents/songPathways.txt

find "${dir}" -type f | sed 's/.*Music\/iTunes\/iTunes Music\/Music\/.*\///' | sed 's/[0-9]*[" "]//' | sed 's/[0-9]*[-]//'  > ~/Documents/songs.txt

paste -d "=" ~/Documents/songPathways.txt ~/Documents/songs.txt > ~/Documents/songsAndPaths.txt

while read line
do
    songWanted=$1
    song=${line#*"="}
    path=${line%"="*}
    if [ "$song" == "$songWanted" ]
    then
	echo "Playing: " $song
        afplay "${path}"
    fi
done < ~/Documents/songsAndPaths.txt;