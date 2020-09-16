Package {
  allow_virtual => false,
}

package { 'ca-certificates':
  ensure => latest,
}
package { 'nss':
  ensure => latest,
}
package { 'curl':
  ensure => latest,
}
package { 'epel-release':
  ensure  => present,
  require => [
    Package['ca-certificates'],
    Package['nss'],
    Package['curl'],
  ],
}
package { 'httpd':
  ensure => present,
}
package { 'mod_ssl':
  ensure  => present,
  require => Package['httpd'],
}
package { 'mod_auth_cas':
  ensure  => present,
  require => Package['epel-release'],
}
package { 'openssl':
  ensure => present,
}
package { 'vim-enhanced':
  ensure => present,
}
package { 'tree':
  ensure => present,
}
package { 'lsof':
  ensure => present,
}
package { 'jq':
  ensure => present,
  require => Package['epel-release'],
}
package { 'nc':
  ensure => present,
}
package { 'git':
  ensure => present,
}
package { 'zlib-devel':
  ensure => latest,
}
package { 'bzip2':
  ensure => latest,
}
package { 'bzip2-devel':
  ensure => latest,
}
package { 'readline-devel':
  ensure => latest,
}
package { 'sqlite':
  ensure => latest,
}
package { 'sqlite-devel':
  ensure => latest,
}
package { 'openssl-devel':
  ensure => latest,
}
package { 'xz':
  ensure => latest,
}
package { 'xz-devel':
  ensure => latest,
}
package { 'libffi-devel':
  ensure => latest,
}

host { 'fcrepolocal':
  ip => '192.168.40.10',
}

firewall { '100 allow http and https access':
  dport  => [80, 443],
  proto  => tcp,
  action => accept,
}
firewall { '110 allow JMX remote access':
  dport  => [10001, 10002],
  proto  => tcp,
  action => accept,
}
firewall { '120 allow STOMP remote access':
  dport  => [61613],
  proto  => tcp,
  action => accept,
}

file { ['/data', '/data/binaries']:
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant',
}

file { ['/apps/fedora', '/apps/fedora/logs', '/apps/fedora/webapps']:
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant',
}
