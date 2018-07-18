#!/bin/bash

# <bitbar.title>Custom Tools</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Gunasekaran Namachivayam</bitbar.author>
# <bitbar.author.github>gunasekar</bitbar.author.github>
# <bitbar.desc>This plugin will help with several custom tooling</bitbar.desc>

# Hack for language not being set properly and unicode support
export LANG="${LANG:-en_US.UTF-8}"

# mpv and youtube-dl needs to be installed. Use 'brew install mpv' and 'brew install youtube-dl'
if [[ "$1" == "camelCase2snake_case" ]]; then
    pbpaste | sed -r 's/([a-z0-9])([A-Z])/\1_\L\2/g' | pbcopy
    exit
fi

echo "🔨"
echo '---'
echo "camelCase to snake_case | bash='$0' param1=camelCase2snake_case terminal=false"
echo "---"
