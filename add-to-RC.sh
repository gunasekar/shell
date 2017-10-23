#!/bin/bash

sourceRC="source "$(pwd)"/run-control.sh"

function addToRC {
  rc=$1
  if [ -e $rc ]
  then
    printf "\n\n" >> $rc
  	echo "##### Source Files" >> $rc
    echo $sourceRC >> $rc

    aliasFile="$HOME/.alias.sh"
    if [ ! -e $aliasFile ]
    then
      touch $aliasFile
    fi

    echo "source ~/.alias.sh" >> $rc

    customFile="$HOME/.custom.sh"
    if [ ! -e $customFile ]
    then
      touch $customFile
    fi

    echo "source ~/.custom.sh" >> $rc
    echo $rc "found. Added the requested sources."
  else
    echo $rc "not found. Ignored."
  fi
}

file="$HOME/.zshrc"
addToRC $file

file="$HOME/.bash_profile"
addToRC $file
