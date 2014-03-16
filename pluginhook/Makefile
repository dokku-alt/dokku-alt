VERSION = 0.1.1

build: pluginhook

install: pluginhook
	cp pluginhook /usr/local/bin/

pluginhook pluginhook.linux: pluginhook.go
	docker build -t progrium/pluginhook .
	docker run -t -rm progrium/pluginhook cat pluginhook > pluginhook.tmp
	docker run -t -rm progrium/pluginhook cat pluginhook.linux > pluginhook.linux.tmp
	mv pluginhook.tmp pluginhook
	mv pluginhook.linux.tmp pluginhook.linux
	docker rmi progrium/pluginhook
	chmod +x pluginhook pluginhook.linux

test: build
	PLUGIN_PATH=./tests/plugins BIN=./pluginhook tests/run_tests.sh

package: test build
	rm -rf package
	mkdir -p package/bin
	mv pluginhook.linux package/bin/pluginhook
	cd package && fpm -s dir -t deb -n pluginhook -v ${VERSION} --prefix /usr/local bin

release: package
	s3cmd -P put package/pluginhook_${VERSION}_amd64.deb s3://progrium-pluginhook
