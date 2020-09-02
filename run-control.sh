#!/bin/bash

##### constants
audioDir="$HOME/Downloads/media/audio"
videoDir="$HOME/Downloads/media/video"

##### zshrc key bindings
case $SHELL in
    */zsh)
    unameOut="$(uname -s)"
    case "${unameOut}" in
        Linux*)
        ;;
        Darwin*)
        bindkey -e
        bindkey '[C' forward-word
        bindkey '[D' backward-word
        ;;
        CYGWIN*)
        ;;
        MINGW*)
        ;;
        *)
        echo "Unknown system";;
    esac
    ;;
esac

##### general
mkdir -p $HOME/.binaries
export PATH=$PATH:$HOME/.binaries

alias load-bash="source $HOME/.bashrc"
alias load-zsh="source $HOME/.zshrc"
alias load-rc="source $HOME/setup/shell/run-control.sh"
alias uts="date +%s"
alias play="mpv -shuffle * &"
alias ad="cd $audioDir"
alias vd="cd $videoDir"
alias vdr="cd $videoDir; ranger"
alias shout-tamil="shoutcast tamil 15"
alias bw-search="bw list items --search $1"

if hash dpkg 2>/dev/null; then
    alias remove-unused-kernels="sudo apt-get purge $(dpkg -l linux-{image,headers}-"[0-9]*" | awk '/ii/{print $2}' | grep -ve "$(uname -r | sed -r 's/-[a-z]+//')")"
fi

function add-alias-to-zsh {
    echo "alias $1=\"cd $(pwd)\"" >> ~/.alias.sh
    echo "[alias $1=\"cd $(pwd)\"] is added to ~/.alias.sh"
}

function binplace {
    mkdir -p $HOME/.binaries/
    cp $1 $HOME/.binaries/
    chmod 755 $HOME/.binaries/*
}

function enable-ubuntu-partners-repo {
    sudo sed -i.bak "/^# deb .*partner/ s/^# //" /etc/apt/sources.list
}

function whoisusing {
    lsof -i tcp:$1
}

##### oath-toolkit
function totp {
    if ! hash oathtool 2>/dev/null; then
        echo "oath-toolkit not found. brewing..."
        brew install oath-toolkit
    fi

    for secret in "${totp_secrets[@]}" ; do
        KEY="${secret%%:*}"
        VALUE="${secret##*:}"
        TOKEN="$( oathtool --totp -b $VALUE )"
        echo "$KEY: $TOKEN"
    done
}

##### ssh
function test-SSH-github {
    ssh -T git@github.com
}

function test-SSH-bitbucket {
    ssh -T git@bitbucket.org
}

function test-SSH-gitlab {
    ssh -T git@gitlab.com
}

function get-ssh-pubkey {
    if hash pbcopy 2>/dev/null; then
        pbcopy < ~/.ssh/id_rsa.pub
    else
        xclip -selection c ~/.ssh/id_rsa.pub
    fi
}

function get-gpg-pubkey {
    if hash pbcopy 2>/dev/null; then
        gpg --armor --export $1 | pbcopy
    else
        gpg --armor --export $1 | xclip -selection c
    fi
}

function generate-ssh-key {
    ssh-keygen -t rsa -b 4096 -C "$1"
}

function set-sudo-wo-pwd {
    user=$(whoami)
    if hash pbcopy 2>/dev/null; then
        echo "$user    ALL=(ALL) NOPASSWD: ALL" | pbcopy
    else
        echo "$user    ALL=(ALL) NOPASSWD: ALL" | xclip -selection c
    fi

    sudo visudo
}

##### aws
export AWS_SDK_LOAD_CONFIG=1

function show-aws-creds {
    cat ~/.aws/credentials
}

##### mysql
function del-all-mysql-db {
    mysql -uroot -p -e "show databases" | grep -v Database | grep -v mysql| grep -v information_schema| awk '{print "drop database " $1 ";select sleep(0.1);"}' | mysql -uroot -p
}

##### golang
function go-build-linux {
    if [ "$1" = "" ]; then
        env GOOS=linux GOARCH=amd64 go build -o main-linux
    else
        env GOOS=linux GOARCH=amd64 go build -o $1-linux
    fi
}

function go-test-coverage {
    go test -coverprofile=coverage.out
    go tool cover -html=coverage.out
}

function go-test-all {
    GOCACHE=off go test ./...
}

##### Docker
function docker-stop-all {
    docker stop $(docker ps -aq)
}

function docker-start-all {
    docker start $(docker ps -aq)
}

function docker-rm-all-containers {
    docker rm $(docker ps -aq)
}

function docker-rm-all-images {
    docker rmi $(docker images -aq)
}

function docker-ips {
    docker inspect -f '{{.Name}} - {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker ps -aq)
}

##### mpv
alias stream-yt-1080='mpv --ytdl-format=137 $1'
alias stream-yt-720='mpv --ytdl-format=22 $1'
alias stream-yt-360='mpv --ytdl-format=18 $1'
alias stream-hs-360='mpv --ytdl-format=hls-861 $1'
alias stream-fb-sd='mpv --ytdl-format=dash_sd_src $1'
alias stream-fb-hd='mpv --ytdl-format=dash_hd_src $1'

##### youtube-dl
function youtube-dl_video_and_audio_best_no_mkv_merge {
  video_type=$(youtube-dl -F "$@" | grep "video only" | awk '{print $2}' | tail -n 1)
  case $video_type in
    mp4)
      youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' -o "$videoDir/%(title)s.%(ext)s" "$@";;
    webm)
      youtube-dl -f 'bestvideo[ext=webm]+bestaudio[ext=webm]' -o "$videoDir/%(title)s.%(ext)s" "$@";;
    *)
      echo "New best videoformat detected - $video_type, please check it out!";;
  esac
}

function dl-audio {
    if ! hash youtube-dl 2>/dev/null; then
        echo "youtube-dl not found. brewing..."
        brew install youtube-dl
    fi

    mkdir -p $audioDir
    for id in $@
    do
        youtube-dl -x --audio-format mp3 -o "$audioDir/%(title)s.%(ext)s" $@
    done
}

function dl-video {
    if ! hash youtube-dl 2>/dev/null; then
        echo "youtube-dl not found. brewing..."
        brew install youtube-dl
    fi

    mkdir -p $videoDir
    for id in $@
    do
        youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]' -o "$videoDir/%(title)s.%(ext)s" "$id"
        #youtube-dl_video_and_audio_best_no_mkv_merge $@
    done
}

##### custom
function get-open-ports {
    if ! hash nmap 2>/dev/null; then
        echo "nmap not found. brewing..."
        brew install nmap
    fi

    ip=$(ifconfig | grep -e 'inet.*broadcast' | awk  '{print $2}')
    nmap $ip/24 | grep "open" -B 4
}

function play_sound {
    if hash afplay 2>/dev/null; then
        afplay "$(get-audio)"
    else
        i=5
        while [ $i -ge 0 ]; do
            echo -ne '\007'
            sleep 0.5
            ((i--))
        done
    fi
}

function get-audio {
    local pacdies=~/.pacdies.mp3
    if ! [ -f $pacdies ]; then
        wget "https://raw.githubusercontent.com/gunasekar/shell/master/pacdies.mp3" -O $pacdies
    fi

    echo $pacdies
}

function notify-on-completion-fg {
    if [[ $# -gt 0 ]]; then
        # Assume a PID has been passed
        while [[ $(ps -e | grep $1 | wc -l) != "0" ]]; do
            sleep 1
        done

        play_sound
    else
        play_sound
    fi
}

function notify-on-completion {
    notify-on-completion-fg "$@" &
}

function notify-after-fg {
    pacdies=$(get-audio)
    if [[ $# -gt 0 ]]; then
        # Assume number of seconds has been passed
        sleep $1

        play_sound
    else
        play_sound
    fi
}

function notify-after {
    notify-after-fg "$@" &
}

##### music related
function get-metadata {
    ffprobe $@ 2>&1 | grep -A20 'Metadata:'
}

function search-albums {
    if ! hash jq 2>/dev/null; then
        echo "jq not found. brewing..."
        brew install jq
    fi

    result=$(curl -s "http://www.starmusiq.top/all-process.asp?action=LoadSearchKeywords&dataType=json&query=$1")
    #echo $result | jq "[.[] | select( .type | contains(\"album\"))]" | jq ".[] | .movie,.link"
    #echo $result | jq "[.[] | select( .type | contains(\"album\"))]" | jq ".[] | .movie,(.link | split(\"?\") | last)"
    #echo $result | jq "[.[] | select( .type | contains(\"album\"))]" | jq "[.[] | { movie:.movie, link:(.link | split(\"?\") | last)}]"
    echo $result | jq "[.[] | select( .type | contains(\"album\"))]" | jq "[.[] | { movie:.movie, link:(.link | split(\"?\") | last)}]" | jq ".[] | \"\(.movie) --> \(.link)\""
}

function dl-albums {
    if ! hash wget 2>/dev/null; then
        echo "wget not found. brewing..."
        brew install wget
    fi

    for id in $@
    do
        find="download-7s-zip-new/"
        find_quoted=$(printf '%s' "$find" | sed 's/[#\]/\\\0/g')
        replace="download-7s-zip-new/download-4.ashx"
        replace_quoted=$(printf '%s' "$replace" | sed 's/[#\]/\\\0/g')
        download_url=$(wget -qO- http://www.starmusiq.top/tamil_movie_songs_listen_download.asp\?MovieId\=$id | grep -E 'http://www.starfile.pw/download-7s-zip-new/\?Token=[\w=]*' |	grep -E '320' | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"'| grep -Eo '(http|https)://[^ "]+' | sed -e "s#$find_quoted#$replace_quoted#g")
        echo "Downloading..." $download_url
        mkdir -p $audioDir
        wget $download_url -O $audioDir/$id.zip
        unzip $audioDir/$id.zip -d $audioDir
        rm -f $audioDir/$id.zip
    done
}

function shoutcast {
    if ! hash curl 2>/dev/null; then
        echo "curl not found. brewing..."
        brew install curl
    fi
    
    result=$(curl 'http://directory.shoutcast.com/Search/UpdateSearch' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' --data 'query='$1'')
    noOfStations=$(echo $result | jq ". | length")
    echo "$noOfStations found"
    if [ $# -ge 2 ]
    then
        noOfStations=$2
        echo $result | jq ".[0:$2]" | jq ".[] | \"\(.ID) --> \(.Name) ... Bitrate: \(.Bitrate) ... Listeners: \(.Listeners)\""
    else
        echo $result | jq ".[] | \"\(.ID) --> \(.Name) ... Bitrate: \(.Bitrate) ... Listeners: \(.Listeners)\""
    fi

    while true ;
    do
        printf "Select the stationID from the above stations: "
        read -r stationID
        if echo $result | grep -q "\"ID\":$stationID,"; then
            break
        else
            echo -e "\e[1;31mInvalid stationID!\e[0m"
        fi
    done

    stationName=$(echo $result | jq ".[] | if .ID == $stationID then \"\(.Name)\" else null end" | sed '/null/d' | sed -e 's/^"//' -e 's/"$//')
    echo "Playing station - $stationName"
    play-shoutcast-station $stationID
}

function play-shoutcast-station {
    if ! hash curl 2>/dev/null; then
        echo "curl not found. brewing..."
        brew install curl
    fi

    result=$(curl 'http://directory.shoutcast.com/Player/GetStreamUrl' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' --data 'station='$1'')
    # first sed removes the double quotes prefix and suffix. second sed removes '?icy=http'
    link=$(sed -e 's/^"//' -e 's/"$//' <<<"$result" | sed "s/?icy=http//")
    mpv $link
}

function merge-lines {
    if [[ $# != 2 ]]
    then
        echo "usage: merge-lines <file_path> <lines_to_merge>\nexample:\nmerge-lines payload.csv 5"
    else
        param='{line=line "," $0} NR%'$2'==0{print substr(line,2); line=""}'
        awk $param $1 > $1_merged_$2_lines.csv
        [ $? -eq 0 ] && echo "merged to $1_merged_$2_lines.csv" || echo "merge failed" >&2
    fi
}

function setup_vim_awesome {
    if [ ! -d "$HOME/.vim_runtime" ]
    then
        echo "$HOME/.vim_runtime not present. Setting up...\n"
        git clone --depth=1 https://github.com/amix/vimrc.git $HOME/.vim_runtime
        sh $HOME/.vim_runtime/install_awesome_vimrc.sh
    else
        echo "$HOME/.vim_runtime found. Updating...\n"
        bash -c 'cd $HOME/.vim_runtime ; git reset --hard origin/master ; git pull --rebase ; pip3 install --upgrade requests ; python3 update_plugins.py'
    fi
}

function check_temperature {
    if ! hash smc 2>/dev/null;
    then
        echo "/usr/local/bin/smc not present. Setting up...\n"
        curl -LO http://www.eidac.de/smcfancontrol/smcfancontrol_2_4.zip && unzip -d temp_dir_smc smcfancontrol_2_4.zip && cp temp_dir_smc/smcFanControl.app/Contents/Resources/smc /usr/local/bin/smc ; rm -rf temp_dir_smc smcfancontrol_2_4.zip
    else
        FAHRENHEIT=false
        TEMPERATURE_WARNING_LIMIT=65
        TEMPERATURE=$(/usr/local/bin/smc -k TC0P -r | sed 's/.*bytes \(.*\))/\1/' |sed 's/\([0-9a-fA-F]*\)/0x\1/g' | perl -ne 'chomp; ($low,$high) = split(/ /); print (((hex($low)*256)+hex($high))/4/64); print "\n";')
        TEMP_INTEGER=${TEMPERATURE%.*}

        if $FAHRENHEIT ; then
        TEMP_INTEGER=$((TEMP_INTEGER*9/5+32))
        LABEL="°f"
        else
        LABEL="°c"
        fi

        if [ "$TEMP_INTEGER" -gt "$TEMPERATURE_WARNING_LIMIT" ] ; then
        ICON="🔥"
        else
        ICON=""
        fi
        echo "$ICON${TEMP_INTEGER}$LABEL"
    fi
}