# -*- mode: ruby -*-
# vi: set ft=ruby :

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

    # Puppet Modules
    solr.vm.provision "shell", inline: 'puppet module install puppetlabs-firewall'

    # system provisioning
    solr.vm.provision "puppet", manifest_file: 'solr.pp', environment: 'local'

    # JDK
    solr.vm.provision "shell", path: 'scripts/solr/jdk.sh'
    # Solr
    solr.vm.provision "shell", path: 'scripts/solr/solr.sh'

    # CSR signing script
    solr.vm.provision "file", source: 'files/solr/signcsr', destination: '/apps/ca/signcsr'
    # Jetty config
    solr.vm.provision "file", source: 'files/solr/jetty.xml', destination: '/apps/solr/example/etc/jetty.xml'
    solr.vm.provision "file", source: 'files/solr/schema.xml', destination: '/apps/solr/example/solr/fedora4/conf/schema.xml'
    solr.vm.provision "file", source: 'files/solr/solrconfig.xml', destination: '/apps/solr/example/solr/fedora4/conf/solrconfig.xml'
    solr.vm.provision "file", source: 'files/solr/blacklight-helper.js', destination: '/apps/solr/example/solr/fedora4/conf/blacklight-helper.js'

    # start Solr
    solr.vm.provision "shell", privileged: false, inline: <<-SHELL
      cd /apps/solr/example
      java -jar start.jar >solr.log &
    SHELL
  end

  # Fedora 4 Application
  config.vm.define "fcrepo" do |fcrepo|
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
    # install runtime env
    fcrepo.vm.provision "shell", path: "scripts/fcrepo/env.sh"
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

    # Bootstrap the ACLs for the iiif server user
    # TODO: broaden this to a generic bootstrapping (see https://issues.umd.edu/browse/LIBFCREPO-122)
    fcrepo.vm.provision "shell", inline: "cd /apps/fedora/scripts && ./add-iiif-acl.sh", privileged: false

  end
end
