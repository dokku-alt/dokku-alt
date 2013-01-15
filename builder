#!/bin/bash

artifact_target=/tmp/slug.tgz
build_root=/build
cache_root=/cache
buildpack_root=/buildpacks

buildpacks=($buildpack_root/*)
selected_buildpack=

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

if [ -f "$build_root/.slugignore" ]; then
  tar --exclude='.git' -X "$build_root/.slugignore" -C $build_root -czf $artifact_target .
else
  tar --exclude='.git' -C $build_root -czf $artifact_target .
fi

artifact_size=$(du -Sh $artifact_target | cut -d' ' -f1)
echo "Compiled artifact size is $artifact_size"

