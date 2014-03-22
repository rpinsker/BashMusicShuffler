#!/bin/bash 

#no arguments: plays in order of increasing play count
#"-r": plays in order of decreasing play count

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
     { if (RSTART > 0) { songName=substr($0,RSTART+RLENGTH)
                         sub(/\<\/string\>/,"",songName) }}                                                                
     { match ($0,"<key>Play Count</key><integer>") } 
     { if (RSTART > 0) { playCount=substr($0,RSTART+RLENGTH)                                                                                   
                         sub(/\<\/integer\>/,"",playCount)                                                            
                         nameToPlays[songName] = playCount } }                                                        
     END{ for (song in nameToPlays)                                                                                   
          print(nameToPlays[song]," ",song) }
    ' | sort -n $1 > ~/Documents/playCountAndName.txt
while read countAndSong
do
    while read line
    do
	songWanted=${countAndSong#*[1-9]*" "}
	sW=$(echo $songWanted)
	song=${line#*"="}
	song=${song%"."*}
	path=${line%"="*}
	s=$(echo $song)
	if [[ $s == $sW ]]
	then
	    echo "Playing: " $song
	    afplay "${path}"
	fi
    done < ~/Documents/songsAndPaths.txt;
done < ~/Documents/playCountAndName.txt