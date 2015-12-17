package { 'httpd':
  ensure => '2.2.15-47.el6.centos.1',
}
package { 'mod_ssl':
  ensure => present,
}
package { 'openssl':
  ensure => present,
}
package { 'unzip':
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
  dport  => [80, 443, 8080, 9600, 9601],
  proto  => tcp,
  action => accept,
}
