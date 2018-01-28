# shell [![Build Status](https://travis-ci.org/gunasekar/shell.svg?branch=master)](https://travis-ci.org/gunasekar/shell)

run-control.sh is a script to set up your shell with productive environment settings

## Requirements

Ideally any shell should be supported. bash and zsh shells are tested though. Some commands are supported only if the corresponding packages are available.

## How to use
Download the script:

```sh
curl --remote-name https://raw.githubusercontent.com/gunasekar/shell/master/run-control.sh
```

or

```sh
wget https://raw.githubusercontent.com/gunasekar/shell/master/run-control.sh
```

Review the script (avoid running scripts you haven't read!):

```sh
less run-control.sh
```

Apply the downloaded run-controls by appending the following line in your .bashrc or .zshrc:

```sh
source run-control.sh
```

## What it provides you

Commands and aliases which helps increase your productivity,

* `uts` prints the unix time stamp
* `load-bash`, `load-zsh` loads the .bashrc and .zshrc correspondingly
* `totp` prints the totp provided $totp_secrets variable is set in the running environment. Sample secrets `totp_secrets=( "GitHub:ABCDE01234" "BitBucket:ABCDE01234" )`
* `test-SSH-github`, `test-SSH-bitbucket`, `test-SSH-gitlab` to test the connection with the SCM services
* `generate-ssh-key`, `get-ssh-pubkey` and `get-gpg-pubkey` helps in handling the SSH and GPG related actions
* `show-aws-cred` prints your AWS access secrets
* `start-mysql` and `start-redis` starts the corresponding services under brew if not running
* `go-build-linux` builds your go project for linux environment (useful when working in mac)
* `get-open-ports` show the open ports from all IPs in the local subnet
* `docker-stop-all`, `docker-start-all`, `docker-rm-all-containers`, `docker-rm-all-images`, `docker-ips`  helps in handling docker objects
* `enable-ubuntu-partners-repo` enables the ubuntu partners repo for apt package management
* `shoutcast` lists all the stations based on the query value and plays the selected station id
* `dl-audio`, `dl-video`,  downloads the audio/video in highest available quality in mp3 format using youtube-dl for the provided url
* `play` plays the media files from the current directory using mplayer in a shuffled manner
* `notify-after <seconds>` notifies you after given number of seconds and `notify-on-completion <pid>` notifies upon the completion of given PID
* `search-albums` and `dl-albums` downloads 320Kbps songs from starfile.info for the given list of Movie IDs. Search for any movie name and get the movie id and pass it to download commands
* `stream-yt-720`, `stream-yt-360`, `stream-fb-hd`, `stream-fb-sd` streams the youtube and facebook videos


## BitBar Plugins
Plugin repository for BitBar https://getbitbar.com
* totp.20s.sh - Generates totp tokens every 20s. Allows to copy values to clipboard upon mouse click from BitBar Menu. Change the file name to customise the refresh rate.

## Mac Installations
Download the script:

```sh
curl --remote-name https://raw.githubusercontent.com/gunasekar/shell/master/prepare-mac.sh
```

## License

shell is free software and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: LICENSE
