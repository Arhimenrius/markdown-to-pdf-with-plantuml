#!/usr/bin/env bash
set -eu

NAME='markdown-to-pdf-with-plantuml'

if [[ "$(docker images -q $NAME 2> /dev/null)" == "" ]]; then
    SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
    docker build -t $NAME -f "$SCRIPT_DIR/Dockerfile" "$SCRIPT_DIR"
fi

DIRECTORY_TO_VOLUME=$1

if [ -z "$DIRECTORY_TO_VOLUME" ]
then
    echo "Please provide path to the directory with files to build"
    exit 0
fi

docker run --rm -v "$DIRECTORY_TO_VOLUME":/var/doc $NAME /var/build.sh
