#!/bin/bash

################################
# Next thing to do is create a Composition, which seems like the most "get started here"
# feature of Crossplane. That seems to be the feature which allows me to create 
# a new public interface and do basic templating to create actual managed resources
# which will then be reconciled with the infra provider.

# There's a tutorial for Composition Revisions, which actually seems 
# like the best way to get started, since it covers Compositions and also a little 
# bit about the lifecycle of Compositions.
# https://docs.crossplane.io/knowledge-base/guides/composition-revisions-example/


# I notice this tutorial uses AWS resources but doesn't actually mention setting up 
# AWS credentials. I assume this is because the purpose of the demo is to show how the
# transformation and versioning of resources works, but it doesn't matter if the managed
# resources actually get reconciled against the infra provider. 

# Given that, there's no need to modify the teardown script since it's not going to
# leave dangling infra

cat <<EOF | kubectl apply -f -
apiVersion: apiextensions.crossplane.io/v1
kind: Composition
metadata:
  labels:
    channel: dev
  name: myvpcs.aws.example.upbound.io
spec:
    writeConnectionSecretsToNamespace: crossplane-system
    compositeTypeRef:
      apiVersion: aws.example.upbound.io/v1alpha1
      kind: MyVPC
    resources:
    - base:
        apiVersion: ec2.aws.upbound.io/v1beta1
        kind: VPC
        spec:
            forProvider:
              region: us-west-1
              cidrBlock: 192.168.0.0/16
              enableDnsSupport: true
              enableDnsHostnames: true
      name: my-vpc
EOF


cat <<EOF | kubectl apply -f -
apiVersion: apiextensions.crossplane.io/v1
kind: CompositeResourceDefinition
metadata:
  name: myvpcs.aws.example.upbound.io
spec:
  group: aws.example.upbound.io
  names:
    kind: MyVPC
    plural: myvpcs
  versions:
  - name: v1alpha1
    served: true
    referenceable: true
    schema:
      openAPIV3Schema:
        type: object
        properties:
          spec:
            type: object
            properties:
              id:
                type: string
                description: ID of this VPC that other objects use to refer to it
            required:
            - id
EOF

# So at this point we created a Composition and a CompositeResourceDefinition...
#
# Running the following command shows that a CompositionRevision has been created, even though we didn't
# create that resource type...
#
#   kubectl get compositionrevisions -o="custom-columns=NAME:.metadata.name,REVISION:.spec.revision,CHANNEL:.metadata.labels.channel"
#
# Describing the CompositionRevision says the Composition is the parent, so I guess the Composition controller is what 
# creates the CompositionRevision?

######
# Creating Composite Resources

# Now the tutorial is talking about creating XRs, or CompositeResources...in contrast to another CR acronym...this naming is not great.
#
# So it sounds like the tutorial has 4 CompositeResources (XRs) that we're going to work with...each one will demonstrate a different
# way of handling updates. It seems like we're going to create an XR, then update the Composition, and then see what happens
# to the XR. 
# I think the data model is XR -> CompositionRevision -> Composition. This way you can change the mappings, which are like a shared module,
# but without immediately affecting everyone who uses that "shared module"

echo "Default update policy"

cat <<EOF | kubectl apply -f -
apiVersion: aws.example.upbound.io/v1alpha1
kind: MyVPC
metadata:
  name: vpc-auto
spec:
  id: vpc-auto
EOF

echo "The above resource should have been created with no errors"


echo "Manual update policy"

COMPOSITION_REF_NAME=`kubectl get compositionrevisions -o jsonpath='{$.items[0].metadata.name}'`

cat <<EOF | kubectl apply -f -
apiVersion: aws.example.upbound.io/v1alpha1
kind: MyVPC
metadata:
  name: vpc-man
spec:
  id: vpc-man # Does this always have to match the metadata.name?
  compositionUpdatePolicy: Manual
  compositionRevisionRef:
    name: ${COMPOSITION_REF_NAME}
EOF

echo "That should have created with no errors"



echo "Using a selector"
# For this part of the demo, we create one XR with channel "dev" and another with "staging"

cat <<EOF | kubectl apply -f -
apiVersion: aws.example.upbound.io/v1alpha1
kind: MyVPC
metadata:
  name: vpc-dev
spec:
  id: vpc-dev
  compositionRevisionSelector:
    matchLabels:
      channel: dev
EOF

cat <<EOF | kubectl apply -f -
apiVersion: aws.example.upbound.io/v1alpha1
kind: MyVPC
metadata:
  name: vpc-staging
spec:
  id: vpc-staging
  compositionRevisionSelector:
    matchLabels:
      channel: staging
EOF

kubectl get composite -o="custom-columns=NAME:.metadata.name, \
  SYNCED:.status.conditions[0].status, \
  REVISION:.spec.compositionRevisionRef.name, \
  POLICY:.spec.compositionUpdatePolicy, \
  MATCHLABEL:.spec.compositionRevisionSelector.matchLabels"

echo "In the output above, vpc-staging should have no REVISION, but the others should"
# This is because the first one uses "default" policy which seems to just pick the first/most-recent matching XR
# Then in the second we manually specify the revision to use
# In the third, we specify "dev" which matches the Composition created in the first step
# In the fourth, we specify a XR with the "staging" label, but there is no XR with that, so the revision is missing


################
# Create new Composition revisions
# from here the tutorial continues and it looks like we're going to make some changes to the Composition
# and see what happens with the CompositionRevisions (XRs)



# TODO after this i think i'll understand enough to do https://docs.crossplane.io/latest/concepts/composition/ and test out a bunch of different transformations
