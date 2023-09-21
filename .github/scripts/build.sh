#!/usr/bin/env bash

sudo -E packer init .
sudo -E packer validate .
sudo -E packer build .
