/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask

##### tools
brew cask install google-chrome
brew install wget
brew install ranger
brew install oath-toolkit

##### terminals
brew cask install iterm2

##### shell
brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

##### languages
brew install go
brew install node
brew cask install java

##### development tools
brew cask install atom
brew install mysql
brew cask install dbeaver-community
brew cask install mysqlworkbench
brew cask install macvim
brew cask install postman
brew install mono
brew cask install fiddler
brew install docker --a
brew install docker-compose

##### communication
brew cask install slack
brew cask install skype

##### media
brew install youtube-dl
brew install mpv
brew install cmus

##### clone the required repos under ~/sources
mkdir ~/sources
cd ~/sources
git clone https://github.com/gunasekar/shell.git
git clone https://github.com/gunasekar/bitbar-plugins.git

##### customize mpv
cd ~/.config/mpv/
ln -s ~/sources/shell/conf/mpv.conf mpv.conf
cd ~

##### add bitbar-plugins
mkdir ~/.bitbar-plugins
cd ~/.bitbar-plugins
ln -s ~/sources/shell/bitbar-plugins/totp.20s.sh totp.20s.sh
ln -s ~/sources/bitbar-plugins/Music/cmus.10s.sh cmus.10s.sh
cd ~

##### create soft-link for GOROOT
cd /usr/local/go
ln -s /usr/local/Cellar/go/1.9.1/ go

echo "Mac AppStore Applications - RDP Client, Monosnap"
