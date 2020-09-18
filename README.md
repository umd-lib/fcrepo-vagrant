# fcrepo-vagrant

This is a Vagrant box that simulates the UMD Libraries' production Fedora application
server (fcrepo). It runs ActiveMQ, Tomcat, Karaf, and Fuseki.

## Setup

**Note:** The fcrepo-vagrant Vagrantfile expects the fcrepo-env repository to
be checked out in the same directory as fcrepo-vagrant.

The "umd-fcrepo-docker" respository can be checked out anywhere, but is
typically also a sibling directory of fcrepo-vagrant.

The fcrepo-vagrant repository is typically (but not required) to be checked out
in the "~/git/" directory (i.e., a "git" subdirectory in the user's home
directory). Therefore the typical directory structure is:

```
~/git/
   |-- fcrepo-vagrant/
   |-- fcrepo-env/
   |-- umd-fcrepo-docker/
```

1. Clone the necessary repositories:

    ```
    cd ~/git
    git clone git@github.com:umd-lib/fcrepo-vagrant
    git clone git@bitbucket.org:umd-lib/fcrepo-env.git
    git clone https://github.com/umd-lib/umd-fcrepo-docker.git
    ```

    **Note on fcrepo-env:**
    
    This will check out the latest `develop` branch. **Be aware** that the `develop` branch may contain dependencies on `SNAPSHOT` versions of Java code that may or may not be in the UMD Nexus. You can either:
    
    1. Check out a release tag of fcrepo-env, e.g. `git checkout 4.8.1`
    2. Build those dependencies locally with `mvn clean install`, since the fcrepo box is 
       configured to share your local `~/.m2` directory.
       
       To see the dependencies that need to be built, run `mvn dependency:copy` and build
       the missing dependency. The command only finds one missing dependency at a time, and
       so may need to be run multiple times to determine all the dependencies.
    
2. Add `fcrepolocal` to your workstation's `/etc/hosts` file:

    ```
    sudo echo "192.168.40.10  fcrepolocal" >> /etc/hosts
    ```
    
3. Start up an instance of Postgres from the Docker image:

    ```
    docker volume create fcrepo-postgres-data
    cd ~/git/umd-fcrepo-docker/postgres
    docker build -t docker.lib.umd.edu/fcrepo-postgres .
    docker run -p 5432:5432 -v fcrepo-postgres-data:/var/lib/postgresql/data docker.lib.umd.edu/fcrepo-postgres
    ```
    
    To run the Postgres Docker container in the background, add `-d` to the `docker run`
    command. To automatically delete the container (but not the data) when it is stopped,
    add `--rm` to the `docker run` command, i.e.:
    
    ```
    docker run -d --rm -p 5432:5432 -v fcrepo-postgres-data:/var/lib/postgresql/data docker.lib.umd.edu/fcrepo-postgres
    ```
    
4. Start up an instance of the fedora4 Solr core from the Docker image:

    ```
    docker volume create fcrepo-solr-fedora4-data
    cd ~/git/umd-fcrepo-docker/solr
    docker build -t docker.lib.umd.edu/fcrepo-solr-fedora4 .
    docker run -p 8983:8983 -v fcrepo-solr-fedora4-data:/var/opt/solr docker.lib.umd.edu/fcrepo-solr-fedora4
    ```
    
    To run the fedora4 Solr Core Docker container in the background, add `-d` to the
    `docker run` command. To automatically delete the container (but not the data) when
    it is stopped, add `--rm` to the `docker run` command, i.e.:
    
    ```
    docker run -d --rm -p 8983:8983 -v fcrepo-solr-fedora4-data:/var/opt/solr docker.lib.umd.edu/fcrepo-solr-fedora4
    ```

6. Start the Vagrant:

    ```
    cd ~/git/fcrepo-vagrant
    vagrant up
    ```

Congratulations, you should now have a running fcrepo-vagrant!

* Application Landing Page: <https://fcrepolocal/>
* Log in: <https://fcrepolocal/user>
* Fedora REST interface: <https://fcrepolocal/fcrepo/rest>
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

[Vagrantfile](Vagrantfile)

[jdk]: http://www.oracle.com/technetwork/java/javase/downloads/index-jsp-138363.html
[fcrepo-env]: https://bitbucket.org/umd-lib/fcrepo-env
[fcrepo-test]: https://bitbucket.org/umd-lib/fcrepo-test

## License

See the [LICENSE](LICENSE.md) file for license rights and limitations (Apache 2.0).

