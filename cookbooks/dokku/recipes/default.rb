package 'python-software-properties' do
  action :install
end

execute 'fetch dokku' do
  command "wget -q -O /dokku_bootstrap.sh https://raw.github.com/progrium/dokku/master/bootstrap.sh"
end

#execute 'install dokku (this takes a while)' do
#  command "bash /dokku_bootstrap.sh"
#end
