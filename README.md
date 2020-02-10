# fcrepo-vagrant

This is a multi-machine Vagrant that simulates the UMD Libraries' production
Fedora 4 setup. It consists of a Solr server and the Fedora 4 application server
running ActiveMQ, Tomcat, Karaf, and Fuseki.

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
    
6. Start up an instance of Postgres from [umd-fcrepo-docker](https://github.com/umd-lib/umd-fcrepo-docker):

    ```
    git clone git@github.com:umd-lib/umd-fcrepo-docker.git
    docker volume create fcrepo-postgres-data
    cd umd-fcrepo-docker
    docker build -t umd-fcrepo-postgres .
    docker run -p 5432:5432 -v fcrepo-postgres-data:/var/lib/postgresql/data umd-fcrepo-postgres
    ```

7. Start the Vagrant:

    ```
    cd /apps/git/fcrepo-vagrant
    vagrant up
    ```

Congratulations, you should now have a running fcrepo-vagrant!

* Application Landing Page: <https://fcrepolocal/>
* Log in: <https://fcrepolocal/user>
* Fedora REST interface: <https://fcrepolocal/fcrepo/rest>
* Solr Admin interface: <http://solrlocal:8983/solr>
* ActiveMQ Admin Interface: <https://fcrepolocal/activemq/admin>

### Authentication

By default, Tomcat is configured to accept any UMD directory authenticated user
and assigns them `fedoraAdmin` privileges. This is controlled by the
`LDAP_COMMON_ROLE` environment variable in [config/env](files/fcrepo/env). The full Grouper role DN that is used is `cn=Application_Roles:Libraries:FCREPO:FCREPO-Administrator,ou=grouper,ou=group,dc=umd,dc=edu`.

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

bin/clientcert batchloader batchloader-client
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

## VM Info

|Box Name |Hostname   |IP Address   |OS        |Open Ports |
|---------|-----------|-------------|----------|-----------|
|fcrepo   |fcrepolocal|192.168.40.10|CentOS 6.6|80,443,8161,61613|
|solr     |solrlocal  |192.168.40.11|CentOS 6.6|8983,8984  |

[Vagrantfile](Vagrantfile)

[jdk]: http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html
[fcrepo-env]: https://bitbucket.org/umd-lib/fcrepo-env
[fedora4-core]: https://bitbucket.org/umd-lib/fedora4-core
[fcrepo-test]: https://bitbucket.org/umd-lib/fcrepo-test

## License

See the [LICENSE](LICENSE.md) file for license rights and limitations (Apache 2.0).

