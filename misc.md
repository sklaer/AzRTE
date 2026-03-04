# Misc

## Routine

For each identity obtained:

```sh
# User id
az ad user show --id <upn>

# Get user info
az ad signed-in-user show

# Resources
az resource list

# Entra role assignments
curl -k -X GET "https://graph.microsoft.com/beta/rolemanagement/directory/transitiveRoleAssignments?\$count=true&\$filter=principalId%20eq%20'<user_id>'" \
-H "Authorization: Bearer $TOKEN" \
-H "ConsistencyLevel: eventual" \
-H "Content-Type: application/json" | jq

curl -k -X GET "https://graph.microsoft.com/beta/roleManagement/directory/roleDefinitions/<role_id>" \
-H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json" | jq

# RBAC role assignments
az role assignment list --assignee "<email>" --all --output table

# RBAC eligible role assignment
az rest --method GET --uri "https://management.azure.com/subscriptions/<subscription-id>/providers/Microsoft.Authorization/roleEligibilitySchedules?api-version=2020-10-01"

```

## Useful commands/tools

### CloudPEASS

```sh
python3 AzurePEAS.py --use-username-password --username <username/sp_id> --password <password> --tenant-id fdd066e1-ee37-49bc-b08f-d0e152119b04
```
