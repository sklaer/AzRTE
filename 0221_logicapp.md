# Logic App

## Create App

```sh
ngrok http 80

nc -lvnp 80

# Create the app
az logic workflow create --resource-group 02fedb58-logicapp-lab1-rg --name logic_test3 --definition ./workflow_def.json --location centralus # using ngrok endpoint

# Assign user/system identiy
az logic workflow identity assign --name logic_test -g 02fedb58-logicapp-lab1-rg --user-assigned "/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/02fedb58-logicapp-lab1-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/lab1-logicapp-uai"

# Run the app once created (if trigger defined)
az rest --method post --uri "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/02fedb58-logicapp-lab1-rg/providers/Microsoft.Logic/workflows/logic_test/triggers/{triggerName}/run?api-version=2016-10-01" --body '{}' --headers "Content-Type=application/json"


# Run the app (if manual trigger)
az rest --method POST --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourcegroups/02fedb58-logicapp-lab1-rg/providers/Microsoft.Logic/workflows/logic_test/triggers/manual/listCallbackUrl?api-version=2019-05-01" --query "value" -o tsv

curl -X POST "https://prod-16.centralus.logic.azure.com:443/workflows/4b687d37d5c84d56af878562da0ad527/triggers/manual/paths/invoke?api-version=2019-05-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=OlulRMVkBXKhxqQVCpDI5SJujrRVjYnY1lVMwjYLj1Q"
```
