# shell

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

1. `uts` prints the unix time stamp
2. `load-bash` loads the .bashrc
3. `load-zsh` loads the .zshrc
4. `notify-after <seconds>` notifies you after given number of seconds and `notify-on-completion <pid>` notifies upon the completion of given PID
5. `start-mysql` starts the mysql server if not running
6. `go-build-linux` builds your go project for linux environment (useful when working in mac)
7. `redis-start` starts the redis server provided redis is installed
8. `redis-stop` stops the redis server provided redis is installed
9. `show-aws-cred` prints your AWS access secrets
10. `docker-stop-all` stops all the running containers
11. `docker-start-all` starts all the containers
12. `docker-rm-all-containers` removes all the containers
13. `docker-rm-all-images` removes all the images
14. `docker-ips` prints the network details of the docker containers
15. `dl-audio` downloads the audio in highest available quality in mp3 format using youtube-dl for the provided url
16. `dl-video` downloads the video in highest available quality using youtube-dl for the provided url
17. `play` plays the media files from the current directory using mplayer in a shuffled manner
18. `download-320kbps-starmusiq` and `download-and-unzip-320kbps-starmusiq` downloads 320Kbps songs from StarMusiq fpr the given list of Movie IDs

## BitBar Plugins
Plugin repository for BitBar https://getbitbar.com
1. totp.20s.sh - Generates totp tokens every 20s. Allows to copy values to clipboard upon mouse click from BitBar Menu. Change the file name to customise the refresh rate.

## License

shell is free software and may be redistributed under the terms specified in the [LICENSE] file.

[LICENSE]: LICENSE
