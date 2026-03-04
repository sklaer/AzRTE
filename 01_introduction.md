# Azure

## Entra ID

## API & Tokens

## Basic enumeration tools

### Az CLI

Log in and get token:

```sh
# Login (doesn't support token authentication)
az login
az login --u <user> --p <pwd>
az login --service-principal -u <sp_name> -p <pwd> -t <tenant>
az login --service-principal -u <sp_name> --certificate <cert.pem> -t <tenant>

#Get access token
az account get-access-token --resource-type ms-graph
az account get-access-token --resource-type aad-graph
az account get-access-token --resource-type arm
```

Basic commands:

```sh
# Help
az find 'vm'
az vm -h

# Configure defaults
az configure

# Get already logged-in user
az ad signed-in-user show

# Set current subscription
az account set --subscription <sub_name/sub_id>

# Access unsupported APIs (i.e. those for which get-access-token doesn't wokrs)

```

Azure CLI debug and MitM:

```sh
# Debug
az account management-group list --output table --debug

#MitM
export ADAL_PYTHON_SSL_NO_VERIFY=1
export AZURE_CLI_DISABLE_CONNECTION_VERIFICATION=1
export HTTPS_PROXY="http://127.0.0.1:8080"
export HTTP_PROXY="http://127.0.0.1:8080"

# If this is not enough
# Download the certificate from Burp and convert it into .pem format
# And export the following env variable
openssl x509 -in ~/Downloads/cacert.der -inform DER -out ~/Downloads/cacert.pem -outform PEM
export REQUESTS_CA_BUNDLE=/Users/user/Downloads/cacert.pem
```

## Azure PowerShell Module

MitM : Install the CA certificate on the computer, then use system proxy (set env variables `HTTPS_PROXY` and `HTTP_PROXY`)

## Microsoft Graph PowerShell Module
