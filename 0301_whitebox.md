# Azure & Entra ID Whitebox Methodology

## Starting point

- Entra ID : Global Reader
- Azure RBAC : Reader (or Security Reader if the client is reluctant) => both are not enough to read everything

What to check:

- Benchmark checks
- Service enumeration
- Exposed assets
- Permissions and access
- Integrations

## Benchmark checks

Frist thing is to run some benchmarks:

- Steampipe CIS
- Prowler
- Cloudsploit
- Scoutsuite
- Cloudfox
- etc.

Objective is to learn as fast as possible services which may be vulnerable

## Service enumeration

To confirm that all services has been found, check services within Cost Analysis in the Cost Management section

Then check services (as well as Entra ID) manually, confirm previous findings

## Exposed assets

Two ways to expose assets in Azure:

- Exposing ports and networks services to Internet (opening rules in FW/NSG or exposing services ports such as database services ports)
- Granting permissions to external users (opening storage accounts, inviting guests, trusting other tenants, etc.)

## Permissions and access

Identify potential dangerous permissions being given to principals and weak access configuration in Entra ID

Two catgories of dangerous permissions in Azure and Entra ID:

- Privilege exploitation: Allow a principal to access another principal
    - Azure: A principal can change the code of a function app which has a managed identity
    - Entra ID: A principal can change password of other users
- Post exploitation: Allow a user to misuse a service causing potential harm
    - Azure: Read sensitive data, overwrite information, run code, stop running service, etc.
    - Entra ID: Change conditionnal access policies, misconfigure PIM, create or modify applications

## External integration

Check other plateform integrated with the Azure subscription :

- Access to external identity provider (Okta, OneLogin, etc.) : check that only necessary permissions have been assigned
- External CI/CD plateform (GitHub actions), clouds (AWS, GCP) or K8S clusters (AKS) : check that only necessary permissions have been assigned
- On-premise AD synchronisation : AD compromission often imply tenant compromission

## Summary and report

Report must contain:

- Tenant and subscriptions audited with services and regions found used
- Potential architecture summary (why is each service used and how it is connected with other)
- Vulnerabilities and misconfiguration on each services (including exposition)
- List of unneeded permissions assigned explaining why they are too privileged and why they are not needed
- List of external plateform and guest users with access to the subscriptions/tenant

## Methodology

Start by using Steampipe:

- steampipe-mod-azure-compliance (all controls)
- steampipe-mod-azure-insights
- steampipe-mod-azuread-insights

Prowler:

- App: Need a service princpal with Global Reader role
- CLI: App authentication or Az CLI

CLI use :

```sh
# Install
pipx install prowler

# Collect

```

[Monkey365](https://github.com/silverhack/monkey365):

```ps1
Install-Module -Name monkey365 -Scope CurrentUser

# After cloning from GitHub
Get-ChildItem -Recurse c:\monkey365 | Unblock-File
Import-Module monkey365

Get-Help Invoke-Monkey365 -Examples

Invoke-Monkey365 -PromptBehavior SelectAccount -Instance Azure -Collect All -TenantID <tenant_id> -ExportTo HTML
```

Roadrecon:

```sh
roadrecon auth -u <user> -p <password> --tenant <tenant_id>
# If 403, using Azure cli instead of graph
roadrecon auth -u <user> -p <password> --tenant <tenant_id> -c 04b07795-8ddb-461a-bbee-02f9e1bf7b46
roadrecon gather
roadrecon gui
```

[PowerZure](https://github.com/hausec/PowerZure):

```ps1
Import-Module PowerZure
Connect-AzAccount

Get-AzureCurrentUser
Get-AzureUser -All
Get-AzureSQLDB
Get-AzureAppOwner
```

[AzureHound](https://github.com/SpecterOps/AzureHound):

```sh
azurehound list -u "$USERNAME" -p "$PASSWORD" -t "$TENANT" -o "mytenant.json"

# Reusing authent from az cli
JWT=$(az account get-access-token --resource https://graph.microsoft.com | jq -r .accessToken)
azurehound list --jwt "$JWT"
```

```sh
# Overview of resources types
az resource list | grep type
```

## Whitebox 1

Check custom role definition

```sh
az role definition list --custom-role-only
```

## Whitebox 2

Publicly accessible resource

```sh
# Retreived using azure storage explorer (blobs)
```

## Whitebox 3

Check function app configuration settings

```sh
az functionapp config appsettings list -n whiteboxLab2FunctionEnv6ece -g whitebox-lab-2
```

## Whitebox 4

Network control configuration

```sh
az network nsg list | grep description
```

## Whitebox 5

```sh
# Retreived using azure storage explorer (tables)
```

## Whitebox 6

Check queue metadata

```sh
az storage account list | grep name
az storage queue list --account-name whiteboxlab2storage6ece --auth-mode login
az storage queue metadata show -n whiteboxlab2queue --account-name whiteboxlab2storage6ece --auth-mode login
```

## Whitebox 7

Check automated workflows:

```sh
az logic workflow list
```

## Whitebox 8

Analyze container artifacts:

```sh
az acr login -n whiteboxlab2acr6ece
az acr repository list -n whiteboxlab2acr6ece
docker pull whiteboxlab2acr6ece.azurecr.io/whiteboxlab2flag
docker run -it whiteboxlab2acr6ece.azurecr.io/whiteboxlab2flag sh
```

## Whitebox 9

```sh
az rest --method GET --url "https://management.azure.com/providers/Microsoft.Web/sourcecontrols?api-version=2024-04-01"
az staticwebapp secrets list --name whiteboxlab2app6ece --resource-group whitebox-lab-2

https://whiteboxlab2app6ece.azurewebsites.net/


az rest --method PUT \
    --uri "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/whitebox-lab-2/providers/Microsoft.Web/sites/whiteboxlab2app6ece/basicPublishingCredentialsPolicies/scm?api-version=2022-03-01" \
    --body '{
        "properties": {
            "allow": true
        }
    }'

```

## Whitebox 10

Check automation variables

```sh
az rest --method GET --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/whitebox-lab-2/providers/Microsoft.Automation/automationAccounts/whiteboxlab2automation/variables?api-version=2024-10-23"
```
