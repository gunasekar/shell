#!/bin/bash

# <bitbar.title>Custom Tools</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Gunasekaran Namachivayam</bitbar.author>
# <bitbar.author.github>gunasekar</bitbar.author.github>
# <bitbar.desc>This plugin will help with several custom tooling</bitbar.desc>

# Hack for language not being set properly and unicode support
export LANG="${LANG:-en_US.UTF-8}"

urlencode() {
	local LANG=C i c e=''
	for ((i=0;i<${#1};i++)); do
                c=${1:$i:1}
		[[ "$c" =~ [a-zA-Z0-9\.\~\_\-] ]] || printf -v c '%%%02X' "'$c"
                e+="$c"
	done
        echo "$e"
}

urldecode() {
    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}

if [[ "$1" == "base64.encode" ]]; then
    input=$(pbpaste)
    echo $input | base64 | pbcopy
fi

if [[ "$1" == "base64.decode" ]]; then
    input=$(pbpaste)
    echo `echo $input | base64 --decode` | pbcopy
fi

if [[ "$1" == "urlencode" ]]; then
    input=$(pbpaste)
    urlencode $input | pbcopy
fi

if [[ "$1" == "urldecode" ]]; then
    input=$(pbpaste)
    urldecode $input | pbcopy
fi

if [[ "$1" == "jbeautify" ]]; then
    input=$(pbpaste)
    jqCommand="/usr/local/bin/jq"
    echo $input | $jqCommand '.' | pbcopy
fi

if [[ "$1" == "json2csv" ]]; then
    input=$(pbpaste)
    params='(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv'
    jqCommand="/usr/local/bin/jq --raw-output '$params'"
    echo $input | /usr/local/bin/jq --raw-output '(map(keys) | add | unique) as $cols | map(. as $row | $cols | map($row[.])) as $rows | $cols, $rows[] | @csv' | pbcopy
fi


echo "🔨"
echo '---'
echo "base64.encode | bash='$0' param1=base64.encode terminal=false"
echo "base64.decode | bash='$0' param1=base64.decode terminal=false"
echo "urlencode | bash='$0' param1=urlencode terminal=false"
echo "urldecode | bash='$0' param1=urldecode terminal=false"
echo "jbeautify | bash='$0' param1=jbeautify terminal=false"
echo "json2csv | bash='$0' param1=json2csv terminal=false"
echo "---"
