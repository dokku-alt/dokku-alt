from	ubuntu:12.04
run	apt-get -y update
run	apt-get -y install git ssh
run ssh-keygen -t rsa -N "" -f /root/.ssh/id_rsa
run git clone https://github.com/sstephenson/bats.git && cd bats && ./install.sh /usr/local
add ./gitreceive /usr/local/bin/gitreceive
add ./gitreceive.bats /
add ./init /
cmd /init