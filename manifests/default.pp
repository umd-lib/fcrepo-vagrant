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
  dport  => [8080, 9600, 9601],
  proto  => tcp,
  action => accept,
}
