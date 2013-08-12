FROM	ubuntu:quantal
MAINTAINER	kload "kload@kload.fr"

# prevent apt from starting mariadb right after the installation
RUN	echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
RUN add-apt-repository 'deb http://ftp.osuosl.org/pub/mariadb/repo/5.5/ubuntu quantal main'
RUN apt-get update
RUN echo mysql-server-5.5 mysql-server/root_password password 'a_stronk_password' | debconf-set-selections
RUN echo mysql-server-5.5 mysql-server/root_password_again password 'a_stronk_password' | debconf-set-selections
RUN LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y mariadb-server-5.5
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get clean

# allow autostart again
RUN	rm /usr/sbin/policy-rc.d

ADD	. /usr/bin
RUN	chmod +x /usr/bin/start_mariadb.sh
RUN sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
RUN sed -i -e"s/var\/lib/opt/g" /etc/mysql/my.cnf
