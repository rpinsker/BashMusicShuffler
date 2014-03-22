#!/bin/bash

# 1 argument: play in order of increasing play count within an artist (argument 1)
# -r (reverse): play in reverse play count (decreasing) within an artist (argument 2)

if [[ $1 == "-r" ]]
then
    flag=$1
    artistArg=$2
else
    flag=""
    artistArg=$1
fi

echo "Artist: " $artistArg

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
     { match ($0,"<key>Artist</key><string>") }   
     { if (RSTART > 0) { artist=substr($0,RSTART+RLENGTH)                                                        
                         sub(/\<\/string\>/,"",artist) }}
     { match ($0,"<key>Play Count</key><integer>") }                                                                  { if (RSTART > 0) { playCount=substr($0,RSTART+RLENGTH);                                                                                   sub(/\<\/integer\>/," ",playCount) }}
     { nameToArtistAndCount[songName] = playCount"="artist }
     END{ for (song in nameToArtistAndCount) 
          print(nameToArtistAndCount[song],"==",song) }                                                                         
    ' | sort -n $flag > ~/Documents/nameArtistAndPlayCount.txt

while read nameArtistPlayCount
do
    artistWanted=$artistArg
    artist=${nameArtistPlayCount%" == "*}
    artist=${artist#*[1-9]*" ="}
    aW=$(echo $artistWanted)
    a=$(echo $artist)
    if [[ $a == $aW ]]
    then
	songWanted=${nameArtistPlayCount#*[1-9]*" ="}
	songWanted=${songWanted#*" == "}
	sW=$(echo $songWanted)
	while read line
	do
	    song=${line#*"="}
	    song=${song%"."*}
	    path=${line%"="*}
	    s=$(echo $song)
	    if [[ $s == $sW  ]]
	    then
		echo "Playing: " $song
		afplay "${path}"
	    fi
	done < ~/Documents/songsAndPaths.txt;
    fi
done < ~/Documents/nameArtistAndPlayCount.txt