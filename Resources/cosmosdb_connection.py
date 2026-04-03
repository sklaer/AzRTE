from azure.cosmos import CosmosClient, PartitionKey

# Connection details
endpoint = "<your-account-endpoint>"
key = "<your-account-key>"

# Initialize Cosmos Client
client = CosmosClient(endpoint, key)

# Access existing database and container
database_name = '<SampleDB>'
container_name = '<SampleContainer>'
database = client.get_database_client(database_name)
container = database.get_container_client(container_name)

# Insert multiple documents
# items_to_insert = [
#     {"id": "1", "name": "Sample Item", "description": "This is a sample document."},
#     {"id": "2", "name": "Another Sample Item", "description": "This is another sample document."},
#     {"id": "3", "name": "Sample Item", "description": "This is a duplicate name sample document."},
# ]

# for item in items_to_insert:
#     container.upsert_item(item)

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