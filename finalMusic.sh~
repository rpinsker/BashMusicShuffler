#!/bin/bash

# 0 arguments: play by play count (increasing)
# -n (name) play a given song (next arg, in the form song\ name.mp3 or song.m4a)
# -r (reverse) play in reverse play count (decreasing)
# -a (artist) play by play count for a given artist (increasing) (next arg)
# -ra (reverse artist) play by play count for a given artist (decreasing) (next arg)
# -ws (weighted shuffle) weighted shuffle by play count
# -wa (weighted shuffle artist) weighted shuffle to pick an artist by play count of all songs by that artist, then play songs by that artist in decreasing order

home=~/

library=$home"Music/iTunes/iTunes Music Library.xml"

dir=$home"Music/iTunes/iTunes Music/Music/"

find "${dir}" -type f > ~/Documents/songPathways.txt

find "${dir}" -type f | sed 's/.*Music\/iTunes\/iTunes Music\/Music\/.*\///' | sed 's/[0-9]*[" "]//' | sed 's/[0-9]*[-]//' > ~/Documents/\
songs.txt

paste -d "=" ~/Documents/songPathways.txt ~/Documents/songs.txt > ~/Documents/songsAndPaths.txt

nFlag=1
aFlag=1
raFlag=1

if [ $# == 0 ]
then
    /bin/bash shuffle.sh
else
    for arg in "$@"
    do
	if [[ $nFlag -eq 0 ]]
	then
	    /bin/bash PA.sh "${arg}"
	    nFlag=1
	elif [[ $aFlag -eq 0 ]]
	then
	    /bin/bash playByArtist.sh "${arg}"
	    aFlag=1
	elif [[ $raFlag -eq 0 ]]
	then
	    /bin/bash playByArtist.sh -r "${arg}"
	    raFlag=1
	elif [[ $arg == "-n" ]]
	then
	    nFlag=0
	elif [[ $arg == "-a" ]]
	then
	    aFlag=0
	elif [[ $arg == "-ra" ]]
	then 
	    raFlag=0
        elif [[ $arg == "-r" ]]
	then
	    /bin/bash shuffle.sh -r
	elif [[ $arg == "-ws" ]]
	then
	    /bin/bash weightedShuffle.sh
	elif [[ $arg == "-wa" ]]
	then
	    /bin/bash weightedShuffleArtist.sh
	fi
    done
fi

exit 0