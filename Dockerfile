from	ubuntu:12.10
run 	apt-get update
run 	apt-get install -y curl
run 	apt-get install -y git

add buildpacks /buildpacks
copy builder /buildpacks/builder

# Ruby buildpack dependencies
run apt-get install -y ruby1.9.1-dev
run apt-get install -y rubygems
run update-alternatives --set ruby /usr/bin/ruby1.9.1
run update-alternatives --set gem /usr/bin/gem1.9.1
run gem install bundler
run cd /buildpacks/heroku-buildpack-ruby && bundle install

# Node.js buildpack dependencies
run apt-get install -y mercurial
run apt-get install -y libssl0.9.8