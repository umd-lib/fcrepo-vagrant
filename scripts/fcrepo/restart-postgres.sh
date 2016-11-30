#!/bin/bash

if [ ! -f .vagrant/machines/fcrepo/virtualbox/action_provision ]; then
   echo "Restarting postgres"
   vagrant ssh postgres -- sudo service  postgresql-9.5 restart
fi
