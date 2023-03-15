#!/usr/bin/env bash

SCRIPT_DIR=$(realpath "$( cd -- "$( dirname -- "$(readlink -f "${BASH_SOURCE[0]}")" )" &> /dev/null && pwd )"/.)

ORGANIZATION=spaethtech
IMAGE_NAME=wsl2-php

DEFAULT_PHP_VERSION=7.4.33

# shellcheck disable=SC2317
usage() {
    echo "
Usage: build [OPTIONS]

    OPTIONS:
        -d          Deploys the image into WSL as a new distribution
        -h          Displays this helpful information
        -v          The version of PHP to use during the build stage, defaults to $DEFAULT_PHP_VERSION
"
}

DEPLOY=0
PHP_VERSION=$DEFAULT_PHP_VERSION

while getopts hdv: OPTIONS; do
    case "${OPTIONS}" in
    h) usage && exit;;
    d) DEPLOY=1;;
    v) PHP_VERSION=${OPTARG};;
    *) exit 1;;
    esac
done

#if [[ "$(docker images -q "$ORGANIZATION/$IMAGE_NAME:base" 2>/dev/null)" == "" ]] || [ $REBUILD == 1 ]; then
#    cd base || exit
#    echo "Building the BASE image..."
#    docker build --force-rm --tag "$ORGANIZATION/$IMAGE_NAME:base" .
#    cd .. || exit
#else
#    echo "Using the existing BASE image"
#fi

IFS="." read -r -a parts <<< "$PHP_VERSION"

case "${#parts[@]}" in
    0|1) usage && exit;;
    2) VERSION_DIR="${parts[0]}.${parts[1]}"; PHP_VERSION=${PHP_VERSION}.0;;
    3) VERSION_DIR="${parts[0]}.${parts[1]}";;
    *) exit 1;;
esac

case "$VERSION_DIR" in
    7.4) [[ "${parts[2]}" -ge 20 ]] && XDEBUG_VERSION=3.1.6 || XDEBUG_VERSION=3.0.4;;
    8.0) [[ "${parts[2]}" -ge  7 ]] && XDEBUG_VERSION=3.1.6 || XDEBUG_VERSION=3.0.4;;
    8.1|8.2) XDEBUG_VERSION=3.2.0;;
    *)
        echo "Could not determine the Xdebug version needed!"
        exit 1
        ;;
esac

if [ ! -d "$VERSION_DIR" ]; then
    echo "Version $PHP_VERSION is not currently supported!"
    exit
fi

cd "$VERSION_DIR" || exit

echo "Building the PHP $PHP_VERSION (w/ Xdebug $XDEBUG_VERSION)..."
docker build \
    --force-rm \
    --tag "$ORGANIZATION/$IMAGE_NAME:$PHP_VERSION" \
    --build-arg PHP_VERSION="$PHP_VERSION" \
    --build-arg XDEBUG_VERSION="$XDEBUG_VERSION" \
    .

#CONTAINER_ID=$(docker create -it "$ORGANIZATION/$IMAGE_NAME:$PHP_VERSION" ash)
CONTAINER_ID=$(docker create "$ORGANIZATION/$IMAGE_NAME:$PHP_VERSION")

docker export --output="php-$PHP_VERSION.tar" "$CONTAINER_ID"
docker rm "$CONTAINER_ID"

if [ $DEPLOY -eq 1 ];
then
    echo $SCRIPT_DIR

    IMAGE_DIR=$HOME/WSL/php/$PHP_VERSION
    IMAGE_TAG="PHP-$PHP_VERSION"
    IMAGE_TAR="$SCRIPT_DIR/$VERSION_DIR/php-$PHP_VERSION.tar"

    [ ! -d "$IMAGE_DIR" ] && mkdir -p "$IMAGE_DIR"

    echo --import "$IMAGE_TAG" "$IMAGE_DIR" "$IMAGE_TAR"
    wsl.exe --unregister "$IMAGE_TAG"
    wsl.exe --import "$IMAGE_TAG" "$IMAGE_DIR" "$IMAGE_TAR"
fi
