from	ubuntu:quantal
run 	apt-get update
run 	apt-get install -y curl
run 	apt-get install -y git

add build-dir	/build

# Ruby buildpack dependencies
run apt-get install -y ruby1.9.1-dev
run apt-get install -y rubygems
run update-alternatives --set ruby /usr/bin/ruby1.9.1
run update-alternatives --set gem /usr/bin/gem1.9.1
run gem install bundler
run cd /build/buildpacks/heroku-buildpack-ruby && bundle install

# Node.js buildpack dependencies
run apt-get install -y mercurial
run apt-get install -y libssl0.9.8