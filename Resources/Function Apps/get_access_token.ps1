$resource = "https://vault.azure.net"
$url = "$($env:IDENTITY_ENDPOINT)?api-version=2019-08-01&resource=$resource"
Invoke-RestMethod -Uri $url -Method Get -Headers @{"X-IDENTITY-HEADER" = "$env:IDENTITY_HEADER"}