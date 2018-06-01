#!/bin/bash

# <bitbar.title>Play Url</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Gunasekaran Namachivayam</bitbar.author>
# <bitbar.author.github>gunasekar</bitbar.author.github>
# <bitbar.desc>This plugin will play the url in clipboard using mpv</bitbar.desc>

# Hack for language not being set properly and unicode support
export LANG="${LANG:-en_US.UTF-8}"
YT_PL_URL="https://www.youtube.com/playlist?list="
YT_PL_ID=(
    "Hit'em:PL4HXfrEReHCW6ExjtjYs3Ija3qSgrrmdK"
    "Recent:PL4HXfrEReHCWhnQ4sx63bUcMh_4m1hEJS"
    "Tamil Covers:PL4HXfrEReHCV7QC2aJ0Hb4D6k2PwFfwBo"
    "Hindi Covers:PL4HXfrEReHCUW0IU1uZlHH0W3swMI01iK"
    "Covers & Mashups:PLjOy3wobFPwuYA7d4RBIF4YuV-UVvcfT7"
    "Amrutam Gamaya:PLDa8YieoG1-QUgku_koU4SkFaPCg66FT8"
    )
    
# mpv and youtube-dl needs to be installed. Use 'brew install mpv' and 'brew install youtube-dl'
if [[ "$1" == "play" ]]; then
    tmp=$(pbpaste)
    if [ -z "$2" ]; then
        /usr/local/bin/mpv $tmp
    else
        /usr/local/bin/mpv --ytdl-format="$2" $tmp
    fi
    exit
fi

if [[ "$1" == "playlist" ]]; then
    /usr/local/bin/mpv --ytdl-format="$2" $3
    exit
fi

echo "📽️"
echo '---'
echo "Play Url (360p) | bash='$0' param1=play param2="bestvideo[height\<\=\?360]+bestaudio/best" terminal=false"
echo "Play Url (720p) | bash='$0' param1=play param2="bestvideo[height\<\=\?720]+bestaudio/best" terminal=false"
echo "Play Url (1080p) | bash='$0' param1=play param2="bestvideo[height\<\=\?1080]+bestaudio/best" terminal=false"
echo "Play Url (Max) | bash='$0' param1=play terminal=false"
echo '---'
for ITEM in "${YT_PL_ID[@]}" ; do
    KEY="${ITEM%%:*}"
    VALUE="${ITEM##*:}"
    echo "$KEY | bash='$0' param1=playlist param2="bestvideo[height\<\=\?720]+bestaudio/best" param3=$YT_PL_URL$VALUE terminal=false"
done
echo "---"
