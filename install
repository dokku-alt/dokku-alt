#!/bin/bash

# Build docker image
git clone https://github.com/luxifer/dokku-redis-dockerfiles.git /tmp/dokku-redis-dockerfiles
docker build -q=true -t luxifer/redis /tmp/dokku-redis-dockerfiles
rm -rf /tmp/dokku-redis-dockerfiles
