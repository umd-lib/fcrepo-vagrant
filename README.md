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
   `/apps/git/fcrepo-env`, and check out the `release/0.1.0` branch:
   
    ```
    git clone git@github.com:umd-lib/fcrepo-env.git -b release/0.1.0
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
    
4. Download an [Oracle JDK 8][jdk] tarball (current version is 8u65) and place a
   copy of it in both the [dist/fcrepo](dist/fcrepo) and [dist/solr](dist/solr)
   directories.

5. Add `fcrepolocal` to your workstation's `/etc/hosts` file:

    ```
    sudo echo "192.168.40.10  fcrepolocal" >> /etc/hosts
    ```

6. Start the Vagrant:

    ```
    cd /apps/git/fcrepo-vagrant
    vagrant up
    ```

Congratulations, you should now have a running fcrepo-vagrant!

* Application Landing Page: <https://fcrepolocal/>
* Log in: <https://fcrepolocal/user>
* Fedora REST interface: <https://fcrepolocal/fcrepo/rest>
* Solr Admin interface: <https://192.168.40.11:8984/solr>

### Starting the application 

The applications will only start automatically during the first `vagrant up` (provisioning). 
You should start solr and fedora manually anytime you restart the VM. 

#### Start Solr
```
vagrant ssh solr
cd /apps/solr/example
nohup java -jar start.jar >> solr.log &
```


#### Start Fedora
```
    vagrant ssh fcrepo
    cd /apps/fedora
    ./control start
```

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
certificate. This means that the first time you bring up the Vagrant, when you access <https://fcrepolocal/> through your browser, you will get a certificate 
security warning. The SSL certificate is cached in [dist/fcrepo](dist/fcrepo), so
if you destory and recreate the Vagrant, you will not have to add a new security exception. You can at any time delete the cached certificate to force the
regeneration the next time you provision the Vagrant.

The Solr web server also uses a self-signed HTTPS certificate, cached in [dist/solr](dist/solr).

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
