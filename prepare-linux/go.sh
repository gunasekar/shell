echo "Paste the latest go url from https://golang.org/dl/ :"
read gourl
wget -c $gourl -O ~/Downloads/go.tar.gz
sudo tar -C /usr/local -xvzf ~/Downloads/go.tar.gz
mkdir -p ~/go/{bin,src,pkg}
