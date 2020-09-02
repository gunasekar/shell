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

if [[ "$1" == "uuid.upper" ]]; then
    printf $(uuidgen) | tr '[:lower:]' '[:upper:]' | pbcopy
fi

if [[ "$1" == "uuid.lower" ]]; then
    printf $(uuidgen) | tr '[:upper:]' '[:lower:]' | pbcopy
fi

if [[ "$1" == "to.upper" ]]; then
    input=$(pbpaste)
    printf $input | tr '[:lower:]' '[:upper:]' | pbcopy
fi

if [[ "$1" == "to.lower" ]]; then
    input=$(pbpaste)
    printf $input | tr '[:upper:]' '[:lower:]' | pbcopy
fi

if [[ "$1" == "base64.encode" ]]; then
    input=$(pbpaste)
    printf $(printf $input | base64) | pbcopy
fi

if [[ "$1" == "base64.decode" ]]; then
    input=$(pbpaste)
    printf `printf $input | base64 --decode` | pbcopy
fi

if [[ "$1" == "urlencode" ]]; then
    input=$(pbpaste)
    echo -n $(urlencode $input) | pbcopy
fi

if [[ "$1" == "urldecode" ]]; then
    input=$(pbpaste)
    echo -n $(urldecode $input) | pbcopy
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

if [[ "$1" == "unix.epoch.s" ]]; then
    echo -n $(date +%s) | pbcopy
fi

if [[ "$1" == "utc.iso8601" ]]; then
    echo -n $(date -u +%FT%TZ) | pbcopy
fi

if [[ "$1" == "local.iso8601" ]]; then
    echo -n $(date +%FT%TZ) | pbcopy
fi

if [[ "$1" == "utc.YYYY-MM-DD hh:mm:ss" ]]; then
    echo -n $(date -u +"%Y-%m-%d %H:%M:%S") | pbcopy
fi

if [[ "$1" == "local.YYYY-MM-DD hh:mm:ss" ]]; then
    echo -n $(date +"%Y-%m-%d %H:%M:%S") | pbcopy
fi

if [[ "$1" == "utc.YYYY-MM-DD" ]]; then
    echo -n $(date -u +"%Y-%m-%d") | pbcopy
fi

if [[ "$1" == "local.YYYY-MM-DD" ]]; then
    echo -n $(date +"%Y-%m-%d") | pbcopy
fi

if [[ "$1" == "cred.user.stg" ]]; then
    echo -n '8c7733a2-82fb-42fd-ad12-9df93a216ffd' | pbcopy
fi

if [[ "$1" == "cred.user.prod" ]]; then
    echo -n '6743c3c0-b5a1-46d2-9efa-06ab2d2e9e26' | pbcopy
fi

echo "🔨"
echo '---'
echo "uuid.upper | bash='$0' param1=uuid.upper terminal=false"
echo "uuid.lower | bash='$0' param1=uuid.lower terminal=false"
echo "to.upper | bash='$0' param1=to.upper terminal=false"
echo "to.lower | bash='$0' param1=to.lower terminal=false"
echo "base64.encode | bash='$0' param1=base64.encode terminal=false"
echo "base64.decode | bash='$0' param1=base64.decode terminal=false"
echo "urlencode | bash='$0' param1=urlencode terminal=false"
echo "urldecode | bash='$0' param1=urldecode terminal=false"
echo "jbeautify | bash='$0' param1=jbeautify terminal=false"
echo "json2csv | bash='$0' param1=json2csv terminal=false"
echo "unix.epoch.s | bash='$0' param1=unix.epoch.s terminal=false"
echo "utc.iso8601 | bash='$0' param1=utc.iso8601 terminal=false"
echo "local.iso8601 | bash='$0' param1=local.iso8601 terminal=false"
echo "utc.YYYY-MM-DD hh:mm:ss | bash='$0' param1='utc.YYYY-MM-DD hh:mm:ss' terminal=false"
echo "local.YYYY-MM-DD hh:mm:ss | bash='$0' param1='local.YYYY-MM-DD hh:mm:ss' terminal=false"
echo "utc.YYYY-MM-DD | bash='$0' param1=utc.YYYY-MM-DD terminal=false"
echo "local.YYYY-MM-DD | bash='$0' param1=local.YYYY-MM-DD terminal=false"
echo "cred.user.stg | bash='$0' param1=cred.user.stg terminal=false"
echo "cred.user.prod | bash='$0' param1=cred.user.prod terminal=false"
echo "---"
