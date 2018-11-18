#!/bin/sh
RESTY_IMAGE="$(whoami)/openresty"
RESTY_IMAGE_VERSION="fat"
RESTY_LUAROCKS_VERSION="3.0.4"

docker build -t $RESTY_IMAGE:$RESTY_IMAGE_VERSION \
    --build-arg RESTY_LUAROCKS_VERSION="$RESTY_LUAROCKS_VERSION" \
    -f Dockerfile.fat \
    https://github.com/openresty/docker-openresty.git#master:alpine

docker build -t $(whoami)/lapis:alpine \
    --build-arg RESTY_IMAGE="$RESTY_IMAGE" \
    --build-arg RESTY_IMAGE_VERSION="$RESTY_IMAGE_VERSION" \
    .

echo "Image \"$(whoami)/lapis:alpine\" created."
