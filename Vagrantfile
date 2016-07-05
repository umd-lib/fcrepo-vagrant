# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

  config.vm.box = "puppetlabs/centos-6.6-64-puppet"
  config.vm.box_version = "1.0.1"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  config.vm.hostname = 'fcrepolocal'

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.40.10"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "dist", "/apps/dist"
  config.vm.synced_folder "/apps/git/fcrepo-env", "/apps/git/fcrepo-env"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
     # Customize the amount of memory on the VM:
     vb.memory = "4096"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Puppet Modules
  config.vm.provision "shell", inline: 'puppet module install puppetlabs-firewall'

  # system provisioning
  config.vm.provision "puppet"

  # copy the default vagrant key so we can easily ssh between fcrepo and solr boxes
  # this works because this base box adds the insecure public key to the vagrant
  # user's authorized_hosts file
  config.vm.provision "file",
    source: "#{ENV['HOME']}/.vagrant.d/insecure_private_key",
    destination: "/home/vagrant/.ssh/id_rsa"
  # get pre-built artifacts (from Nexus)
  config.vm.provision "shell", path: "scripts/artifacts.sh"
  # install JDK
  config.vm.provision "shell", path: "scripts/jdk.sh"
  # install Tomcat
  config.vm.provision "shell", path: "scripts/tomcat.sh"
  # install Karaf
  config.vm.provision "shell", path: "scripts/karaf.sh"
  # install Fuseki
  config.vm.provision "shell", path: "scripts/fuseki.sh"
  # install runtime env
  config.vm.provision "shell", path: "scripts/env.sh"
  # deploy webapps
  config.vm.provision "shell", path: "scripts/webapps.sh", privileged: false
  # configure Apache runtime
  config.vm.provision "shell", path: "scripts/apache.sh"
  # create self-signed certificate for Apache
  config.vm.provision "shell", path: "scripts/https-cert.sh"

end
