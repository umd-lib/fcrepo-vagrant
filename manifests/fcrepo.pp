Package {
  allow_virtual => false,
}

package { 'epel-release':
  ensure => present,
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
package { 'stomppy':
  ensure  => present,
  require => Package['epel-release'],
}
package { 'python-requests':
  ensure  => present,
  require => Package['epel-release'],
}
package { 'PyYAML':
  ensure  => present,
  require => Package['epel-release'],
}

host { 'fcrepolocal':
  ip => '192.168.40.10',
}
host { 'solrlocal':
  ip => '192.168.40.11',
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

file { '/data/binaries':
  ensure => directory,
  owner  => 'vagrant',
  group  => 'vagrant',
}
