# File Share

## Connec­t to a File share

```sh
az storage account list
az storage share list --account-name <account_name>
az storage file list --account-name filesharelab1d090e49dac --share-name file-share-lab-1
az storage file download -p flag-lab-1.txt --account-name filesharelab1d090e49dac --share-name file-share-lab-1
```

## Networ­k restri­ctions

```sh
az storage account list
az storage share list --account-name <account_name> # This request is not authorized to perform this operation. // ErrorCode:AuthorizationFailure
az storage account update --name filesharelab2d090e49dac --resource-group file_share-labs-rg-2 --default-action Allow
az storage file list --account-name filesharelab2d090e49dac --share-name file-share-lab-2
az storage file download -p flag-lab-1.txt --account-name filesharelab1d090e49dac --share-name file-share-lab-1
```

## Access throug­h privat­e networ­k

```sh
az network public-ip list
az network public-ip show -g file_share-labs-rg-3 -n lab3-vm-public-ip
ssh azureuser@20.124.240.143

sudo mkdir /mnt/file-share-lab-3
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/filesharelab3d090e49dac.cred" ]; then
    sudo bash -c 'echo "username=filesharelab3d090e49dac" >> /etc/smbcredentials/filesharelab3d090e49dac.cred'
    sudo bash -c 'echo "password=MbknxbUGIg3FrAbqkGvdRwSjF0LHIt2OfAHLL2S5aj69FFxAEUxPpaxT2rZM7JXQyBUzyOOs9gJU+AStSDJS2w==" >> /etc/smbcredentials/filesharelab3d090e49dac.cred'
fi
sudo chmod 600 /etc/smbcredentials/filesharelab3d090e49dac.cred

sudo bash -c 'echo "//filesharelab3d090e49dac.file.core.windows.net/file-share-lab-3 /mnt/file-share-lab-3 cifs nofail,credentials=/etc/smbcredentials/filesharelab3d090e49dac.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" >> /etc/fstab'
sudo mount -t cifs //filesharelab3d090e49dac.file.core.windows.net/file-share-lab-3 /mnt/file-share-lab-3 -o credentials=/etc/smbcredentials/filesharelab3d090e49dac.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30
```

## Sensit­ive inform­ation in a snapsh­ot

```sh
az storage account list
az storage share list --account-name <account_name>
az storage share snapshot --account-name filesharelab4d090e49dac --name file-share-lab-4

az storage share list --account-name filesharelab4d090e49dac --include-snapshots --query "[?snapshot != null]" # To list existing snapshots
az storage file list --account-name filesharelab4d090e49dac --share-name file-share-lab-4 --snapshot 2026-04-01T13:02:50.0000000Z # no files
az storage file download -p flag-lab-4.txt --account-name filesharelab4d090e49dac --share-name file-share-lab-4 --snapshot 2026-04-01T13:02:50.0000000Z
```

## Restor­e a file share

```sh
az storage account list
az storage share-rm list -g file_share-labs-rg-5 --storage-account filesharelab5d090e49dac --include-deleted # file-share-lab-5_01DCC1D7D48CFFE1
az storage share-rm restore -n file-share-lab-5 --deleted-version 01DCC1D7D48CFFE1 -g file_share-labs-rg-5 --storage-account filesharelab5d090e49dac

az storage share list --account-name <account_name>
az storage file list --account-name filesharelab5d090e49dac --share-name file-share-lab-5
az storage file download -p flag-lab-5.txt --account-name filesharelab5d090e49dac --share-name file-share-lab-5
```
