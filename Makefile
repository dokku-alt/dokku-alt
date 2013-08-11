
all: build

build: 
	docker build -t progrium/buildstep github.com/progrium/buildstep
