function help {
    echo "\nUsage"
    echo "h - help"
    echo "c - complete installation"
    echo "q - quit\n"
    echo "1 - homebrew"
    echo "2 - tools [chrome, wget, ranger, oath-toolkit]"
    echo "3 - terminal [iterm2]"
    echo "4 - shell [zsh]"
    echo "5 - languages [go, node, java]\n  --- For brew installed Go, have the following exports,\
        export GOROOT=/usr/local/opt/go/libexec"
    echo "6 - development tools [atom, mqsql, dbeaver, mysqlworkbench, macvim, postman]"
    echo "7 - virtualization tools [docker]"
    echo "8 - communication tools [slack, skype]"
    echo "9 - media tools [youtube-dl, mpv, cmus]"
    echo "10 - repo [gunasekar/shell, gunasekar/bitbar-plugins]"
    echo "11 - customize_go"
    echo "12 - customize_mpv"
    echo "13 - customise_ytdl"
    echo "14 - add_bitbar_plugins"
    echo "-> Mac AppStore Applications - RDP Client, Monosnap, CopyClip"
    echo "-> Other tools - TadViewer[http://tadviewer.com]"
    echo "-> Youtube browser - pip3 install mps-youtube"
}

function prep_brew {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap caskroom/cask
}

##### tools
function prep_tools {
    brew install wget
    brew install ranger
    brew install oath-toolkit
    brew cask install google-chrome
    brew cask install filezilla
    brew cask install itsycal
    brew install jq
}

##### terminals
function prep_terminal {
    brew cask install iterm2
}

##### shell
function prep_shell {
    brew install zsh zsh-completions
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

##### languages
function prep_languages {
    brew install go
    brew install protobuf
    brew install node
    brew cask install java
    brew install python
}

##### development tools
function prep_dev_tools {
    brew cask install atom
    brew install mysql
    brew cask install dbeaver-community
    brew cask install mysqlworkbench
    brew cask install macvim
    brew cask install postman
    brew install nmap
    brew install textql
}

function prep_docker {
    brew cask install docker
    brew install docker --a
    brew install docker-compose
}

##### communication
function prep_communication {
    brew cask install slack
    brew cask install skype
}

##### media
function prep_media_tools {
    brew install youtube-dl
    brew install mpv
    brew install cmus
}

##### clone the required repos under ~/sources
function prep_repo {
    mkdir ~/sources
    git clone https://github.com/gunasekar/shell.git ~/sources/shell
    git clone https://github.com/gunasekar/bitbar-plugins.git ~/sources/bitbar-plugins
}

##### customize mpv
function customize_mpv {
    ln -s ~/sources/shell/conf/mpv.conf ~/.config/mpv/mpv.conf
}

##### customize youtube-dl
function customize_ytdl {
    touch ~/.config/youtube-dl.conf
    echo "--output \"$HOME/Downloads/media/video/%(title)s.%(ext)s\"" >> ~/.config/youtube-dl.conf
}

##### add bitbar-plugins
function add_bitbar_plugins {
    mkdir -p $HOME/.bitbar-plugins
    for plugin in "$HOME/sources/shell/bitbar-plugins/"*
    do
        fileName=$(basename $plugin)
        echo $fileName
        ln -s $plugin "$HOME/.bitbar-plugins/$fileName"
    done
}

##### create soft-link for GOROOT
function customize_go {
    cd /usr/local/go
    ln -s /usr/local/Cellar/go/1.9.1/go
}

help
echo "\nSelect your action: "
read action
while [ "$action" != "q" ]
do
    case "$action" in
        h)
            help
            ;;

        c)
            prep_brew
            prep_tools
            prep_terminal
            prep_shell
            prep_languages
            prep_dev_tools
            prep_docker
            prep_communication
            prep_media_tools
            prep_repo
            customize_go
            customize_mpv
            customize_ytdl
            add_bitbar_plugins
            ;;

        1)
            prep_brew
            ;;

        2)
            prep_tools
            ;;

        3)
            prep_terminal
            ;;

        4)
            prep_shell
            ;;

        5)
            prep_languages
            ;;

        6)
            prep_dev_tools
            ;;

        7)
            prep_docker
            ;;

        8)
            prep_communication
            ;;

        9)
            prep_media_tools
            ;;

        10)
            prep_repo
            ;;

        11)
            customize_go
            ;;

        12)
            customize_mpv
            ;;

        13)
            customize_ytdl
            ;;

        14)
            add_bitbar_plugins
            ;;

        *)
            echo '\033[31mInvalid Input \033[0m'
            help
            ;;
    esac
    echo "\nSelect your action: "
    read action
done
