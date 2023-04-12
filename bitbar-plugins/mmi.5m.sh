#!/bin/bash

# <bitbar.title>Market Mood Index</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>Gunasekaran Namachivayam</bitbar.author>
# <bitbar.author.github>gunasekar</bitbar.author.github>
# <bitbar.desc>This plugin will show the market mood index</bitbar.desc>

# Hack for language not being set properly and unicode support
export LANG="${LANG:-en_US.UTF-8}"
export jqCommand="/opt/homebrew/bin/jq"

declare -a sentiments=("🟢" "🟠" "🟠" "🔴")
indicator=$(curl -s "https://api.smallcase.com/market/indices/marketMoodIndex" | $jqCommand '.data.current.indicator' )
printf -v i2f "%.2f" $indicator
printf -v i "%.f" $indicator
let segment=$i/25
sentiment=${sentiments[$segment]}
echo "$sentiment$i2f"