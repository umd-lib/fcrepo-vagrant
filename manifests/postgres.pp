Package {
  allow_virtual => false,
}

class { 'postgresql::globals':
  manage_package_repo => true,
  version             => '9.5',
}->
class { 'postgresql::server':
  listen_addresses  => '*',
  postgres_password => 'postgres',
}->

postgresql::server::db { 'fcrepo_modeshape5':
  user => 'fcrepo',
  owner => 'fcrepo',
  password => postgresql_password('fcrepo', 'fcrepo'),
  encoding => 'UNICODE',
}

postgresql::server::database_grant { 'fcrepo_modeshape5':
  privilege => 'ALL',
  db        => 'fcrepo_modeshape5',
  role      => 'fcrepo',
}

postgresql::server::pg_hba_rule { 'fcrepo@192.168.40.0/24:fcrepo_modeshape5':
  description => "Open up fcrepo_modeshape5 database for access over the network by fcrepo",
  type        => 'host',
  database    => 'fcrepo_modeshape5',
  user        => 'fcrepo',
  address     => '192.168.40.0/24',
  auth_method => 'md5',
}

firewall { '100 allow access to PostgreSQL':
  dport => [5432],
  proto => tcp,
  action => accept,
}
