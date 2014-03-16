#/bin/bash
ID=$(docker run -d progrium/buildstep /bin/sh)
docker export $ID | gzip -9c > /tmp/tgz
s3cmd put /tmp/tgz s3://progrium-dokku/progrium_buildstep.tgz
s3cmd setacl -P s3://progrium-dokku/progrium_buildstep.tgz
