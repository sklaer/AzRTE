# App Services

## SSH

```sh
az webapp list
az webapp ssh --name 02fedb58-app-service-lab-1 -g 02fedb58-app-service-labs
```

Then on the VM:

```sh
cat site/wwwroot/app.js
```

## Basic auth FTP/SC­M Access

```sh
az webapp list
az webapp deployment list-publishing-profiles --name app-s-2-02fedb58 -g 02fedb58-app-service-labs

az keyvault list
az keyvault secret list --vault-name appservice-2-02fedb587e
```

Then using these credentials, we can access the `<SCM-URL>/BasicAuth` (SCM URL beeing `<app-name>.scm.azurewebsites.net` or here `app-s-2-02fedb58.scm.azurewebsites.net`)

Note: If SCM credentials are REDACTED, SCM basic authentication option need to be enabled:

```sh
az rest --method PUT --uri "https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<res-group>/providers/Microsoft.Web/sites/<app-name>/basicPublishingCredentialsPolicies/scm?api-version=2022-03-01" --body '{
        "properties": {
            "allow": true
        }
    }'

# Enable basic authentication for FTP
az rest --method PUT --uri "https://management.azure.com/subscriptions/<subscription-id>/resourceGroups/<res-group>/providers/Microsoft.Web/sites/<app-name>/basicPublishingCredentialsPolicies/ftp?api-version=2022-03-01" --body '{
        "properties": {
            "allow": true
        }
    }'
```

Then on the VM:

```sh
curl -H "X-IDENTITY-HEADER: $MSI_SECRET" "$MSI_ENDPOINT/?resource=https://graph.microsoft.com/&api-version=2019-08-01"
curl -H "X-IDENTITY-HEADER: $MSI_SECRET" "$MSI_ENDPOINT/?resource=https://vault.azure.net/&api-version=2019-08-01"
```

## Create webjob

```sh
az webapp list

# To create a webjob referencing the test.sh script
az rest \
  --method put \
  --uri "https://02fedb58-app-service-lab-3.scm.azurewebsites.net/api/Continuouswebjobs/test" \
  --headers '{"Content-Disposition": "attachment; filename=\"test.sh\""}' \
  --body "@/workspace/test.sh" \
  --resource "https://management.azure.com/"
```

Sh as well as runtime languages can be used:

```sh
ls /home/site/wwwroot
cat /home/site/wwwroot/app.js
```

Finally to read the webjob logs:

```sh
az rest --method GET --url "https://02fedb58-app-service-lab-3.scm.azurewebsites.net/vfs/data/jobs/continuous/test/job_log.txt" --resource "https://management.azure.com/"
```

## Change Contai­ner

```sh
az webapp list
az acr list
az keyvault list
az keyvault secret list --vault-name appservice-4-02fedb587e



az acr login -n d4bcd1d7appservicelab4
az webapp config container show -n app-s-4-d4bcd1d7 -g d4bcd1d7-app-service-labs # Docker custom image named /mcr.microsoft.com/appsvc/staticsite:latest

docker build -t d4bcd1d7appservicelab4.azurecr.io/test_cmd:latest .
docker push d4bcd1d7appservicelab4.azurecr.io/test_cmd:latest

az acr repository list -n d4bcd1d7appservicelab4

az webapp config container set -n app-s-4-d4bcd1d7 -g d4bcd1d7-app-service-labs --docker-custom-image-name d4bcd1d7appservicelab4.azurecr.io/test_cmd:latest
```

## Assign it a manage­d identi­ty

```sh
az webapp list
az identity list

az webapp identity assign --name 02fedb58-app-service-lab-5 --resource-group 02fedb58-app-service-labs --identities /subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/02fedb58-app-service-labs/providers/Microsoft.ManagedIdentity/userAssignedIdentities/app-service-lab-5-identity

az webapp deployment list-publishing-credentials -n d4bcd1d7-app-service-lab-5 -g d4bcd1d7-app-service-labs

# Then accessing Kudu from https://$d4bcd1d7-app-service-lab-5:hRftuTvbsPa8dH1uE3d5JshDwzfsZ9MyFQTvGlrnn82skMXjRMsHb1ELbqSi@d4bcd1d7-app-service-lab-5.scm.azurewebsites.net/BasicAuth

# From SSH console to application
curl -H "X-IDENTITY-HEADER: $MSI_SECRET" "$MSI_ENDPOINT/?resource=https://vault.azure.net/&api-version=2019-08-01&client_id=0835e2a3-b13b-4647-bbfc-5425918c203b"
```
