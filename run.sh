#!/usr/bin/env sh

NAME='markdown-to-pdf-with-plantuml'

if [ "$(docker images -q $NAME 2> /dev/null)" = "" ]; then
    docker build -t $NAME . || exit 1
fi

DIRECTORY_TO_VOLUME="$1"

if [ -z "$DIRECTORY_TO_VOLUME" ]; then
    echo "Please provide path to the directory with files to build" >&2
    exit 1
fi

docker run -v "$DIRECTORY_TO_VOLUME":/var/doc $NAME /var/build.sh || exit 1
