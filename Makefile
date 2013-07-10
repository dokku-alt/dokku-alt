VERSION = 0.1.0

install:
	cp gitreceive /usr/local/bin/gitreceive
	chmod +x /usr/local/bin/gitreceive

check-docker:
	which docker || exit 1

test-image: check-docker
	docker images | grep progrium/gitreceive-tester

test: test-image
	cat -c . | docker run -i progrium/gitreceive-tester