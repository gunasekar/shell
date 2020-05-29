function help {
    echo "\nUsage"
    echo "h - help"
    echo "c - complete installation"
    echo "q - quit\n"
    echo "1 - homebrew"
    echo "2 - tools"
    echo "3 - terminal"
    echo "4 - shell"
    echo "5 - languages"
    echo "6 - development tools"
    echo "7 - virtualization tools"
    echo "8 - communication tools"
    echo "9 - media tools"
    echo "10 - repo [gunasekar/shell]"
    echo "11 - customize_mpv"
    echo "12 - customise_ytdl"
    echo "13 - add_bitbar_plugins"
    echo "-> Mac AppStore Applications - Monosnap, CopyClip"
}

function prep_brew {
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function install_brew {
    for i in $*; do
        if ! brew list $i &>/dev/null; then
            echo "Installing $i"
            brew install $i
        else
            echo "$i already installed"
        fi
    done
}

function install_brew_cask {
    for i in $*; do
        if ! brew cask list $i &>/dev/null; then
            echo "Installing $i"
            brew cask install $i
        else
            echo "$i already installed"
        fi
    done
}

##### tools
function prep_tools {
    install_brew wget ranger oath-toolkit jq
    install_brew_cask google-chrome filezilla itsycal bitbar
}

##### terminals
function prep_terminal {
    install_brew_cask iterm2
}

##### shell
function prep_shell {
    install_brew zsh zsh-completions
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

##### languages
function prep_languages {
    install_brew go protobuf node python
}

##### development tools
function prep_dev_tools {
    # CLIs
    install_brew mycli pgcli bitwarden-cli awscli aws-okta
    
    # P Tools
    install_brew wget oath-toolkit jq nmap textql gist tig graphviz fzf
    
    # Shell tools
    install_brew htop ranger watch tree

    # CASK - Editors
    install_brew_cask atom sublime-text  visual-studio-code
    
    # CASK - UI tools
    install_brew_cask dbeaver-community postman fork boostnote
}

function prep_docker {
    install_brew docker-compose kubectl
    install_brew_cask docker
}

##### communication
function prep_communication {
    install_brew_cask slack skype
}

##### media
function prep_media_tools {
    install_brew youtube-dl mpv
}

##### clone the required repos under $HOME/setup
function prep_repo {
    git clone https://github.com/gunasekar/shell.git $HOME/setup/shell
}

##### customize mpv
function customize_mpv {
    mkdir -p $HOME/.config/mpv
    ln -sf ~/setup/shell/conf/mpv.conf ~/.config/mpv/mpv.conf
}

##### customize youtube-dl
function customize_ytdl {
    mkdir -p $HOME/.config
    touch ~/.config/youtube-dl.conf
    echo "--output \"$HOME/Downloads/media/video/%(title)s.%(ext)s\"" >> ~/.config/youtube-dl.conf
}

##### add bitbar-plugins
function add_bitbar_plugins {
    mkdir -p $HOME/.bitbar-plugins
    for plugin in "$HOME/setup/shell/bitbar-plugins/"*
    do
        fileName=$(basename $plugin)
        echo $fileName
        ln -sf $plugin "$HOME/.bitbar-plugins/$fileName"
    done
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
            customize_mpv
            ;;

        12)
            customize_ytdl
            ;;

        13)
            add_bitbar_plugins
            ;;

        *)
            echo '\033[31mInvalid Input \033[0m'
            ;;
    esac
    help
    echo "\nSelect your action: "
    read action
done
