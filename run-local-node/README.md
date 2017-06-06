# Run a local Ethereum node

## Run a local node only on the client

## Run a local node connected to the public network

## Run a local node connected to the test network


## Run a local node connected to a custom public network in Azure



## Run a local node connected to a template-based private network in Azure

## Conntect to the local node
*   Via command line
    *   `geth attach ipc:///home/.../.ethereum-data/geth.ipc`
*   Via Mist
    *   Get and install Mist (version 0.8.10 does not seem to work properly, therefore use 0.8.9) [1]
    *   Run Mist while connected to the local node and therefore with the consortium
        *   Connect ot the Blockchain instance via `mist.exe --rpc \\.\pipe\geth.ipc` [2]
        *   Create a new account via Mist
        *   Send Ether to the new account via the admin page
    *   Install Visual Studio and in there the Solidity extension

## Sources
1.  [Mist Browser](https://github.com/ethereum/mist/blob/develop/README.md)
2.  [Mist Download Page](https://github.com/ethereum/mist/releases)