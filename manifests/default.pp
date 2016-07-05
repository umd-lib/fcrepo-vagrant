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

firewall { '100 allow http and https access':
  dport  => [80, 81, 82, 443, 8080, 9600, 9601],
  proto  => tcp,
  action => accept,
}
