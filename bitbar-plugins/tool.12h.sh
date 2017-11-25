#!/bin/bash

# <bitbar.title>Custom Tools</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Gunasekaran Namachivayam</bitbar.author>
# <bitbar.author.github>gunasekar</bitbar.author.github>
# <bitbar.desc>This plugin will help with several custom tooling</bitbar.desc>

# Hack for language not being set properly and unicode support
export LANG="${LANG:-en_US.UTF-8}"

# mpv and youtube-dl needs to be installed. Use 'brew install mpv' and 'brew install youtube-dl'
if [[ "$1" == "getYoutubeVideoID" ]]; then
    pbpaste | awk -F'=' '{ print $2 }' | pbcopy
    exit
fi

echo "🔨"
echo '---'
echo "Get Youtube Video ID | bash='$0' param1=getYoutubeVideoID terminal=false"
echo "---"
