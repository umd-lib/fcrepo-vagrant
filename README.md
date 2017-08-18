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

2. Clone [fcrepo-env] into `/apps/git/fcrepo-env`, and check out the `develop`
   branch:
   
    ```
    git clone git@bitbucket.org:umd-lib/fcrepo-env.git -b develop
    ```
    
3. Clone [fedora4-core] into `/apps/git/fedora4-core`, and check out the `develop`
   branch:
   
   ```
   git clone git@bitbucket.org:umd-lib/fedora4-core.git -b develop
   ```
    
4. Download an [Oracle JDK 8][jdk] tarball (current version is 8u65) and place a
   copy of it in both the [dist/fcrepo](dist/fcrepo) and [dist/solr](dist/solr)
   directories.

5. Add `fcrepolocal` and `solrlocal` to your workstation's `/etc/hosts` file:

    ```
    sudo echo "192.168.40.10  fcrepolocal" >> /etc/hosts
    sudo echo "192.168.40.11  solrlocal" >> /etc/hosts
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
* Solr Admin interface: <https://solrlocal:8984/solr>
* ActiveMQ Admin Interface: <http://fcrepolocal:8161/admin>
  - Username/password: `admin`/`admin`

**Note:** See the "Troubleshooting" section if unable to access the Fedora REST interface after logging in.

### Starting the application 

The applications will only start automatically during the first `vagrant up` (provisioning). 
You should start solr and fedora manually anytime you restart the VM. 

#### Start Solr
```
vagrant ssh solr
cd /apps/solr/solr
./control start
```

#### Start Fedora
```
vagrant ssh fcrepo
cd /apps/fedora
./control start
```

### Bootstrap Repository Data

By default, the last step of provisioning the fcrepo machine creates a skeleton
of bootstrap content in the repository (top level containers and minimal ACLs to
support testing and interaction with the IIIF server). You can disable this step
to start from an empty repository by setting the environment variable `EMPTY_REPO`
before starting the Vagrant:

```
EMPTY_REPO=1 vagrant up
```

### Restoring Repository Data

If you restore repository data from a JCR backup, you will need to restart
Tomcat before indexing will work properly. For some reason, the JCR restore
processes causes Tomcat to stop sending JMS messages.

### Client Certificates

To create a client certificate signed by the fcrepo Vagrant's CA, run the
[bin/clientcert](bin/clientcert) script from the host (*not* the Vagrant!):

```
bin/clientcert
# creates fcrepo-client.{key,pem} with subject CN=fcrepo-client

bin/clientcert batchloader
# creates bactchloader.{key,pem} with subject CN=batchloader

bin/clientcert batchloader bactchloader-client
# creates batchloader-client.{key,pem} with subject CN=batchloader
```

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

|Box Name |Hostname   |IP Address   |OS        |Open Ports |
|---------|-----------|-------------|----------|-----------|
|fcrepo   |fcrepolocal|192.168.40.10|CentOS 6.6|80,443,8161|
|solr     |solrlocal  |192.168.40.11|CentOS 6.6|8983,8984  |
|postgres |pglocal    |192.168.40.12|CentOS 6.6|5432       |


[Vagrantfile](Vagrantfile)

## Troubleshooting

### 403 "Forbidden" error when accessing the REST interface after logging in

The Fedora REST interface is only available to users with CAS user ids in the Tomcat conf/server.xml file.

To add a user id:

1) Log in to the "fcrepo" Vagrant server:

```
cd /apps/git/fcrepo-vagrant
vagrant ssh fcrepo
```

2) Edit the /apps/fedora/tomcat/conf/server.xml

```
vi /apps/fedora/tomcat/conf/server.xml
```

adding the user name "userSearch" value as "(uid=\<USERNAME>)" where \<USERNAME> is the CAS directory id of the user being added:

```
        <Realm className="org.apache.catalina.realm.JNDIRealm"
              connectionURL="ldaps://directory.umd.edu"
              commonRole="fedoraAdmin"
              userBase="ou=people,DC=UMD,DC=EDU"
              userSearch="(&amp;(uid={0})(|(uid=mohideen)(uid=peichman)(uid=westgard)))"
              />
```

3) If Fedora is already running, restart:

```
cd /apps/fedora
./control restart
```


[jdk]: http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html
[fcrepo-env]: https://github.com/umd-lib/fcrepo-env/tree/0.1.0
[fedora4-core]: https://bitbucket.org/umd-lib/fedora4-core
[fcrepo-test]: https://bitbucket.org/umd-lib/fcrepo-test

## License

See the [LICENSE](LICENSE.md) file for license rights and limitations (Apache 2.0).

