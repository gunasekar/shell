##################### Custom Settings #####################
# export list - makes the local variables globally available
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export PATH=$PATH:$GOPATH/src/github.com/myteksi/go/scripts
export PATH=$PATH:$HOME/Library/Python/3.6/bin

# set environment
source $GOPATH/src/bitbucket.org/recon-engine/scripts/set-env.sh ci

function go_gets {
  go get -u github.com/kardianos/govendor
  go get -u github.com/golang/protobuf/protoc-gen-go
  go get -u golang.org/x/tools/cmd/goimports
  go get -u github.com/vektra/mockery
  go get -u github.com/gorilla/schema
}

start-mysql
start-redis
