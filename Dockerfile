FROM ubuntu:trusty
MAINTAINER Kamil Trzciński <ayufan@ayufan.eu>

# Install required dependencies
RUN apt-get update && \
	apt-get install -y apt-transport-https locales git make \
	curl software-properties-common \
	nginx dnsutils aufs-tools \
	dpkg-dev openssh-server man-db
RUN apt-get install -y apache2-utils
RUN chmod ugo+s /usr/bin/sudo

# Configure environment
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Install docker
#RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
#	echo deb https://apt.dockerproject.org/repo ubuntu-wily main > /etc/apt/sources.list.d/docker.list && \
#	apt-get update && \
#	apt-get -y install docker-engine

RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
	echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list && \
	apt-get update && \
	apt-get -y install docker-engine

# Install forego
RUN curl -o /usr/bin/forego https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego && chmod +x /usr/bin/forego

# Configure ssh daemon
RUN sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Configure volumes
VOLUME /home/dokku
VOLUME /var/lib/docker

# Install dokku-alt
ADD . /srv/dokku-alt
WORKDIR /srv/dokku-alt
RUN sed -i 's/linux-image-extra-virtual, //g' deb/dokku-alt/DEBIAN/control
RUN make install

EXPOSE 22 80 443

# Start all services
CMD ["forego", "start"]