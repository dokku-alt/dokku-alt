# We'll mount the Chef::Config[:file_cache_path] so it persists between
# Vagrant VMs
host_cache_path = File.expand_path("../.cache", __FILE__)
guest_cache_path = "/tmp/vagrant-cache"

# ensure the cache path exists
FileUtils.mkdir(host_cache_path) unless File.exist?(host_cache_path)

Vagrant.configure("2") do |config|
  config.berkshelf.enabled = true
  config.omnibus.chef_version = :latest

  config.vm.define :ubuntu1304 do |ubuntu1304|
    ubuntu1304.vm.box      = 'opscode-ubuntu-13.04'
    ubuntu1304.vm.box_url  = 'https://opscode-vm.s3.amazonaws.com/vagrant/opscode_ubuntu-13.04_provisionerless.box'
    ubuntu1304.vm.hostname = 'mydokku.com'
    ubuntu1304.vm.network :private_network, ip: '192.168.50.10'
  end

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end

  config.vm.provision :chef_solo do |chef|
    chef.provisioning_path = guest_cache_path
    chef.log_level         = :debug

    chef.json = {
      
    }

    chef.run_list = %w{
      recipe[dokku]
    }
#      recipe[docker]
  end


  config.vm.synced_folder "./", "/var/lib/dokku/plugins/mongodb"
  config.vm.synced_folder host_cache_path, guest_cache_path
end
