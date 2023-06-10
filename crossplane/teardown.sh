#!/bin/bash
echo "This still has to be implemented you monster https://docs.crossplane.io/latest/software/uninstall/"




# Crossplane has an uninstallation process that specifies an order 
# in which resources need to be deleted.
# https://docs.crossplane.io/latest/software/uninstall/
#
# 1. Remove all composite resource definitions
# 2. Remove all remaining managed resources
# 3. Remove all providers

# I should probably be able to do `kubectl delete xrd --all` to get rid of resources
# if i'm doing a full teardown.

# kubectl delete resourcegroup --all








# This has to be the last step. Don't tear down K8s without
# tearing down Crossplane properly or it can leave cloud 
# resources running and cost $$$
kind delete cluster