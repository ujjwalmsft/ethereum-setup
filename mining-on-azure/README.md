# GPU Mining in the Ethereum Public Network on Ubuntu on an Azure NV VM


## Create an Ethereum account to server as coinbase (optinal)
*   E.g. via [myetherwallet](https://www.myetherwallet.com/)


## Install geth and ethminer [1]
```
sudo apt-get install software-properties-common  
sudo add-apt-repository ppa:ethereum/ethereum  
sudo apt-get update
sudo apt-get install ethereum ethminer geth
```

## Install the drivers for the NVIDIA cards [2]
*   Verify that the NVIDIA cards are available
    *   `lspci`

*   Install gcc (ifnecessary)
    *   `sudo apt-get install gcc`

*   Install updates
```
sudo apt-get update

sudo apt-get upgrade -y

sudo apt-get dist-upgrade -y

sudo apt-get install build-essential ubuntu-desktop -y
```

*   Disable the Nouveau kernel driver, which is incompatible with the NVIDIA driver. (Only use the NVIDIA driver on NV VMs.) To do this, create a file in `/etc/modprobe.d` named `nouveau.conf`  via `sudo vi nouveau.conf` with the following contents
```
blacklist nouveau

blacklist lbm-nouveau
```

*   Reboot the VM and reconnect. Exit X server
```
sudo systemctl stop lightdm.service
```

*   Download and install the GRID driver. When you're asked whether you want to run the nvidia-xconfig utility to update your X configuration file, select Yes.
```
wget -O NVIDIA-Linux-x86_64-367.92-grid.run https://go.microsoft.com/fwlink/?linkid=849941

chmod +x NVIDIA-Linux-x86_64-367.92-grid.run

sudo ./NVIDIA-Linux-x86_64-367.92-grid.run
```

*   After installation completes, add the following to `/etc/nvidia/gridd.conf.template`
```
IgnoreSP=TRUE
```

*   Reboot the VM and proceed to verify the installation


## Start mining [1]

*   Connected to a mining pool
    *   `nohup ethminer -G -M -F http://eth-eu.dwarfpool.com:80/YOUR_WALLET_ADDRESS &`
        *   -G : use GPU
        *   -M : monitor
        *   -F : use mining pool

*   To see the output of the process
    *   See output via
            *   Get pid -> `ps aux`
            *   See output via -> `tail -f /proc/<pid>/fd/1`


# Resources
1.  [Ethereum mining in Azure](https://blog.vincent.frl/ethereum-mining-in-azure/)
2.  [Install NVIDIA GPU drivers on N-series VMs running Linux](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/n-series-driver-setup)