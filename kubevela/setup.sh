#!/bin/bash


# I tried the standalone install first, but that was totally borked. The installer itself was wrong,
# and then it also used outdated velad commands that were totally missing.

kind create cluster

brew install kubevela

helm repo add kubevela https://charts.kubevela.net/core
helm repo update
helm install --create-namespace -n vela-system kubevela kubevela/vela-core --wait

# The above is the complete installation process for kubevela itself, but the tutorial expects
# that VelaUX is installed too

vela addon enable velaux

echo "The default username is 'admin' and the password is 'VelaUX12345'"

# Just using the most basic way to access velaux, but for a more professional
# installation they support using Services.
vela port-forward addon-velaux -n vela-system 8000:8000