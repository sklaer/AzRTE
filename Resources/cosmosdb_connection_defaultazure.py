from azure.identity import DefaultAzureCredential
from azure.cosmos import CosmosClient

# Use Azure AD for authentication
credential = DefaultAzureCredential()
endpoint = "<your-account-endpoint>"
client = CosmosClient(endpoint, credential)

# Access database and container
database_name = "<mydatabase>"
container_name = "<mycontainer>"
database = client.get_database_client(database_name)
container = database.get_container_client(container_name)

# Insert a document
item = {
    "id": "1",
    "name": "Sample Item",
    "description": "This is a test item."
}
container.create_item(item)
print("Document inserted.")