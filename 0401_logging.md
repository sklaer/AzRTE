# Azure & Entra ID Logging & Monitoring

## Entra ID Audit Logs

In Entra by checking audit logs, there is a suspiscious user created then deleted.

## Azure Activity Logs

jq -r '.[] | select(.operationName.value=="Microsoft.ManagedIdentity/userAssignedIdentities/write") | .resourceId' /tmp/activities.json
IDENTITY_NAME=$­(identity-flag-80bc4d9a87cf22e9b20c5dc380d96e2c)
echo "$IDENTITY_NAME" | sed -E 's/^identity-fl­ag-(.\*)$/flag{\­1}/'
