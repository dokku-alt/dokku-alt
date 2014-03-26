FROM	ubuntu:quantal
MAINTAINER	kload "kload@kload.fr"

RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive \
	echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d && \
	chmod +x /usr/sbin/policy-rc.d && \
	apt-get update && \
	apt-get install -y software-properties-common && \
	apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db && \
	add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu quantal main' && \
	apt-get update && \
	echo mysql-server-5.5 mysql-server/root_password password 'a_stronk_password' | debconf-set-selections && \
	echo mysql-server-5.5 mysql-server/root_password_again password 'a_stronk_password' | debconf-set-selections && \
	apt-get install -y mariadb-server-5.5 && \
	rm -rf /var/lib/apt/lists/* && \
	apt-get clean && \
	rm /usr/sbin/policy-rc.d

ADD	. /usr/bin
RUN	chmod +x /usr/bin/start_mariadb.sh
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" -e"s/var\/lib/opt/g" /etc/mysql/my.cnf
