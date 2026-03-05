# KeyVault

## Get a secret from an old version

```sh
# Check secrets in key vault
az keyvault show -n kv-1-d090e49d -g key-vault-labs
az keyvault secret list --vault-name kv-1-d090e49d
az keyvault secret show --vault-name kv-1-d090e49d --name secret-1-d090e49d-72139

# Secret is redacted, try to list version
az keyvault secret list-versions --vault-name kv-1-d090e49d --name secret-1-d090e49d-72139
az keyvault secret show --vault-name kv-1-d090e49d --name secret-1-d090e49d-72139 --version 47115137a010416ba9ffc4a4f96dd000
```

## Decrypt information with a key

```sh
# List keys
az keyvault key list --vault-name kv-2-d090e49d

# Identify algorithm used
az keyvault key show --vault-name kv-2-d090e49d --name key-2-d090e49d

# Decrypt value
az keyvault key decrypt --vault-name kv-2-d090e49d --name key-2-d090e49d -a RSA-OAEP --value "TuW5hxr0pe9GQf5zglb+sXfyUh21/AC5u6WtgqAbKgC/vnO5o0DT707TrrKEabI8TfXpiArvLZWNke/WMSwi0h7B52R/rn1bMNx9FMb3PoDu9/9ivuKjLTxMWX51+ar8NtNTCtCKwaMT5NOHCpKxoaFDa3f2OLQbgCdLInW5PTyjDPkaSrC9JVWFMEzMu4StI/Yx9h1X2vFkbPpiat/DuodPLvjjJ1iwBs7X9V1y64hvpDqYbro1ZRlopDI1JhrV8HID1a3YAvsFMfKhXFJ+ILZ9JxFXFUxo/QaoCvvdcgJiG83FuGxIaWI2YhIL8WYHf7WubqKt7nsskWYEougCxw=="
```

## Restore a secret

```sh
az keyvault secret list-deleted --vault-name kv-3-d090e49d
az keyvault secret recover --vault-name kv-3-d090e49d -n secret-3-d090e49d-72139
az keyvault secret show --vault-name kv-3-d090e49d -n secret-3-d090e49d-72139
```
