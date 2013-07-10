from	ubuntu:12.04
run	apt-get -y update
run	apt-get -y install git
run git clone https://github.com/sstephenson/bats.git && cd bats && ./install.sh /usr/local
add ./gitreceive /usr/local/bin/gitreceive
add ./gitreceive.bats /
add ./init /
cmd /init