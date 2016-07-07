firewall { '100 allow HTTP and HTTPS access to Solr':
  dport => [8983, 8984],
  proto => tcp,
  action => accept,
}
