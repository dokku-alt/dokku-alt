VERSION = 0.1.1

build: pluginhook

pluginhook:
	go build -o pluginhook
	GOOS=linux go build -o pluginhook.linux

test: build
	PLUGIN_PATH=./tests/plugins BIN=./pluginhook tests/run_tests.sh

package: test build
	rm -rf package
	mkdir -p package/bin
	mv pluginhook.linux package/bin/pluginhook
	cd package && fpm -s dir -t deb -n pluginhook -v ${VERSION} --prefix /usr/local bin

release: package
	s3cmd -P put package/pluginhook_${VERSION}_amd64.deb s3://progrium-pluginhook