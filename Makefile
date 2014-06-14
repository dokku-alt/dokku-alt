DOKKU_VERSION ?= 0.3.0
DOKKU_ROOT ?= /home/dokku
PLUGINHOOK_URL ?= https://s3.amazonaws.com/progrium-pluginhook/pluginhook_0.1.0_amd64.deb
SIGN_KEY ?= EAD883AF

DEB_PKG := dokku-alt-$(shell git describe --tags)-amd64.deb

.PHONY: all dpkg install devinstall pull push sync

FORCE:

all:
	# Type "make dpkg" to create deb package.
	# Type "make install" to install.
	# Type "make devinstall" to switch to development version.

dpkg:
	rm -f dokku-alt-*.deb
	rm -rf deb-tmp/
	cp -r deb deb-tmp/
	mkdir -p deb-tmp/dokku-alt/usr/local/bin
	mkdir -p deb-tmp/dokku-alt/var/lib/dokku-alt
	mkdir -p deb-tmp/dokku-alt/usr/local/share/man/man1
	mkdir -p deb-tmp/dokku-alt/usr/local/share/dokku-alt/contrib
	cp sshcommand/sshcommand deb-tmp/dokku-alt/usr/local/bin/sshcommand
	cp gitreceive/gitreceive deb-tmp/dokku-alt/usr/local/bin/gitreceive
	cp pluginhook/pluginhook deb-tmp/dokku-alt/usr/local/bin/pluginhook
	cp dokku deb-tmp/dokku-alt/usr/local/bin
	cp -r plugins deb-tmp/dokku-alt/var/lib/dokku-alt
	cp dokku.1 deb-tmp/dokku-alt/usr/local/share/man/man1/dokku.1
	cp contrib/dokku-installer.rb deb-tmp/dokku-alt/usr/local/share/dokku-alt/contrib
	git describe --tags > deb-tmp/dokku-alt/var/lib/dokku-alt/VERSION
	sed -i "s/^Version: .*/Version: $(shell git describe --tags)/g" deb-tmp/dokku-alt/DEBIAN/control
	dpkg-deb --build deb-tmp/dokku-alt $(DEB_PKG)
	rm -rf deb-tmp/

install: dpkg
	dpkg -i $(DEB_PKG)
	apt-get -f -y install

devinstall:
	[ -e /usr/local/bin/dokku ] || echo Please install dokku-alt first
	ln -sf "$(PWD)/dokku" /usr/local/bin/dokku
	ln -sf "$(PWD)/sshcommand/sshcommand" /usr/local/bin/sshcommand
	ln -sf "$(PWD)/gitreceive/gitreceive" /usr/local/bin/gitreceive
	ln -sf "$(PWD)/plugins" /var/lib/dokku-alt/plugins

dpkg_commit: dpkg
	# sign current release
	dpkg-sig -k $(SIGN_KEY) --sign builder $(DEB_PKG)
	git checkout gh-pages
	# binary
	apt-ftparchive packages . > Packages
	apt-ftparchive release . > Release
	gzip -c Packages > Packages.gz
	gpg --clearsign -o InRelease Release
	gpg -abs -o Release.gpg Release
	git add *
	# commit current release
	git commit -m "New release"
	git checkout master

docker_build: FORCE
	docker build -t ayufan/dokku-alt .

docker_run: docker_build
	docker run --privileged --rm -i -t \
		-v /home/dokku -v /var/lib/docker \
		--hostname="dokku.me" \
		ayufan/dokku-alt \
		/bin/bash

docker_tests: docker_build
	docker run --privileged --rm -t \
		-v /home/dokku -v /var/lib/docker \
		--hostname="dokku.me" \
		ayufan/dokku-alt \
		/srv/dokku-alt/tests/run_localhost

pull:
	rsync -av dokku.home:/srv/dokku-alt/ dokku
	rsync -av dokku.home:/srv/dokku-alt/plugins plugins

push:
	rsync -av --delete dokku dokku.home:/srv/dokku-alt/
	rsync -av --delete plugins dokku.home:/srv/dokku-alt/

sync:
	while true; do make push >/dev/null; sleep 1s; done

count:
	@echo "Core lines:"
	@cat dokku bootstrap.sh | wc -l
	@echo "Plugin lines:"
	@find plugins -type f | xargs cat | wc -l
	@echo "Test lines:"
	@find tests -type f | xargs cat | wc -l
