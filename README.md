# fcrepo-vagrant

This is a multi-machine Vagrant that simulates the UMD Libraries' production
Fedora 4 setup. It consists of a PostgreSQL database server, a Solr server, and
the Fedora 4 application server running Tomcat, Karaf, and Fuseki.

## Setup

1. Clone this repository:

    ```
    cd /apps/git
    git clone git@github.com:umd-lib/fcrepo-vagrant
    ```

2. Clone [fcrepo-env] into
   `/apps/git/fcrepo-env`, and check out the `vagrant` branch:
   
    ```
    git clone git@github.com:umd-lib/fcrepo-env.git -b vagrant
    ```

3. Build an fcrepo.war webapp and place it in the [dist/fcrepo](dist/fcrepo) 
   directory:

    ```
    git clone git@github.com:umd-lib/fcrepo -b umd-develop
    cd fcrepo
    mvn clean package -Pwebac,noauth,audit
    cp target/fcrepo-webapp-plus-webac-audit-4.5.1.war \
        /apps/git/fcrepo-vagrant/dist/fcrepo/fcrepo.war
    ```

4. Build the fcrepo-indexing-solr JAR and place it in the
   [dist/fcrepo](dist/fcrepo) directory:

    ```
    cd /apps/git
    git clone git@github.com:umd-lib/fcrepo-camel-toolbox -b umd-custom
    cd fcrepo-camel-toolbox/fcrepo-indexing-solr
    mvn clean package
    cp target/fcrepo-indexing-solr-4.5.2-umd-0-SNAPSHOT.jar \
        /apps/git/fcrepo-vagrant/dist/fcrepo
    ```
    
5. Download an [Oracle JDK 8][jdk] tarball (current version is 8u65) and place a
   copy of it in both the [dist/fcrepo](dist/fcrepo) and [dist/solr](dist/solr)
   directories.

6. Add `fcrepolocal` to your workstation's `/etc/hosts` file:

    ```
    sudo echo "192.168.40.10  fcrepolocal" >> /etc/hosts
    ```

7. Start the Vagrant:

    ```
    cd /apps/git/fcrepo-vagrant
    vagrant up
    ```

8. Run additional setup on fcrepo and start the applications:

    ```
    vagrant ssh fcrepo
    cd /apps/fedora/scripts
    ./sslsetup.sh
    cd ..
    ./control start
    ```

Congratulations, you should now have a running fcrepo-vagrant!

* Application Landing Page: <https://fcrepolocal/>
* Log in: <https://fcrepolocal/user>
* Fedora REST interface: <https://fcrepolocal/fcrepo/rest>
* Solr Admin interface: <https://192.168.40.11:8984/solr>

### Restoring Repository Data

If you restore repository data from a JCR backup, you will need to restart
Tomcat before indexing will work properly. For some reason, the JCR restore
processes causes Tomcat to stop sending JMS messages.

### Testing

To confirm that the system is running properly, you may run the indexing tests
from [fcrepo-test]. Note that these tests must be run with a user that has write
access to <https://fcrepolocal/fcrepo/rest/tmp>.

### Self-Signed Certificate Warnings

The Apache web server in this Vagrant is configured to use a self-signed
certificate, which is regenerated each time you provision the Vagrant. This
means that the first time you bring up the Vagrant, and whenever you destroy and
recreate it, when you access <https://fcrepolocal/> through your browser, you
will get a certificate security warning.

The Solr web server also uses a self-signed HTTPS certificate, although that box
caches the certificate in [dist/solr](dist/solr) between runs, so you should
only have to enable a security exception in your browser for
<https://192.168.40.11:8984> once.

## VM Info

|Box Name |Hostname   |IP Address   |OS        |Open Ports|
|---------|-----------|-------------|----------|----------|
|fcrepo   |fcrepolocal|192.168.40.10|CentOS 6.6|80,82,443 |
|solr     |solrlocal  |192.168.40.11|CentOS 6.6|8983,8984 |
|postgres |pglocal    |192.168.40.12|CentOS 6.6|5432      |


[Vagrantfile](Vagrantfile)

[jdk]: http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html
[fcrepo-env]: https://github.com/umd-lib/fcrepo-env
[fcrepo-test]: https://bitbucket.org/umd-lib/fcrepo-test
