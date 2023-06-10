# Preconditions

Per https://marketplace.upbound.io/providers/upbound/provider-azure/v0.32.0/docs/configuration we need
to create a secret with the credentials. The Azure provider uses the output from the az cli

There needs to be an azure-credentials.json file. These are sensitive credentials, and should be .gitignored

```
az account subscription list | jq '.[] | select(.displayName == "Crossplane Testing").id'
az ad sp create-for-rbac --sdk-auth --role Owner --scopes ${SUBSCRIPTION_ID} > azure-credentials.json
```

The credentials show up under "Enterprise applications"
https://portal.azure.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/menuId~/null
be sure to remove the filtering... the clientID from the credentials file will match the Application ID and
the name column will be something like azure-cli-YYYY-MM-DD-HH-MM-SS


# Trying it out
Use the `setup.sh` and `teardown.sh` scripts.