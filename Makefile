all:
  docker-build
  ./buildpacks-fetch
  ./dockerize

docker-build:
  wget https://raw.github.com/dotcloud/docker/master/contrib/docker-build/docker-build
  chmod +x docker-build
