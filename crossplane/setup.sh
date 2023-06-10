#!/bin/bash


# containerd doesn't seem to work... 
# Initially I was having an issue where the docker socket wasn't in /var/run/docker.sock and it was only in ~/.rd/docker.sock...I fixed that with a symbolic link but then running `docker ps` would always show
# > error during connect: Get "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/json": EOF
# I worked around it by switching to moby instead of containerd but....what's up with that..
# `rdctl shell` did work, but it's like nothing was listening on the other end of the socket....
#
# IMHO Either the file share between the VM and my host machine isn't working, or the docker daemon itself isn't working...


kind create cluster



# Install Crossplane
# https://docs.crossplane.io/latest/software/install/


helm repo add crossplane-stable https://charts.crossplane.io/stable


helm repo update

helm install crossplane \
  --namespace crossplane-system \
  --create-namespace crossplane-stable/crossplane \
  -f crossplane.yaml \
  --wait
# Consider switching out --wait for --timeout.... I don't actually need
# the pods to be ready, I just need the CRD to get loaded


#####
# Set up the Azure Provider
# https://docs.crossplane.io/latest/getting-started/provider-azure/

cat <<EOF | kubectl apply -f -
apiVersion: pkg.crossplane.io/v1
kind: Provider
metadata:
  name: upbound-provider-azure
spec:
  package: xpkg.upbound.io/upbound/provider-azure:v0.29.0
EOF

# Wow. Per `k get crds | wc -l` this installs 716 different CRDs, which makes
# sense b/c it's installing a CRD per Azure service...but still...


if [[ ! -f azure-credentials.json ]]; then
  echo "Azure credentials not found. Check README.md for preconditions"
  exit
else
  echo "Azure credentials found, creating secret"

  kubectl create secret generic azure-secret -n crossplane-system --from-file=creds=./azure-credentials.json
fi

cat <<EOF | kubectl apply -f -
apiVersion: azure.upbound.io/v1beta1
kind: ProviderConfig
metadata:
  name: default
spec:
  credentials:
    source: Secret
    secretRef:
      namespace: crossplane-system
      name: azure-secret
      key: creds
EOF


# Try it out and create a simple Resource Group

# cat <<EOF | kubectl apply -f -
# apiVersion: azure.upbound.io/v1beta1
# kind: ResourceGroup
# metadata:
#   name: example-rg
# spec:
#   forProvider:
#     location: "East US"
#   providerConfigRef:
#     name: default
# EOF


# At this point in the demo, a real resource group has been created
# and can be viewed at https://portal.azure.com/#view/HubsExtension/BrowseResourceGroups
# Make sure to clean it up with `k delete resourcegroup --all` or the teardown script


