# Misc

## Routine

For each identity obtained:

```sh
# User id
az ad user show --id <upn>

# Resources
az resource list

# Assignment
curl -k -X GET "https://graph.microsoft.com/beta/rolemanagement/directory/transitiveRoleAssignments?\$count=true&\$filter=principalId%20eq%20'<user_id>'" \
-H "Authorization: Bearer $TOKEN" \
-H "ConsistencyLevel: eventual" \
-H "Content-Type: application/json" | jq

curl -k -X GET "https://graph.microsoft.com/beta/roleManagement/directory/roleDefinitions/<role_id>" \
-H "Authorization: Bearer $TOKEN" \
-H "Content-Type: application/json" | jq

```

## Useful commands
