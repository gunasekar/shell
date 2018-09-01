#!/bin/bash

# <bitbar.title>Play Url</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Gunasekaran Namachivayam</bitbar.author>
# <bitbar.author.github>gunasekar</bitbar.author.github>
# <bitbar.desc>This plugin will play the url in clipboard using mpv</bitbar.desc>

# Hack for language not being set properly and unicode support
# update the key value pairs as per your requirement
# Key - for your reference to identify the youtube playlist
# Value - Youtube Playlist ID
# yt_playlists=(
#     "Hit'em:PL4HXfrEReHCW6ExjtjYs3Ija3qSgrrmdK"
#     "Covers & Mashups:PLjOy3wobFPwuYA7d4RBIF4YuV-UVvcfT7"
#     )
# or source the above totp_secrets key-value pairs from a different file as in below

export LANG="${LANG:-en_US.UTF-8}"
YT_PL_URL="https://www.youtube.com/playlist?list="
QUALITY=(
    "360:bestvideo[height<=360]+bestaudio/best"
    "720:bestvideo[height<=720]+bestaudio/best"
    "1080:bestvideo[height<=1080]+bestaudio/best"
    )
source ~/.constants

# mpv and youtube-dl needs to be installed. Use 'brew install mpv' and 'brew install youtube-dl'
if [[ "$1" == "play" ]]; then
    tmp=$(pbpaste)
    if [ -z "$2" ]; then
        /usr/local/bin/mpv "$tmp"
    else
        for q in "${QUALITY[@]}" ; do
            if [[ "${q%%:*}" == "$2" ]]; then
                /usr/local/bin/mpv --ytdl-format="${q##*:}" "$tmp"
            fi
        done
    fi
    exit
fi

if [[ "$1" == "playlist" ]]; then
    echo $2
    for q in "${QUALITY[@]}" ; do
        if [[ "${q%%:*}" == "$2" ]]; then
            echo "/usr/local/bin/mpv --ytdl-format="${q##*:}" "$3""
            /usr/local/bin/mpv --ytdl-format="${q##*:}" "$3"
        fi
    done
    exit
fi

echo "📽️"
echo '---'
echo "Play Url (360p) | bash='$0' param1=play param2=360 terminal=false"
echo "Play Url (720p) | bash='$0' param1=play param2=720 terminal=false"
echo "Play Url (1080p) | bash='$0' param1=play param2=1080 terminal=false"
echo "Play Url (Max) | bash='$0' param1=play terminal=false"
echo '---'
for item in "${yt_playlists[@]}" ; do
    KEY="${item%%:*}"
    VALUE="${item##*:}"
    echo "$KEY | bash='$0' param1=playlist param2=360 param3="$YT_PL_URL$VALUE" terminal=false"
done
echo "---"
