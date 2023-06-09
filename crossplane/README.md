# Preconditions

There needs to be an azure-credentials.json file

```
az account subscription list | jq '.[] | select(.displayName == "Crossplane Testing").id'
az ad sp create-for-rbac --sdk-auth --role Owner --scopes ${SUBSCRIPTION_ID} > azure-credentials.json
```

These are sensitive credentials, and should be .gitignored

The credentials show up under "Enterprise applications"
https://portal.azure.com/#view/Microsoft_AAD_IAM/StartboardApplicationsMenuBlade/~/AppAppsPreview/menuId~/null
be sure to remove the filtering... the clientID from the credentials file will match the Application ID and
the name column will be something like azure-cli-YYYY-MM-DD-HH-MM-SS


