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

postgresql::server::db { 'ispn':
  user => 'fcrepo',
  owner => 'fcrepo',
  password => postgresql_password('fcrepo', 'fcrepo'),
  encoding => 'UNICODE',
}

postgresql::server::database_grant { 'ispn':
  privilege => 'ALL',
  db        => 'ispn',
  role      => 'fcrepo',
}

postgresql::server::pg_hba_rule { 'fcrepo@192.168.40.0/24:ispn':
  description => "Open up Infinispan database for access over the network by fcrepo",
  type        => 'host',
  database    => 'ispn',
  user        => 'fcrepo',
  address     => '192.168.40.0/24',
  auth_method => 'md5',
}

firewall { '100 allow access to PostgreSQL':
  dport => [5432],
  proto => tcp,
  action => accept,
}
