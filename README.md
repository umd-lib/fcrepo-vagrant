# fcrepo-vagrant

## Quick Start

1. Place the following in the [dist](dist) directory:
    1. Oracle JDK 8
    2. optional-authn-valve JAR (built from [optional-authn-valve](https://github.com/umd-lib/optional-authn-valve) with
       `mvn clean package`)
    3. fcrepo.war (built from [fcrepo](https://github.com/umd-lib/fcrepo) using `mvn clean package -Pwebac,noauth,ispn-remote`)
    4. user.war (built from [fcrepo-user-webapp](https://github.com/umd-lib/fcrepo-user-webapp) with `mvn clean package`)
2. Run a local Solr using the [solr-env](https://github.com/umd-lib/solr-env) local branch.
    1. Copy the `fedora4` core directory from fcrepodev to your local solr-env `cores` 
       directory.
    2. Add `<core instanceDir="cores/fedora4/" name="fedora4" dataDir="data"/>`
       to the `solr.xml` in your copy of solr-env.
    3. Follow the [solr-env local instructions](https://github.com/umd-lib/solr-env/blob/local/README.md) for running Solr 
       locally
2. Add `fcrepolocal` to your workstation's `/etc/hosts` file:

    ```
    192.168.40.10  fcrepolocal
    ```

3. Clone [fcrepo-env](https://github.com/umd-lib/fcrepo-env) into `/apps/git/fcrepo-env`, and check out the `vagrant` branch
4. Start the Vagrant: `vagrant up`
5. Start the applications:

    ```
    $ vagrant ssh
    $ cd /apps/fedora
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

[Vagrantfile](Vagrantfile)

## TODO

1. Simplify preqrequisites
   * Incldue a builder script that runs on the host and builds the prerequisite JARs
     and WARs
   * Progamatically add the /etc/hosts entry to the host workstation
   * Simplify the Solr setup
