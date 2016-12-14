#!/bin/bash

SERVICE_USER_GROUP=vagrant:vagrant

ENV_SRC_DIR=/apps/git/fcrepo-env
ENV_TARGET_DIR=/apps/fedora

git clone "file://$ENV_SRC_DIR/.git" "$ENV_TARGET_DIR"
chown -R "$SERVICE_USER_GROUP" "$ENV_TARGET_DIR"
