#! /bin/bash

if [[ $(vagrant plugin list | grep -c vagrant-triggers) == "0" ]]; then
  echo "vagrant-triggers plugin not found on the host machine..."
  vagrant plugin install vagrant-triggers
  if [ $? == 0 ]; then
    echo "Plugin install completed."
    echo
    echo "PLEASE RUN 'vagrant up' AGAIN"
    echo
    echo
  else
    echo "Failed to install vagrant-triggers plugin!"
    exit 1
  fi
fi
