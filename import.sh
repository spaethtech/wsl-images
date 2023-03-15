#!/usr/bin/env bash

SCRIPT_DIR=$(realpath "$( cd -- "$( dirname -- "$(readlink -f "${BASH_SOURCE[0]}")" )" &> /dev/null && pwd )"/.)

ORGANIZATION=spaethtech
IMAGE_NAME=wsl2-php

DEFAULT_VERSION=7.4.33

# shellcheck disable=SC2317
usage() {
    echo "
Usage: import [OPTIONS]

    OPTIONS:
        -h          Displays this helpful information
        -v          The version of PHP to use during the build stage, defaults to $DEFAULT_VERSION
"
}

VERSION=$DEFAULT_VERSION

while getopts hv: OPTIONS; do
    case "${OPTIONS}" in
    h) usage && exit;;
    v) VERSION=${OPTARG};;
    *) exit 1;;
    esac
done

if [ -d "$VERSION" ]; then
    VERSION_DIR=$VERSION
else
    IFS='.' read -ra PARTS <<< "$VERSION"

    case "${#PARTS[@]}" in
    1) VERSION_DIR="${PARTS[0]}.0";;
    2) VERSION_DIR="${PARTS[0]}.${PARTS[1]}";;
    3) VERSION_DIR="${PARTS[0]}.${PARTS[1]}";;
    *) ;;
    esac
fi

echo "Attempting to import version $VERSION..."

if [ ! -d "$VERSION_DIR" ]; then
    echo "Version $VERSION is not currently supported!"
    exit
fi

cd "$VERSION_DIR" || exit

echo "Importing PHP for WSL version $VERSION..."



echo $SCRIPT_DIR

IMAGE_DIR=$HOME/WSL/php/$VERSION
IMAGE_TAG="PHP${PHP_VERSION//./}"
IMAGE_TAR="$SCRIPT_DIR/$VERSION/php-$VERSION.tar"

[ ! -d "$IMAGE_DIR" ] && mkdir -p "$IMAGE_DIR"

echo --import "$IMAGE_TAG" "$IMAGE_DIR" "$IMAGE_TAR"
wsl.exe --import "$IMAGE_TAG" "$IMAGE_DIR" "$IMAGE_TAR"
