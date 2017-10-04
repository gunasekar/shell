#!/bin/bash

# <bitbar.title>Authenticator</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Gunasekaran Namachivayam</bitbar.author>
# <bitbar.author.github>gunasekar</bitbar.author.github>
# <bitbar.desc>This plugin will generate the tokens and allows to copy them to clipboard</bitbar.desc>

# Hack for language not being set properly and unicode support
export LANG="${LANG:-en_US.UTF-8}"

# oath-toolkit needs to be installed. I have used 'brew install oath-toolkit'
# update the appropriate path of oathtool binary in the below function along with your secret
function get-totp {
  case "$1" in
    ("VPN") echo "$( /usr/local/Cellar/oath-toolkit/2.6.2/bin/oathtool --totp -b "<secret>" )" ;;
    ("BitBucket") echo "$( /usr/local/Cellar/oath-toolkit/2.6.2/bin/oathtool --totp -b "<secret>" )" ;;
    ("GitHub") echo "$( /usr/local/Cellar/oath-toolkit/2.6.2/bin/oathtool --totp -b "<secret>" )" ;;
    ("Google") echo "$( /usr/local/Cellar/oath-toolkit/2.6.2/bin/oathtool --totp -b "<secret>" )" ;;
    ("Okta") echo "$( /usr/local/Cellar/oath-toolkit/2.6.2/bin/oathtool --totp -b "<secret>" )" ;;
    (*) echo "NIL" ;;
  esac
}

# Write the list of Text you want enabled
LIST="VPN
BitBucket
GitHub
Google
Okta"

if [[ "$1" == "copy" ]]; then
  echo -n "$(echo -n "$2")" | pbcopy
  exit
fi

echo "🕘"
echo '---'
echo "Clear Clipboard | bash='$0' param1=copy param2=' ' terminal=false"
echo "---"
while read -r line; do
  if ! [ "$line" == "" ]; then
    token=$( get-totp "$line" )
    echo "$line | bash='$0' param1=copy param2='$token' terminal=false"
  fi
done <<< "$LIST"
