# Run a local Ethereum node

## Run a local node only on the client


## Run a local node connected to the public network


## Run a local node connected to the test network


## Run a local node connected to a custom public network in Azure
*   Create a custom public Blockchain instance              
*   Get a local node running [3]
    *   Download Geth [4]
    *   Create a folder (e.g. `geth`)
    *   Create the `genesis.json` file in the folder created
        *   Get the content of the file from the `genesis.json` file on a TX node
    *   Initialize geth via `geth --datadir pathToGethFolder\geth\data init pathToGethFolder\geth\genesis.json`
    *   Create the `static-nodes.json` file under `geth\data` to obtain bootnodes
        *   Go to an existing transaction node
            *   Run `geth attach` -> `admin.nodeInfo` -> copy the value of `enode` and replace `[::]` with the public IP address of the TX node
        *   Create `static-nodes.json` file under `geth\data`
        *   Input the enode information
    *   Start geth
        *   `geth --datadir pathToGethFolder\data --networkid {network id}`
    *   Open a second command line window and test
        *   Via `geth attach`
        *   It can take a few minutes

## Run a local node connected to a template-based private network in Azure
*   Create a private Blockchain instance
    *   Check out the admin page
    *   Connect to the first node via SSH
        *   Start console via `geth attach`
        *   Connect to a Miner node
            *   `ssh privateIPOfMiner` (to get via the NIC)
            *   Inspect the mining process                
*   Get a local node running [3]
    *   Download Geth [4]
    *   Create a folder (e.g. `geth`)
    *   Create the `genesis.json` file in the folder created
        *   Get the content of the file from the `genesis.json` file on a TX node
    *   Initialize geth via `geth --datadir pathToGethFolder\geth\data init pathToGethFolder\geth\genesis.json`
    *   Create the `static-nodes.json` file under `geth\data` to obtain bootnodes
        *   Go to an existing transaction node
            *   Run `geth attach` -> `admin.nodeInfo` -> copy the value of `enode` and replace `[::]` with the public IP address of the TX node
        *   Create `static-nodes.json` file under `geth\data`
        *   Input the enode information
    *   To be able to connect it is necessary to open a path to connect to the private network (temporarily -> that way the private network is not really private anymore)
        *   Port forwarding on the load balancer to the TX node (especially if there is more than on TX node in the network)
            *   30303 TCP & UDP
        *   Open ports on the NSG of the TX node (the NSG is attached to the subnet of TX0)
            *   Inbound & Outbound: 30303 TCP & UDP
    *   Start geth
        *   `geth --datadir pathToGethFolder\data --networkid {network id}`
    *   Open a second command line window and test
        *   Via `geth attach`
        *   It can take a few minutes

## Connect to a running local node of a private / custom public network
*   Via command line
    *   `geth attach ipc:///home/.../.dataFolderName/geth.ipc`
*   Via Mist
    *   Get and install Mist (version 0.8.10 does not seem to work properly, therefore use 0.8.9) [1]
    *   Run Mist while connected to the local node and therefore with the consortium
        *   Connect to the Blockchain instance via `mist.exe --rpc \\.\pipe\geth.ipc` [2]

## Sources
1.  [Mist Browser](https://github.com/ethereum/mist/blob/develop/README.md)
2.  [Mist Download Page](https://github.com/ethereum/mist/releases)
3.  [Connect a local geth node](https://github.com/EthereumEx/ethereum-arm-templates/blob/master/ethereum-consortium/docs/setupWalkthrough.md)
4.  [Download Geth](https://geth.ethereum.org/downloads/)