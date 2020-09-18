# -*- mode: ruby -*-
# vi: set ft=ruby :

git_username = `git config user.name`.chomp
git_email = `git config user.email`.chomp

Vagrant.configure(2) do |config|
  # Fedora 4 Application
  config.vm.define "fcrepo" do |fcrepo|
    fcrepo.vm.box = "puppetlabs/centos-6.6-64-puppet"
    fcrepo.vm.box_version = "1.0.1"

    fcrepo.vm.hostname = 'fcrepolocal'
    fcrepo.vm.network "private_network", ip: "192.168.40.10"
    fcrepo.vm.synced_folder "dist/fcrepo", "/apps/dist"
    fcrepo.vm.synced_folder "../fcrepo-env", "/apps/git/fcrepo-env"
    # share the local Maven repo for rapid testing of Karaf features
    local_maven_repo = "#{ENV['HOME']}/.m2"
    fcrepo.vm.synced_folder local_maven_repo, "/home/vagrant/.m2" if Dir.exist? local_maven_repo

    fcrepo.vm.provider "virtualbox" do |vb|
       vb.memory = "4096"
    end

    # Update SSL certificate authorities
    fcrepo.vm.provision 'shell', inline: 'yum install -y ca-certificates'

    # Puppet Modules
    fcrepo.vm.provision "shell", inline: <<-SHELL
      # puppetlabs-stdlib is "pinned" to v4.22.0 for "fcrepo.pp"
      puppet module install puppetlabs-stdlib --version 4.22.0
      # puppetlabs-firewall is "pinned" to v1.10.0 for "fcrepo.pp"
      puppet module install puppetlabs-firewall --version 1.10.0
    SHELL

    # system provisioning
    fcrepo.vm.provision "puppet", manifest_file: 'fcrepo.pp', environment: 'local'

    # configure Git
    fcrepo.vm.provision 'shell', path: 'scripts/git.sh', args: [git_username, git_email], privileged: false
    # install runtime env
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/env.sh"
    # Add server-specific environment config
    fcrepo.vm.provision "file", source: 'files/fcrepo/env', destination: '/apps/fedora/config/env'

    # copy the default vagrant key so we can easily ssh between fcrepo and solr boxes
    # this works because this base box adds the insecure public key to the vagrant
    # user's authorized_hosts file
    fcrepo.vm.provision "file",
      source: "#{ENV['HOME']}/.vagrant.d/insecure_private_key",
      destination: "/home/vagrant/.ssh/id_rsa"

    # install JDK
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/jdk.sh"
    # install Tomcat
    fcrepo.vm.provision 'shell', inline: '/apps/fedora/setup/install-tomcat.sh'
    # install ActiveMQ
    fcrepo.vm.provision 'shell', inline: '/apps/fedora/setup/install-activemq.sh'
    # install Karaf
    fcrepo.vm.provision 'shell', inline: '/apps/fedora/setup/install-karaf.sh'
    # install Maven
    fcrepo.vm.provision 'shell', inline: '/apps/fedora/setup/install-maven.sh'
    # install Fuseki
    fcrepo.vm.provision 'shell', inline: '/apps/fedora/setup/install-fuseki.sh'
    # configure Apache runtime
    fcrepo.vm.provision 'shell', inline: '/apps/fedora/setup/configure-apache.sh'
    # install pyenv and Python 3
    fcrepo.vm.provision 'shell', inline: '/apps/fedora/setup/install-python.sh', privileged: false

    # deploy artifacts (JARs and WARs) from Nexus
    fcrepo.vm.provision "shell", inline: "cd /apps/fedora && mvn dependency:copy", privileged: false
    # create self-signed certificate for Apache
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/https-cert.sh"

    # Create SSL CA and client certificates and cache CA to /apps/dist
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/sslsetup-cache.sh", privileged: false

    # vagrant user dotfiles
    fcrepo.vm.provision 'file', source: 'files/fcrepo/.curlrc', destination: '/home/vagrant/.curlrc'

    # Start the applications
    fcrepo.vm.provision "shell", inline: "cd /apps/fedora && ./control start", privileged: false, run: 'always'

    unless ENV['EMPTY_REPO']
      # Bootstrap the system users
      fcrepo.vm.provision "shell", inline: "/apps/fedora/scripts/bootstrap/create-users.sh", privileged: false
      # Bootstrap the top-level collections and ACLs
      fcrepo.vm.provision "shell", inline: "/apps/fedora/scripts/bootstrap/create-containers.sh", privileged: false
    end

  end
end
