#!/bin/bash

set -e

build_root=/app
cache_root=/cache
buildpack_root=/buildpacks

buildpacks=($buildpack_root/*)
selected_buildpack=

cat | tar -x -C $build_root

if [ -f "$build_root/.env" ]; then
  . "$build_root/.env"
fi

if [ -n "$BUILDPACK_URL" ]; then
  echo "Fetching custom buildpack"
  buildpack="$buildpack_root/custom"
  rm -rf "$buildpack"

  git clone --depth=1 "$BUILDPACK_URL" "$buildpack"
  selected_buildpack="$buildpack"
  buildpack_name=$($buildpack/bin/detect "$build_root") && selected_buildpack=$buildpack
else
  for buildpack in "${buildpacks[@]}"; do
    buildpack_name=$($buildpack/bin/detect "$build_root") && selected_buildpack=$buildpack && break
  done
fi

if [ -n "$selected_buildpack" ]; then
  echo "$buildpack_name app detected"
else
  echo "Unable to select a buildpack"
  exit 1
fi

mkdir -p $cache_root

$selected_buildpack/bin/compile "$build_root" "$cache_root"

echo "Discovering process types"
release_output=$($selected_buildpack/bin/release "$build_root" "$cache_root") 
default_types=$(echo "$release_output" | sed -ne '/^default/,/(\z|^[a-z])/  {
    /^[a-z]/n
    s/  //p
}')

procfile=
if [ -f "$build_root/Procfile" ]; then
  procfile=$(cat "$build_root/Procfile" | sed 's/^/  /')
  echo "Procfile declares types -> " $(cat "$build_root/Procfile" | cut -d: -f1 | tr $'\n' ',' | sed -e 's/,$//')
else
  procfile=$(echo "$default_types" | sed -e 's/^/  /')
fi

echo "Default process types for $buildpack_name -> " $(echo "$default_types" | cut -d: -f1 | tr $'\n' ',' | sed -e 's/,$//')

echo "Finished"

