#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

ENV_SRC_DIR=/apps/git/fcrepo-env
ENV_TARGET_DIR=/apps/fedora

# checkout over existing directories
git clone --no-checkout --no-hardlinks "file://$ENV_SRC_DIR/.git" /apps/fedora.tmp
mv /apps/fedora.tmp/.git "$ENV_TARGET_DIR"
rm -rf /apps/fedora.tmp
cd "$ENV_TARGET_DIR"
git reset --hard HEAD

chown -R "$SERVICE_USER_GROUP" "$ENV_TARGET_DIR"
