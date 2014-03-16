VERSION = 0.1.0

REMOTE_DIR ?= /tmp/gitreceive

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

remote:
	tar -c . | ssh -o "StrictHostKeyChecking=no" ${REMOTE} "rm -rf ${REMOTE_DIR} && mkdir -p ${REMOTE_DIR} && cd ${REMOTE_DIR} && tar -xf - && make ${TARGET}"
