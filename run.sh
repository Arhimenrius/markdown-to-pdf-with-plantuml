#!/usr/bin/env bash

NAME='markdown-to-pdf-with-plantuml'

if [[ "$(docker images -q $NAME 2> /dev/null)" == "" ]]; then
    docker build -t $NAME .
fi

DIRECTORY_TO_VOLUME=$1

if [ -z "$DIRECTORY_TO_VOLUME" ]
then
    echo "Please provide path to the directory with files to build"
    exit 0
fi

docker run -v $DIRECTORY_TO_VOLUME:/var/doc $NAME /var/build.sh
