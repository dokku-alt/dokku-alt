DOKKU_VERSION = master
DOKKU_ROOT ?= /home/dokku

.PHONY: all install devinstall pull push sync

all:
	# Type "make install" to install.

install:
	# install dependencies
	apt-get update
	apt-get -y install ruby ruby-sinatra

	# install docker
	egrep -i "^docker" /etc/group || groupadd docker
	apt-get -y install docker.io # requires ubuntu 14.04 LTS
	[ -x /usr/bin/docker.io ] && ln -sf /usr/bin/docker.io /usr/local/bin/docker

	# dokku man
	mkdir -p /usr/local/share/man/man1
	cp dokku.1 /usr/local/share/man/man1/dokku.1
	mandb

	# install dokku
	cp dokku /usr/local/bin/dokku
	cp sshcommand/sshcommand /usr/local/bin/sshcommand
	cp gitreceive/gitreceive /usr/local/bin/gitreceive
	cp pluginhook/pluginhook /usr/local/bin/pluginhook
	mkdir -p /var/lib/dokku-alt/plugins
	cp -r plugins/* /var/lib/dokku-alt/plugins

	# configure dokku
	sshcommand create dokku /usr/local/bin/dokku
	usermod -aG docker dokku

	# version
	git describe --tags > /var/lib/dokku-alt/VERSION  2> /dev/null || echo '~${DOKKU_VERSION} ($(shell date -uIminutes))' > /var/lib/dokku-alt/VERSION

	# install plugins
	dokku plugins-install

devinstall: install
	ln -sf "$(PWD)/dokku" /usr/local/bin/dokku
	ln -sf "$(PWD)/sshcommand/sshcommand" /usr/local/bin/sshcommand
	ln -sf "$(PWD)/gitreceive/gitreceive" /usr/local/bin/gitreceive
	ln -sf "$(PWD)/pluginhook/pluginhook" /usr/local/bin/pluginhook
	ln -sf "$(PWD)/plugins" /var/lib/dokku-alt/plugins

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
