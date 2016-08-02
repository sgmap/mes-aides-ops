# -*- mode: ruby -*-
# vi: set ft=ruby :

vms = {
  :mesAide =>
    { :ip => '192.168.56.134',
      :name => 'mesAide'
    }
}

ssh_pubkey = File.read(File.join(Dir.home, '.ssh', 'id_rsa.pub')).chomp

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/xenial64"
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provision 'shell', inline: <<-SHELL
    sudo mkdir -p /home/ubuntu/.ssh -m 700
    sudo echo '#{ssh_pubkey}' >> /home/ubuntu/.ssh/authorized_keys
  SHELL

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.


  config.vm.provider "virtualbox" do |v|
    v.cpus = 1
    v.gui = false
  end

  vms.each_pair do |key, vm|
    config.vm.define key do |configvm|
      configvm.vm.network 'private_network', ip: vm[:ip]
      configvm.vm.provider 'virtualbox' do |vb|
        vb.memory = vm[:memory] || '512'
        vb.name = vm[:name]
      end
    end
  end
end
