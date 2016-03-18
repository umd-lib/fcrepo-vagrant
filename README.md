# fcrepo-vagrant

1. Clone this repository:

    ```
    cd /apps/git
    git clone git@github.com:umd-lib/fcrepo-vagrant
    ```

2. Clone [fcrepo-env](https://github.com/umd-lib/fcrepo-env) into
   `/apps/git/fcrepo-env`, and check out the `vagrant` branch:
   
    ```
    git clone git@github.com:umd-lib/fcrepo-env.git -b vagrant
    ```

2. Build an fcrepo.war webapp and place it in the [dist](dist) directory:

    ```
    git clone git@github.com:umd-lib/fcrepo -b umd-develop
    cd fcrepo
    mvn clean package -Pwebac,noauth
    cp target/fcrepo*.war /apps/git/fcrepo-vagrant/dist
    ```
    
2. Download an [Oracle JDK 8](http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html)
    tarball (current version is 8u65) and place it in the [dist](dist) directory.

3. Run a local Solr using the [solr-env](https://github.com/umd-lib/solr-env) local
   branch:

    ```
    cd /apps
    git clone git@github.com:umd-lib/solr-env.git solr -b local
    cd /apps/solr/jetty

    mvn keytool:clean keytool:generateKeyPair

    sudo keytool -importkeystore \
      -srckeystore src/main/config/jetty-ssl.keystore \
      -srcstorepass jetty8 \
      -destkeystore $JAVA_HOME/jre/lib/security/cacerts \
      -deststorepass changeit

    nohup mvn jetty:run -Dsolr.solr.home=conf/fedora4 &
    ```

    This will start solr with fedora solr core with both http and https:

    * <http://localhost:8983/solr/>
    * <https://localhost:8443/solr/>

2. Add `fcrepolocal` to your workstation's `/etc/hosts` file:

    ```
    sudo echo "192.168.40.10  fcrepolocal" >> /etc/hosts
    ```

1. Start the Vagrant:

    ```
    cd /apps/git/fcrepo-vagrant
    vagrant up
    ```

5. Start the applications:

    ```
    vagrant ssh
    cd /apps/fedora
    ./control start
    ```

Congratulations, you should now have a running fcrepo-vagrant!

* Application Landing Page: <https://fcrepolocal/>
* Log in: <https://fcrepolocal/user>
* Fedora REST interface: <https://fcrepolocal/fcrepo/rest>

**Note:** The Apache web server in this Vagrant is configured to use a
self-signed certificate, which is regenerated each time you provision the
Vagrant. This means that the first time you bring up the Vagrant, and whenever
you destroy and recreate it, when you access <https://fcrepolocal/> through your
browser, you will get a certificate security warning.

### Configuring Karaf

Currently, you must build the custom UMD versions of fcrepo-java-client, fcrepo-camel,
and fcrepo-camel-toolbox, and manually copy them to the Maven repository directory
(`~/.m2/repository/org/fcrepo/{camel,client}`) on the Vagrant. Then you can set up the
Camel routes by running:

```
$ cd /apps/fedora/karaf
$ bin/client -f ../config/karaf-fcrepo-setup
```

**Note that the Camel routes do not work yet because the SSL certificates to
authenticate Karaf to Fedora and Solr are not correctly configured for the
Vagrant. See [LIBFCREPO-69](https://issues.umd.edu/browse/LIBFCREPO-69).**


## VM Info

|Attribute  |Value        |
|-----------|-------------|
|Hostname   |fcrepolocal  |
|IP Address |192.168.40.10|
|OS         |CentOS 6.6   |

[Vagrantfile](Vagrantfile)
