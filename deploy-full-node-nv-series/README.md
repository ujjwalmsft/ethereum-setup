## Deploy a full node with an Azure NV-Series VM with Ubuntu

*   Deploy the Azure VM (NV-Series) with Ubuntu (in this case 16.04)
*   The disk space is to small therefore it is necessary to add another disk (e.g. 100 GByte HDD) [1]
    *   Create disk and attach it (e.g. via the Portal)
    *   SSH to the VM and run `sudo grep SCSI /var/log/syslog`
        *   Inspect the logs to get the identifier of the disk added
            *   To get the right identifier check the LUN number (last digit in the tuple)
    *   Format disk -> `sudo fdisk /dev/sdc` -> `n` -> `1` -> 2x `null` -> `w`
    *   Create file system -> `sudo mkfs -t ext4 /dev/sdc1`
    *   Create a directory where to mount the new file system to
        *   `sudo mkdir eth`
    *   Mount the drive
        *   `sudo mount /dev/sdc1 /eth`
    *   Check disks via `df -h` -> should be displayed
    *   To ensure that the drive is remounted automatically after reboot
        *   Get the UUID -> `sudo -i blkid`
        *   Open fstab -> `sudo vi /etc/fstab`
        *   Add the following line
            *   `UUID=fb9358fb-4239-4023-ae88-e2627f1c7a2d   /eth   ext4   defaults,nofail   1   2`
        *   Make the drive writeable
            *   `sudo chmod go+w /eth`

*   Install geth [2]
```
sudo apt-get install software-properties-common
sudo add-apt-repository -y ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install ethereum
```

*   Run Geth on the disk added and download the complete chain
    *   `nohup geth --datadir /eth/node &`
    *   Access the console via
        *   `geth attach ipc:///eth/node/geth.ipc`
    *   To see the output of the geth process
        *   Get pid via `ps aux`
        *   See output via `tail -f /proc/<pid>/fd/1`
        *   Cancel the process via `kill <pid>`
    *   The block sync will start automatically and will take a while

*   Attach and create a new account to act as coinbase
    *   `personal.newAccount("passphrase")`
    *   To backup the account go to `/eth/node/keystore`
        *   Store the corresponding `UTC...`