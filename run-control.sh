##### general
alias load-bash="source ~/.bashrc"
alias load-zsh="source ~/.zshrc"
alias uts="date +%s"
alias play="mpv -shuffle *"
alias gs="git status"
alias gc="git commit"

function add-alias-to-zsh {
	echo "alias $1=\"cd $(pwd)\"" >> ~/.alias.sh
	echo "[alias $1=\"cd $(pwd)\"] is added to ~/.alias.sh"
}

function enable-ubuntu-partners-repo {
	sudo sed -i.bak "/^# deb .*partner/ s/^# //" /etc/apt/sources.list
}

##### oath-toolkit
function totp {
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

##### redis
alias redis-start="launchctl start io.redis.redis-server"
alias redis-stop="launchctl stop io.redis.redis-server"

##### mysql
function start-mysql {
	UP=$(pgrep mysql | wc -l);
	if [ "$UP" -ne 1 ];
	then
	        echo "MySQL is down.";
	        mysql.server start

	else
	        echo "MySQL is already up.";
	fi
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

##### youtube-dl

function dl-audio {
	youtube-dl -x --audio-format mp3 --audio-quality 0 "$1"
}

function dl-video {
	youtube-dl "$1"
}

##### custom
function play_sound {
	if hash aplay 2>/dev/null; then
	    aplay "$@"
	else
	    afplay "$@"
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
	pacdies=$(get-audio)
	if [[ $# -gt 0 ]]; then
		# Assume a PID has been passed
		while [[ $(ps -e | grep $1 | wc -l) != "0" ]]; do
		sleep 1
		done

		play_sound $pacdies
	else
		play_sound $pacdies
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

		play_sound $pacdies
	else
		play_sound $pacdies
	fi
}

function notify-after {
	notify-after-fg "$@" &
}

function get-latest-songs {
	base_url="http://www.sunmusiq.com"
	echo "Tamil"
	wget -qO- "$base_url/all-process.asp?action=LoadChannelsTamil" | grep 'tamil_movie_songs_listen_download.asp?MovieId=' | grep 'title' | awk '{$1=$1};1'
	echo "\nTamilPop"
	wget -qO- "http://www.sunmusiq.com/all-process.asp?action=LoadChannelsTamilPop" | grep 'tamil_movie_songs_listen_download.asp?MovieId=' | grep 'title' | awk '{$1=$1};1'
	echo "\nMalayalam"
	wget -qO- "http://www.sunmusiq.com/all-process.asp?action=LoadChannelsMalayalam" | grep 'tamil_movie_songs_listen_download.asp?MovieId=' | grep 'title' | awk '{$1=$1};1'
	echo "\nTelugu"
	wget -qO- "http://www.sunmusiq.com/all-process.asp?action=LoadChannelsTelugu" | grep 'tamil_movie_songs_listen_download.asp?MovieId=' | grep 'title' | awk '{$1=$1};1'
	echo "\nHindi"
	wget -qO- "http://www.sunmusiq.com/all-process.asp?action=LoadChannelsHindi" | grep 'tamil_movie_songs_listen_download.asp?MovieId=' | grep 'title' | awk '{$1=$1};1'
}

function download-320kbps-starmusiq {
	base_url="http://www.sunmusiq.com"
	for id in $@
	do
		find="download-7s-zip-new/"
		find_quoted=$(printf '%s' "$find" | sed 's/[#\]/\\\0/g')
		replace="download-7s-zip-new/download-3.ashx"
		replace_quoted=$(printf '%s' "$replace" | sed 's/[#\]/\\\0/g')
		download_url=$(wget -qO- $base_url/tamil_movie_songs_listen_download.asp\?MovieId\=$id | grep -E 'http://www.starfile.info/download-7s-zip-new/\?Token=[\w=]*' |	grep -E '320' | grep -Eoi '<a [^>]+>' | grep -Eo 'href="[^\"]+"'| grep -Eo '(http|https)://[^ "]+' | sed -e "s#$find_quoted#$replace_quoted#g")
		echo "Downloading..." $download_url
		wget $download_url -O $id.zip
	done
}

function download-and-unzip-320kbps-starmusiq {
	download-320kbps-starmusiq $@
	for id in $@
	do
		unzip $id.zip
		rm -f $id.zip
	done
}

function yt-dl {
	mkdir -p "$HOME/Downloads/Videos"
	youtube-dl -o "$HOME/Downloads/Videos/%(title)s.%(ext)s" $@
}

function show-cal {
	cal | grep --before-context 6 --after-context 6 --color -e " $(date +%e)" -e "^$(date +%e)"
}
