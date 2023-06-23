#!/bin/bash


# I tried the standalone install first, but that was totally borked. The installer itself was wrong,
# and then it also used outdated velad commands that were totally missing.

kind create cluster

brew install kubevela

helm repo add kubevela https://charts.kubevela.net/core
helm repo update
helm install --create-namespace -n vela-system kubevela kubevela/vela-core --wait
