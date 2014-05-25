DOKKU_VERSION = master
DOKKU_ROOT ?= /home/dokku
PLUGINHOOK_URL ?= https://s3.amazonaws.com/progrium-pluginhook/pluginhook_0.1.0_amd64.deb

.PHONY: all install devinstall pull push sync

all:
	# Type "make install" to install.

install:
	# install dependencies
	apt-get update
	apt-get -y install ruby ruby-sinatra locales
	locale-gen en_US.UTF-8

	# install docker
	egrep -i "^docker" /etc/group || groupadd docker
	[ -x /usr/bin/docker ] || apt-get -y install docker.io # requires ubuntu 14.04 LTS
	[ ! -x /usr/bin/docker.io ] || ln -sf /usr/bin/docker.io /usr/local/bin/docker

	# dokku man
	mkdir -p /usr/local/share/man/man1
	cp dokku.1 /usr/local/share/man/man1/dokku.1
	mandb

	# install dependencies
	wget -qO pluginhook_0.1.0_amd64.deb ${PLUGINHOOK_URL}
	dpkg -i pluginhook_0.1.0_amd64.deb
	cp sshcommand/sshcommand /usr/local/bin/sshcommand
	cp gitreceive/gitreceive /usr/local/bin/gitreceive

	# install dokku
	cp dokku /usr/local/bin/dokku
	mkdir -p /var/lib/dokku-alt/plugins
	cp -r plugins/* /var/lib/dokku-alt/plugins

	# configure dokku
	sshcommand create dokku /usr/local/bin/dokku
	usermod -aG docker dokku

	# version
	git describe --tags > /var/lib/dokku-alt/VERSION  2> /dev/null || echo '~${DOKKU_VERSION} ($(shell date -uIminutes))' > /var/lib/dokku-alt/VERSION

	# install plugins
	dokku plugins-install

devinstall:
	ln -sf "$(PWD)/dokku" /usr/local/bin/dokku
	ln -sf "$(PWD)/sshcommand/sshcommand" /usr/local/bin/sshcommand
	ln -sf "$(PWD)/gitreceive/gitreceive" /usr/local/bin/gitreceive
	ln -sf "$(PWD)/plugins" /var/lib/dokku-alt/plugins

dpkg:
	rm -rf deb/dokku-alt/var/lib/dokku-alt
	mkdir -p deb/dokku-alt/usr/local/bin
	mkdir -p deb/dokku-alt/var/lib/dokku-alt
	mkdir -p deb/dokku-alt/usr/local/share/man/man1
	cp sshcommand/sshcommand deb/dokku-alt/usr/local/bin/sshcommand
	cp gitreceive/gitreceive deb/dokku-alt/usr/local/bin/gitreceive
	cp pluginhook/pluginhook deb/dokku-alt/usr/local/bin/pluginhook
	cp dokku deb/dokku-alt/usr/local/bin
	cp -r plugins deb/dokku-alt/var/lib/dokku-alt
	cp dokku.1 deb/dokku-alt/usr/local/share/man/man1/dokku.1
	git describe --tags > deb/dokku-alt/var/lib/dokku-alt/VERSION  2> /dev/null || echo '~${DOKKU_VERSION} ($(shell date -uIminutes))' > deb/dokku-alt/var/lib/dokku-alt/VERSION
	dpkg-deb --build deb/dokku-alt

dpkg_commit: dpkg
	git checkout gh-pages
	cp deb/dokku-alt.deb .
	git add dokku-alt.deb
	git commit -m "New release"
	git checkout master

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
