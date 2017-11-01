#!/bin/bash

# <bitbar.title>Play Url</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Gunasekaran Namachivayam</bitbar.author>
# <bitbar.author.github>gunasekar</bitbar.author.github>
# <bitbar.desc>This plugin will play the url in clipboard using mpv</bitbar.desc>

# Hack for language not being set properly and unicode support
export LANG="${LANG:-en_US.UTF-8}"

# mpv and youtube-dl needs to be installed. Use 'brew install mpv' and 'brew install youtube-dl'
if [[ "$1" == "play" ]]; then
    tmp=$(pbpaste)
    /usr/local/bin/mpv --ytdl-format="$2" $tmp
    exit
fi

echo "📽️"
echo '---'
echo "Play Url (360p) | bash='$0' param1=play param2="bestvideo[height\<\=\?360]+bestaudio/best" terminal=false"
echo "Play Url (720p) | bash='$0' param1=play param2="bestvideo[height\<\=\?720]+bestaudio/best" terminal=false"
echo "Play Url (1080p) | bash='$0' param1=play param2="bestvideo[height\<\=\?1080]+bestaudio/best" terminal=false"
echo "Play Url (Max) | bash='$0' param1=play terminal=false"
echo "---"
