VERSION = 0.1.0

install:
	cp gitreceive /usr/local/bin/gitreceive
	chmod +x /usr/local/bin/gitreceive

check-docker:
	which docker || exit 1

test: check-docker
	cp gitreceive tests
	docker build -t progrium/gitreceive-tests tests
	rm tests/gitreceive
	docker run progrium/gitreceive-tests