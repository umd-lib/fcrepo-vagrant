# -*- mode: ruby -*-
# vi: set ft=ruby :

system("scripts/install-trigger-plugin.sh")

Vagrant.configure(2) do |config|

  # PostgreSQL server
  config.vm.define "postgres" do |postgres|
    postgres.vm.box = "puppetlabs/centos-6.6-64-puppet"
    postgres.vm.box_version = "1.0.1"

    postgres.vm.hostname = 'pglocal'

    postgres.vm.network "private_network", ip: "192.168.40.12"

    postgres.vm.provision "shell", inline: <<-SHELL
      puppet module install puppetlabs-firewall
      puppet module install puppetlabs-postgresql
    SHELL

    postgres.vm.provision "puppet", manifest_file: 'postgres.pp', environment: 'local'
  end

  # Solr server
  config.vm.define "solr" do |solr|
    solr.vm.box = "puppetlabs/centos-6.6-64-puppet"
    solr.vm.box_version = "1.0.1"

    solr.vm.hostname = 'solrlocal'
    solr.vm.network "private_network", ip: "192.168.40.11"

    solr.vm.synced_folder "dist/solr", "/apps/dist"
    solr.vm.synced_folder "/apps/git/fedora4-core", "/apps/git/fedora4-core"

    # Puppet Modules
    solr.vm.provision "shell", inline: 'puppet module install puppetlabs-firewall'

    # system provisioning
    solr.vm.provision "puppet", manifest_file: 'solr.pp', environment: 'local'

    # JDK
    solr.vm.provision "shell", path: 'scripts/solr/jdk.sh'
    # Solr
    solr.vm.provision "shell", path: 'scripts/solr/solr.sh'

    # fedora4 Solr core
    solr.vm.provision "shell", path: 'scripts/solr/cores.sh'

    # CSR signing script
    solr.vm.provision "file", source: 'files/solr/signcsr', destination: '/apps/ca/signcsr'

    # control script
    solr.vm.provision "file", source: 'files/solr/control', destination: '/apps/solr/solr/control'

    # start Solr
    solr.vm.provision "shell", privileged: false, inline: 'cd /apps/solr/solr && ./control start'
  end

  # Fedora 4 Application
  config.vm.define "fcrepo" do |fcrepo|
    config.trigger.before :up do
      run  "scripts/fcrepo/restart-postgres.sh"
    end

    fcrepo.vm.box = "puppetlabs/centos-6.6-64-puppet"
    fcrepo.vm.box_version = "1.0.1"

    fcrepo.vm.hostname = 'fcrepolocal'
    fcrepo.vm.network "private_network", ip: "192.168.40.10"

    fcrepo.vm.synced_folder "dist/fcrepo", "/apps/dist"
    fcrepo.vm.synced_folder "/apps/git/fcrepo-env", "/apps/git/fcrepo-env"

    fcrepo.vm.provider "virtualbox" do |vb|
       vb.memory = "4096"
    end

    # Puppet Modules
    fcrepo.vm.provision "shell", inline: 'puppet module install puppetlabs-firewall'

    # system provisioning
    fcrepo.vm.provision "puppet", manifest_file: 'fcrepo.pp', environment: 'local'

    # configure Git
    fcrepo.vm.provision 'shell', path: 'scripts/fcrepo/git.sh', args: [`git config user.name`, `git config user.email`],
      privileged: false
    # install runtime env
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/env.sh"

    # copy the default vagrant key so we can easily ssh between fcrepo and solr boxes
    # this works because this base box adds the insecure public key to the vagrant
    # user's authorized_hosts file
    fcrepo.vm.provision "file",
      source: "#{ENV['HOME']}/.vagrant.d/insecure_private_key",
      destination: "/home/vagrant/.ssh/id_rsa"
    # get pre-built artifacts (from Nexus)
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/artifacts.sh"
    # install JDK
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/jdk.sh"
    # install Tomcat
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/tomcat.sh"
    # install Karaf
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/karaf.sh"
    # install Fuseki
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/fuseki.sh"
    # deploy webapps
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/webapps.sh", privileged: false
    # configure Apache runtime
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/apache.sh"
    # create self-signed certificate for Apache
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/https-cert.sh"

    # Add server-specific environment config
    fcrepo.vm.provision "file", source: 'files/fcrepo/env', destination: '/apps/fedora/config/env'

    # Create SSL CA and client certificates
    fcrepo.vm.provision "shell", inline: "cd /apps/fedora/scripts && ./sslsetup.sh", privileged: false

    # Start the applications
    fcrepo.vm.provision "shell", inline: "cd /apps/fedora && ./control start", privileged: false

    unless ENV['EMPTY_REPO']
      # Bootstrap the top-level collections and ACLs
      fcrepo.vm.provision "shell", inline: "cd /apps/fedora/scripts/bootstrap && ./bootstrap-repo.sh", privileged: false
    end

  end
end
