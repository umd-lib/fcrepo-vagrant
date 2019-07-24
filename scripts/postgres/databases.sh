#!/bin/bash

# ensure correct permissions on .pgpass
chmod 600 $HOME/.pgpass

createdb -U postgres -h localhost --no-password fcrepo_audit
psql -U postgres -h localhost --no-password fcrepo_audit <$HOME/fcrepo_audit.sql
