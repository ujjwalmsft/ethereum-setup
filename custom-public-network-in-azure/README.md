# Create a custom public Ethereum Blockchain network in Azure

## Run `deploymentScript.ps1`
*   This will create a two node network
## Miner Node !! It is necessary to add at least two miners -> execute the setup on each miner !!
*  Install Ethereum / Geth on each machine
    *  Instructions to install Ethereum / Geth: [Install Instructions](https://github.com/ethereum/go-ethereum/wiki/Installation-Instructions-for-Ubuntu)
        *   This will create a full node that is not mining by default.
*  Create a custom data directory in the home folder
    *  `ethereum-data`
*  Create the genesis block in the `ethereum-data` folder
    *   Create genesis.json with the following input (that can be adjusted if needed) and save it somewhere on the node
        *   See also [Genesis Block](http://ethdocs.org/en/latest/network/test-networks.html#the-genesis-file)

```
{
    "nonce": "0x0000000000000042",     
    "timestamp": "0x0",
    "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "extraData": "0x0",     
    "gasLimit": "0x8000000",     
    "difficulty": "0x2800",
    "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "coinbase": "0x3333333333333333333333333333333333333333",     
    "alloc": {     }
}
```

*  Initialize the genesis block and thereby launch the new blockchain
    *   `geth --identity "ethereum-network" --rpc --rpcport "8545" --rpccorsdomain "*" --datadir "/home/.../ethereum-data" --port "30303" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999 init /home/.../ethereum-data/genesis.json`
        *   See also [Flag Description](http://ethdocs.org/en/latest/network/test-networks.html#command-line-parameters-for-private-network)
*  To start the node and related console run   
    *   `geth --identity "ethereum-network" --rpc --rpcport "8545" --rpccorsdomain "*" --datadir "/home/.../ethereum-data" --port "30303" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999 console`
*  Create an account to allocate the ether produced by the mining process
    *  Console: `personal.newAccount()`
*  Start mining
    *   Set the coinbase, then close the console
        *   `miner.setEtherbase(personal.listAccounts[0])`
    *   Open a new session (or use nohup)
        *   `screen -S miningNode`
    *   To start mining in the session run below and then detach
        *   `geth --identity "ethereum-network" --rpc --rpcport "8545" --rpccorsdomain "*" --datadir "/home/.../ethereum-data" --port "30303" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999 --mine`
            *   `nohup geth --identity "ethereum-network" --rpc --rpcport "8545" --rpccorsdomain "*" --datadir "/home/.../ethereum-data" --port "30303" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999 --mine &`

## Transaction node
*  Install Ethereum / Geth on each machine
    *  Instructions to install Ethereum / Geth: [Install Instructions](https://github.com/ethereum/go-ethereum/wiki/Installation-Instructions-for-Ubuntu)
*  Create a custom data directory in the home folder
    *  `ethereum-data`
* Create the same genesis block in the `ethereum-data` folder as above
* Initialize the Blockchain
    *  `geth --identity "ethereum-network" --rpc --rpcport "8545" --rpccorsdomain "*" --datadir "/home/.../ethereum-data" --port "30303" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999 init /home/.../ethereum-data/genesis.json`
*  Open a new session (or use nohup)
    *   `screen -S transcationNode`
*  To start the node in the session run below and then detach
    *   `geth --identity "ethereum-network" --rpc --rpcport "8545" --rpccorsdomain "*" --datadir "/home/.../ethereum-data" --port "30303" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999`
        *   `nohup geth --identity "ethereum-network" --rpc --rpcport "8545" --rpccorsdomain "*" --datadir "/home/.../ethereum-data" --port "30303" --nodiscover --rpcapi "db,eth,net,web3" --networkid 1999 &`
*  Connect to the node
    *   `geth attach ipc:///home/.../.ethereum-data/geth.ipc`
*  Create an account
    *  Console: `personal.newAccount()`

## Connect the nodes (the number of node to connect to must be >= 1)
*  Get the node information of all existing nodes
    *   Go to each node, open the console and run
        *   `admin.nodeInfo.enode`
    *   Note them and in this context replace [::] with the public IP address of the node
*  Create `static-nodes.json` in the in the data folder
    *   Content

```
[
    "enode..."
]
```

*  Go to the detached session and restart the geth process
*  Check if added
    *   `admin.peers`