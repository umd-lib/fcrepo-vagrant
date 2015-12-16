# fcrepo-vagrant

## Quick Start

1. Place the following in the [dist](dist) directory:
    1. Oracle JDK 8
    2. optional-authn-valve JAR
    3. fcrepo.war (built from fcrepo-webapp-plus)
    4. user.war (built from fcrepo-user-webapp)
2. `vagrant up`
3. `vagrant ssh`
4. Start the base applications (Infinispan and Tomcat):

    ```
    $ cd /apps/fedora/infinispan-server
    $ ./control start
    $ cd ../tomcat
    $ ./control start
    ```

Log in: <http://192.168.40.10:8080/user>

Fedora: <http://192.168.40.10:8080/fcrepo>

## VM Info

|Attribute  |Value        |
|-----------|-------------|
|Hostname   |fcrepolocal  |
|IP Address |192.168.40.10|
|OS         |CentOS 6.6   |
