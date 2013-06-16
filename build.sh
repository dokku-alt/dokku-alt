#!/bin/bash
set -e
DIR="$1"; NAME="$2"
BASE=$(<"$DIR/base.txt")

indent() { sed "s/^/       /"; }

echo "=====> Building container..."

echo "-----> Pulling base image..."
docker pull "$BASE" | indent

echo "-----> Installing build directory..."
ID=$(cd "$1" && tar -c . | docker run -i -a stdin "$BASE" /bin/sh -c "mkdir -p '/build' && tar -C '/build' -x")
docker wait $ID > /dev/null
ID=$(docker commit $ID)

echo "-----> Running prepare script..."
ID=$(docker run -d $ID /bin/sh -c /build/prepare)
docker attach $ID | indent

echo "-----> Committing changes..."
ID=$(docker commit $ID)
docker tag $ID "$NAME"

echo
echo "=====> Saved container as $NAME"