#!/bin/bash

# Exit on first error
set -e

save_and_shutdown() {
  # save built for host result
  # force clean shutdown
  echo $? > /uml_exit_code
  halt -f
}

# remove old uml_exit_code
rm -f /uml_exit_code

# make sure we shut down cleanly
trap save_and_shutdown EXIT SIGINT SIGTERM

# go back to where we were invoked
cd $WORKDIR

# configure hostname
hostname dokku.me

# configure path to include /usr/local
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# can't do much without proc!
mount -t proc none /proc

# pseudo-terminal devices
mkdir -p /dev/pts
mount -t devpts none /dev/pts

# shared memory a good idea
mkdir -p /dev/shm
mount -t tmpfs none /dev/shm

# fd sometimes is usefull
ln -sf /proc/self/fd /dev/fd

# sysfs a good idea
mount -t sysfs none /sys

# mount home
mount -t tmpfs none /home

# pidfiles and such like
mkdir -p /var/run
mount -t tmpfs none /var/run
mkdir /var/run/sshd

# tmpfs
mount -t tmpfs none /tmp
chmod 777 /tmp

# docker
mount -t tmpfs -o size=2000m none /var/lib/docker

# logfiles and such like
mkdir -p /var/log
mount -t tmpfs none /var/log
mkdir -p /var/log/nginx
chmod -R 777 /var/log

# some nginx files
mkdir -p /var/lib/nginx
mount -t tmpfs none /var/lib/nginx
chown -R www-data:www-data /var/lib/nginx

# takes the pain out of cgroups
cgroups-mount

# enable ipv4 forwarding for docker
echo 1 > /proc/sys/net/ipv4/ip_forward

# configure networking
ip addr add 127.0.0.1 dev lo
ip link set lo up
ip addr add 10.1.1.1/24 dev eth0
ip link set eth0 up
ip route add default via 10.1.1.254

# configure dns (google public)
mkdir -p /run/resolvconf
echo 'nameserver 8.8.8.8' > /run/resolvconf/resolv.conf
mount --bind /run/resolvconf/resolv.conf /etc/resolv.conf

# show mounts
echo "========================================"
echo "=====> Mounted disks..."
df -h || true

# RUN TESTS
echo "========================================"
echo "=====> Starting nginx..."
nginx -c /etc/nginx/nginx.conf

echo "=====> Starting sshd..."
/usr/sbin/sshd

echo "=====> Starting docker..."
docker -d >/tmp/docker.log 2>&1 &
sleep 5s

echo "========================================"
echo "=====> Configuring dokku..."

export HOME=/root
sshcommand create dokku /usr/local/bin/dokku
dokku plugins-install

echo "=====> Adding ssh-key..."
mkdir -p /root/.ssh
[[ -f ~/.ssh/id_rsa ]] || ssh-keygen -q -t rsa -N "" -f ~/.ssh/id_rsa
cat <<EOF >> ~/.ssh/config
Host *
    StrictHostKeyChecking no
EOF
cat ~/.ssh/id_rsa.pub | dokku access:add

echo "=====> Veryfing connectivity..."
ssh dokku@localhost version

echo "========================================"

if [[ "$USE_VHOST" == "1" ]]; then
	echo "-----> Setting VHOST..."
	echo "dokku.me" > /home/dokku/VHOST
fi

echo "----------------------------------------"
echo "-----> Running test deploy of $APP_NAME..."
echo "----------------------------------------"
echo ""

tests/test_deploy apps/$APP_NAME localhost

echo "=====> DONE!"
