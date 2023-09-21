#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install wget qemu-user-static xz-utils -y -q -f

! command -v packer && (
  echo "packer not found"
  exit 1
)

sudo -E packer init .
sudo -E packer validate .
sudo -E packer build .
