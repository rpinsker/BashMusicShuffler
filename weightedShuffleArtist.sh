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
     { if (RSTART > 0) { songName=substr($0,RSTART+RLENGTH) 
                         sub(/\<\/string\>/,"",songName) }}
     { match ($0,"<key>Artist</key><string>") }   
     { if (RSTART > 0) { artist=substr($0,RSTART+RLENGTH)                                                          
                         sub(/\<\/string\>/,"",artist) }} 
     { match ($0,"<key>Play Count</key><integer>") }                                                                       { if (RSTART > 0) { playCount=substr($0,RSTART+RLENGTH);                                                                                   sub(/\<\/integer\>/," ",playCount) 
                    artistToCount[artist] = artistToCount[artist] + playCount }}
     END{ i = 0; for (artist in artistToCount) {
                     for (j = 1; j <= artistToCount[artist]; j++) {
                          artists[i] = artist
                          i = i + 1; } }
          for (artist in artists)
              print(artist,"=",artists[artist]) }                                                                 
    ' | sort  -n $flag > ~/Documents/playCountArtist.txt

lines=$(wc -l < ~/Documents/playCountArtist.txt)
lines=$((lines - 1))

rand=$((RANDOM%lines+1))


while read numAndArtist
do
    num=${numAndArtist%"="*}
    if [ $num -eq $rand ]
    then
	artistWanted=${numAndArtist#*"="}
	/bin/bash playByArtist.sh -r "${artistWanted}"
    fi
done < ~/Documents/playCountArtist.txt
