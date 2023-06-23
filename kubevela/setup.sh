#!/bin/bash

# Using https://kubevela.io/docs/installation/standalone/ but there seems to be a bug in their
# install script right now. The workaround is to download install-velad.sh directly, then
# put some echo statements in the installFile function, grab the binary off disk, and 
# move it into /usr/local/bin/ by hand
#
# There seems to be another bug in the standalone installer...

if command -v "velad" &>/dev/null; then
  echo "VelaD already installed..."
else
  curl -fsSl https://static.kubevela.net/script/install-velad.sh | bash
fi

velad install
# The following lines are output by the install command, but it seems to be trying to symlink
# a path to itself? Is the standalone installer just really buggy?
#
# Working around it by just doing a brew install which is actually recommended
# by https://go-vela.github.io/docs/reference/cli/install/
# 
# Checking and installing vela CLI...
# vela CLI is not installed, installing...
# Installing vela CLI at:  /usr/local/bin/vela
# fail to install vela CLI: Fail to create symlink: symlink /usr/local/bin/velad /usr/local/bin/vela: permission denied
# Saving and temporary image file: vela-image-cluster-gateway-*.tar

export KUBECONFIG=$(velad kubeconfig --host)
vela comp

vela addon enable ~/.vela/addons/velaux

vela port-forward addon-velaux -n vela-system 8080:80

echo "The default username is 'admin' and the password is 'VelaUX12345'."