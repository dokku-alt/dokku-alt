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
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9 && \
	echo deb https://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list && \
	apt-get update && \
	apt-get install -y lxc-docker

# Install forego
RUN curl -o /usr/bin/forego https://godist.herokuapp.com/projects/ddollar/forego/releases/current/linux-amd64/forego && chmod +x /usr/bin/forego

# Configure ssh daemon
RUN sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/g' /etc/ssh/sshd_config

# Configure volumes
VOLUME /home/dokku
VOLUME /var/lib/docker

# Install dokku-alt
ADD / /srv/dokku-alt
WORKDIR /srv/dokku-alt
RUN sed -i 's/linux-image-extra-virtual, //g' deb/dokku-alt/DEBIAN/control
RUN make install

EXPOSE 22 80 443

# Start all services
CMD ["forego", "start"]
