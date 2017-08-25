##### general
alias load-bash="source ~/.bashrc"
alias load-zsh="source ~/.zshrc"
alias uts="date +%s"
alias play="mpv -shuffle *"
alias gs="git status"
alias gc="git commit"

##### aws
export AWS_SDK_LOAD_CONFIG=1

function show-aws-creds {
	cat ~/.aws/credentials
}


##### golang
export GOROOT=/usr/local/go
export GOPATH=/Users/guna/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

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
