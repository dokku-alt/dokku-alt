all:
  dockerbuild
  ./buildpacks-fetch
  ./dockerize

dockerbuild:
  wget https://raw.github.com/dotcloud/docker/master/contrib/docker-build/docker-build
  chmod +x docker-build
