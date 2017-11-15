##### constants
music_url="http://www.sunmusiq.com"
audioDir="$HOME/Downloads/media/audio/"
videoDir="$HOME/Downloads/media/video/"

##### general
alias load-bash="source ~/.bashrc"
alias load-zsh="source ~/.zshrc"
alias uts="date +%s"
alias play="mpv -shuffle *"

function add-alias-to-zsh {
    echo "alias $1=\"cd $(pwd)\"" >> ~/.alias.sh
    echo "[alias $1=\"cd $(pwd)\"] is added to ~/.alias.sh"
}

function enable-ubuntu-partners-repo {
    sudo sed -i.bak "/^# deb .*partner/ s/^# //" /etc/apt/sources.list
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

##### aws
export AWS_SDK_LOAD_CONFIG=1

function show-aws-creds {
    cat ~/.aws/credentials
}


##### golang
function go-build-linux {
    if [ "$1" = "" ]; then
        env GOOS=linux GOARCH=amd64 go build -o main-linux
    else
        env GOOS=linux GOARCH=amd64 go build -o $1-linux
    fi
}

##### mysql
function start-mysql {
    brew services start mysql | 2>&1 > /dev/null
}

function start-redis {
    brew services start redis | 2>&1 > /dev/null
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
    youtube-dl -x --audio-format mp3 --audio-quality 0 -o "$audioDir/%(title)s.%(ext)s" $@
}

function dl-video {
    if ! hash youtube-dl 2>/dev/null; then
        echo "youtube-dl not found. brewing..."
        brew install youtube-dl
    fi

    mkdir -p $videoDir
    youtube-dl_video_and_audio_best_no_mkv_merge $@
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

function process-page {
    curl -s "$music_url/all-process.asp?action=$1" | grep 'tamil_movie_songs_listen_download.asp?MovieId=' | grep 'title' | awk '{$1=$1};1' | awk -F'?' '{ print $2 }' | awk -F'>' '{ print $1 }'
}

function get-latest-songs {
    array=( "LoadChannelsTamil" "LoadChannelsTamilPop" "LoadChannelsMalayalam" "LoadChannelsTelugu" "LoadChannelsHindi" )
    for item in "${array[@]}" ; do
        echo $item
        process-page "$item"
        echo '\n'
    done
}

function search-albums {
    if ! hash jq 2>/dev/null; then
        echo "jq not found. brewing..."
        brew install jq
    fi

    result=$(curl -s "$music_url/all-process.asp?action=LoadSearchKeywords&query=$1")
    #echo $result | jq "[.[] | select( .type | contains(\"album\"))]" | jq ".[] | .movie,.link"
    #echo $result | jq "[.[] | select( .type | contains(\"album\"))]" | jq ".[] | .movie,(.link | split(\"?\") | last)"
    #echo $result | jq "[.[] | select( .type | contains(\"album\"))]" | jq "[.[] | { movie:.movie, link:(.link | split(\"?\") | last)}]"
    echo $result | jq "[.[] | select( .type | contains(\"album\"))]" | jq "[.[] | { movie:.movie, link:(.link | split(\"?\") | last)}]" | jq ".[] | \"\(.movie) --> \(.link)\""
}

function download-320kbps-starmusiq {
    if ! hash wget 2>/dev/null; then
        echo "wget not found. brewing..."
        brew install wget
    fi

    for id in $@
    do
        find="download-7s-zip-new/"
        find_quoted=$(printf '%s' "$find" | sed 's/[#\]/\\\0/g')
        replace="download-7s-zip-new/download-3.ashx"
        replace_quoted=$(printf '%s' "$replace" | sed 's/[#\]/\\\0/g')
        download_url=$(wget -qO- $music_url/tamil_movie_songs_listen_download.asp\?MovieId\=$id | grep -E 'http://www.starfile.info/download-7s-zip-new/\?Token=[\w=]*' |	grep -E '320' | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"'| grep -Eo '(http|https)://[^ "]+' | sed -e "s#$find_quoted#$replace_quoted#g")
        echo "Downloading..." $download_url
        mkdir -p $audioDir
        wget $download_url -O $audioDir/$id.zip
    done
}

function download-and-unzip-320kbps-starmusiq {
    download-320kbps-starmusiq $@
    for id in $@
    do
        unzip $audioDir/$id.zip -d $audioDir
        rm -f $audioDir/$id.zip
    done
}
