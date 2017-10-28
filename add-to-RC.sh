#!/bin/bash

function appendToFile {
    if grep -q "$1" "$2"; then
        echo $1 "was already added to" $2
    else
        printf "\n" >> $2
        echo $1 >> $2
        echo "Added the requested source -" $1
    fi
}

function addToRC {
    rc=$1
    if [ -e $rc ]
    then
        echo "$rc found! Adding sources..."
        appendToFile "source $(pwd)/run-control.sh" "$rc"

        echo "Do you want to add aliases and custom sources for Grab?(y/n)"
        read action
        if [ "$action" == "y" ]; then
            appendToFile "source $(pwd)/grab/alias.sh" $rc
            appendToFile "source $(pwd)/grab/custom.sh" $rc
        fi
    else
        echo $rc "not found. Ignored."
    fi
}

file="$HOME/.zshrc"
addToRC $file

file="$HOME/.bash_profile"
addToRC $file
