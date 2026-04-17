# Service bus

## Access keys

```sh
az servicebus topic list -g topic-labs-rg-1 --namespace-name lab1serbusnm02fedb58
az servicebus namespace authorization-rule keys renew --key PrimaryKey --resource-group topic-labs-rg-1 --namespace-name lab1serbusnm02fedb58 --authorization-rule-name RootManageSharedAccessKey

az servicebus topic list -g topic-labs-rg-1 --namespace-name lab1serbusnm02fedb58
az servicebus topic subscription list -g topic-labs-rg-1 --namespace-name lab1serbusnm02fedb58 --topic-name labtopic

python3 get_message.py
```

## Add author­izatio­n-rule

```sh
az servicebus namespace list

az servicebus namespace authorization-rule create --authorization-rule-name "testRule" --namespace-name lab2serbusnm02fedb58 --resource-group topic-labs-rg-2 --rights Manage Listen Send

az servicebus namespace authorization-rule keys list --resource-group topic-labs-rg-2 --namespace-name lab2serbusnm02fedb58 --authorization-rule-name testRule

az servicebus topic list -g topic-labs-rg-1 --namespace-name lab1serbusnm02fedb58
az servicebus topic subscription list -g topic-labs-rg-2 --namespace-name lab2serbusnm02fedb58 --topic-name labtopic

python3 get_message.py
```
