
all: build

build:
	./buildpacks-fetch
	./dockerize

builder:
	cat builder | docker run -i -a stdin progrium/buildstep "/bin/sh -c cat > /buildpacks/builder; chmod +x /buildpacks/builder"