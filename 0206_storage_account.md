# Storage Accounts

## Read flag from a blob with a given access­key

```sh
az storage container list --account-name storagelab1d090e49d --account-key <access_key>
az storage blob list --account-name storagelab1d090e49d --account-key <access_key> -c <container_name>
az storage blob download --account-name storagelab1d090e49d --account-key <access_key> -c <container_name> -n <file_name> -f <file_to_save>
```

## Storag­e SAS URL

Use SAS url

## Storag­e Accoun­t Versio­ns

```sh
az storage blob list --account-name storagelab3d090e49d -c container-lab-3 --include v
az storage blob download --account-name storagelab3d090e49d --container-name container-lab-3 -n flag-lab-3.txt -f ./flag-lab-3.txt --version-id "2026-03-07T22:45:27.1297663Z"
```

## Brute-­force to find open blob

```sh
feroxbuster -w ./best1050.txt -u "https://htstoraged090e49d.blob.core.windows.net/container-lab-5/" -x txt
```

## Local-­User passwo­rd and access

```sh
# Enable SFTP
az storage account update -n storagelab6d090e49d -g storage-labs-rg-6 --enable-sftpp true

# List local user then reset its password
az storage account local-user list --account-name storagelab6d090e49d -g storage-labs-rg-6
az storage account local-user regenerate-password --account-name storagelab6d090e49d -g storage-labs-rg-6--name user

# Connect to storage account through SFTP
sftp <storage-account-name>.<local-user-name>@<storage-account-name>.blob.core.windows.net
```

##

```sh
# List deleted storage accounts
az storage container list --account-name storagelab7d090e49d --account-key <access_key> --include-deleted

# Restore it
az storage container list --account-name storagelab7d090e49d --account-key <access_key> -n container-lab-7 --deleted-version 01DCAE8416617AA5

az storage blob list --account-name storagelab7d090e49d -c container-lab-7
az storage blob download --account-name storagelab7d090e49d -c container-lab-7 -n flag-lab-7.txt -f ./flag-lab-7.txt
```
