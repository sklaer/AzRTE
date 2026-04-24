export TENANT="fdd066e1-ee37-49bc-b08f-d0e152119b04"
export REFRESH="1.AUEB4Wb..."
export TOKEN=$(curl -s -X POST \
-d "client_id=1b730954-1685-4b74-9bfd-dac224a7b894" \
-d "grant_type=refresh_token" \
-d "refresh_token=$REFRESH" \
-d "scope=https://graph.microsoft.com/.default" \
https://login.microsoftonline.com/$TENANT/oauth2/v2.0/token | jq -r \
.access_token)

echo "Access token: ${TOKEN}"