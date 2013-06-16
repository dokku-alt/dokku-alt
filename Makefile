
all: build

build: container

container: ubuntu-image
	tasks/container-build

ubuntu-image:
	docker pull ubuntu:quantal

update:
	cat build-dir/builder | docker run -i -a stdin progrium/buildstep /bin/sh -c "cat > /build/builder; chmod +x /build/builder"