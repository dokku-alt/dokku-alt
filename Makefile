
all: build

build: buildpacks container

buildpacks:
	tasks/buildpacks-fetch

container:
	tasks/container-build

update:
	cat build-dir/builder | docker run -i -a stdin progrium/buildstep /bin/sh -c "cat > /build/builder; chmod +x /build/builder"