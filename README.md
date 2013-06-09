# Buildstep

Heroku-style application builds using Docker and Buildpacks. Used by [Dokku](https://github.com/progrium/dokku) to make a mini-Heroku.

## Requirements

 * Docker
 * Git

## Building Buildstep

The buildstep script uses a buildstep base container that needs to be built. It must be created before
you can use the buildstep script. To create it, run:

    $ make build

This will create a container called `progrium/buildstep` that contains all supported buildpacks and the
builder script that will actually perform the build using the buildpacks.

## Building an App

Running the buildstep script will take an application tar via STDIN and an application container name as
an argument. It will put the application in a new container based on `progrium/buildstep` with the specified name. 
Then it runs the builder script inside the container. 

    $ cat myapp.tar | ./buildstep myapp

The resulting container has a built app ready to go. The builder script also parses the Procfile and produces
a starter script for the web role, however this is might not belong here (and it only does it for web, so it's
kind of a limited feature). For now, it makes it easy to start an app container:

    $ docker run -d myapp /bin/bash -c "cd /app && ./start"

## Adding Buildpacks

Buildstep needs to support a buildpack by installing packages needed to run the build and to run the application
it builds. For example, the Python buildpack would need Python to be installed.

To add a new buildpack to builstep, add commands to install the necessary packages that the buildpack and built
application environment will need to Dockerfile. Then add the buildpack Git URL to the file build-dir/buildpacks.txt

You'll then have to re-build.

## License

MIT