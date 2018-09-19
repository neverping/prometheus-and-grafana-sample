# -*- mode: ruby -*-
# vi: set ft=ruby :

# USAGE:
#
# vagrant up shaw
# vagrant up vickers

Vagrant.configure("2") do |config|

  # Please keep this as False, so we can deploy with SSHKit.
  # Otherwise, it should be True.
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |v|
    # Ubuntu is creating a kernel log file in the host machine called
    # ubuntu-xenial-16.04-cloudimg-console.log
    # This config below will prevent this.
    v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ]
    # with 512M RAM, the gcc compiler can be killed by the OMMKiller when
    # compiling a new Ruby. Increasing to 1024
    v.memory = 1024
    v.cpus = 2
    # Attempts to increase network speed. Check below for details
    #
    # Here a list of virtual network adapters you can try if you feel the
    # guest machines are not performing well. To me, the best one was
    # virtio.
    #
    # V-NIC:  Am79C970A, Am79C973, 82540EM, 82543GC, 82545EM, and virtio
    v.customize ["modifyvm", :id, "--nictype1", "virtio"]
    v.customize ["modifyvm", :id, "--nictype2", "virtio"]
    #
    # minimal = Mac, kvm = Linux, hyperv = Windows or 'none' if doesn't work.
    v.customize ["modifyvm", :id, "--paravirtprovider", "minimal"]
  end

  CHEF_NODES_JSON_DIR = Pathname(__FILE__).dirname.join('chef-solo', 'nodes')

  config.vm.define :vickers, primary: false, autostart: false do |vickers|
    guest_json = JSON.parse(CHEF_NODES_JSON_DIR.join('vickers.json').read)
    vickers.vm.box = "ubuntu/xenial64"
    vickers.vm.hostname = "ubuntu-xenial"
    vickers.vm.network :private_network, ip: "192.168.123.101"

    vickers.vm.provision :chef_solo do |chef|
      # Chef-solo on its latest version is breaking on Vagrant.
      # Please maintain both version and channel configurations for now.
      # Check the following discussion and see when it will be solved
      # pior upgrading chef here.
      #
      # https://github.com/chef/chef/issues/4948
      #
      # UPDATE: It seems this issue was involved with Vagrant, and now it is working
      # properly. Be sure you have Vagrant 2.0.2 and above. If you can't update your
      # vagrant installation, you can uncommet chef.version below and it will work
      # as well.
      #
      #chef.version = "12.10.24"
      chef.channel = "stable"
      chef.cookbooks_path = ["chef-solo/site-cookbooks", "chef-solo/cookbooks"]
      chef.roles_path = "chef-solo/roles"
      # Chef 12.x or above requires 'data_bags_path' must be an array. 11.x or lower as a string.
      chef.data_bags_path = ["chef-solo/data_bags"]
      chef.provisioning_path = "/tmp/vagrant-chef"
      chef.run_list = guest_json.delete('run_list')
      chef.json = guest_json
    end

  end

  config.vm.define :shaw, primary: false, autostart: false do |shaw|
    guest_json = JSON.parse(CHEF_NODES_JSON_DIR.join('shaw.json').read)
    shaw.vm.box = "ubuntu/xenial64"
    shaw.vm.hostname = "ubuntu-xenial"
    shaw.vm.network :private_network, ip: "192.168.123.102"

    shaw.vm.provision :chef_solo do |chef|
      # Chef-solo on its latest version is breaking on Vagrant.
      # Please maintain both version and channel configurations for now.
      # Check the following discussion and see when it will be solved
      # pior upgrading chef here.
      #
      # https://github.com/chef/chef/issues/4948
      #
      # UPDATE: It seems this issue was involved with Vagrant, and now it is working
      # properly. Be sure you have Vagrant 2.0.2 and above. If you can't update your
      # vagrant installation, you can uncommet chef.version below and it will work
      # as well.
      #
      #chef.version = "12.10.24"
      chef.channel = "stable"
      chef.cookbooks_path = ["chef-solo/site-cookbooks", "chef-solo/cookbooks"]
      chef.roles_path = "chef-solo/roles"
      # Chef 12.x or above requires 'data_bags_path' must be an array. 11.x or lower as a string.
      chef.data_bags_path = ["chef-solo/data_bags"]
      chef.provisioning_path = "/tmp/vagrant-chef"
      chef.run_list = guest_json.delete('run_list')
      chef.json = guest_json
    end

  end

end
