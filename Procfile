nginx: exec nginx -g "daemon off; error_log /dev/stdout info;"
ssh: mkdir /var/run/sshd; exec /usr/sbin/sshd -De
dokku: exec /srv/dokku-alt/start-dokku.sh
docker: cgroups-mount; exec docker daemon
