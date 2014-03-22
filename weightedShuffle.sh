#!/bin/bash 

home=~/

library=$home"Music/iTunes/iTunes Music Library.xml"

dir=$home"Music/iTunes/iTunes Music/Music/"

find "${dir}" -type f > ~/Documents/songPathways.txt

find "${dir}" -type f | sed 's/.*Music\/iTunes\/iTunes Music\/Music\/.*\///' | sed 's/[0-9]*[" "]//' | sed 's/[0-9]*[-]//' > ~/Documents/\
songs.txt

paste -d "=" ~/Documents/songPathways.txt ~/Documents/songs.txt > ~/Documents/songsAndPaths.txt

cat "${library}" |
awk '
     { match ($0,"<key>Name</key><string>") } 
     { if (RSTART > 0) { songName=substr($0,RSTART+RLENGTH);
                         sub(/\<\/string\>/,"",songName) }}                                                                
     { match ($0,"<key>Play Count</key><integer>") } 
     { if (RSTART > 0) { playCount=substr($0,RSTART+RLENGTH);                   
                         sub(/\<\/integer\>/,"",playCount);               
                         nameToPlays[songName] = playCount } }                                                        
     END { i = 0; for (song in nameToPlays) {
              for (j = 1; j <= nameToPlays[song]; j++) {
                   songs[i] = song
                   i = i + 1 } } 
              for (song in songs)
                   print(song,"=",songs[song]) }
    ' | sort -n > ~/Documents/weightShuffle.txt 

lines=$(wc -l < ~/Documents/weightShuffle.txt)
lines=$((lines - 1))


i=0
while [ $i -lt 2 ]
do
    rand=$((RANDOM%lines+1))
    while read numAndSong
    do
	num=${numAndSong%"="*}
	if [ $num -eq $rand ]
	then
	    while read line
	    do
		songWanted=${numAndSong#*"= "}
		sW=$(echo $songWanted)
		song=${line#*"="}
		song=${song%"."*}
		path=${line%"="*}
		s=$(echo $song)
		if [[ $s == $sW ]]
		then
		    echo "Playing: "$song
		    afplay "${path}"
		fi
	    done < ~/Documents/songsAndPaths.txt;
	fi
    done < ~/Documents/weightShuffle.txt
done