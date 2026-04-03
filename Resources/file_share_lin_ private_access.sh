sudo mkdir /mnt/<FILE-SHARE-NAME>
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/<STORAGE-ACCOUNT>.cred" ]; then
    sudo bash -c 'echo "username=<STORAGE-ACCOUNT>" >> /etc/smbcredentials/<STORAGE-ACCOUNT>.cred'
    sudo bash -c 'echo "password=<ACCESS-KEY>" >> /etc/smbcredentials/<STORAGE-ACCOUNT>.cred'
fi
sudo chmod 600 /etc/smbcredentials/<STORAGE-ACCOUNT>.cred

sudo bash -c 'echo "//<STORAGE-ACCOUNT>.file.core.windows.net/<FILE-SHARE-NAME> /mnt/<FILE-SHARE-NAME> cifs nofail,credentials=/etc/smbcredentials/<STORAGE-ACCOUNT>.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" >> /etc/fstab'
sudo mount -t cifs //<STORAGE-ACCOUNT>.file.core.windows.net/<FILE-SHARE-NAME> /mnt/<FILE-SHARE-NAME> -o credentials=/etc/smbcredentials/<STORAGE-ACCOUNT>.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30