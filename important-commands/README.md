# Listing of basic commands


## Ethereum related

### Check connectivity
*   Check if the node is listening [1]
    *   `net.listening`
*   Show number of peers [1]
    *   `net.PeerCount`
*   Get more information about connected peers [1]
    *   `admin.peers`

### Account Handling
*   List accounts on the node: 
    *   `eth.accounts`
    *   `eth.accounts[0]`
*   Create account on node: 
    *   `personal.newAccount("passphrase")`
*   Show balance of an account
    *   `eth.getBalance(eth.accounts[0])`

### Transaction Handling
*   Unlock the account
    *   `personal.unlockAccount(eth.accounts[0])`
*   Make the transaction
    *   `eth.sendTransaction({from: eth.accounts[0], to: 'addressTX0Account', value: web3.toWei(5, "ether")})`
*   Check transaction
    *   `eth.getTransaction('txHash')`
    *   `eth.getTransactionReceipt('txHash')`

### Contract handling
*   See binary code of a deployed contract
    *   `eth.getCode(contractName.address)`

### Mist
*   Connect to a running local node 
    *   `mist.exe --rpc \\.\pipe\geth.ipc`
*   Connect to a remote node via RPC
    *   `mist --rpc <rpc endpoint>`


## Linux related

### Display the output of a process running in the background on a Linux machine
*   See the running processes
    *   `ps -aux`
*   Get the pid of the process
*   See the output via `tail -f /proc/<pid>/fd/1`

### List, install and remove packages
*   List installed packages
    *   `apt list --installed`
*   Install package
    *   `sudo apt-get install`
*   Uninstall package
    *   `sudo apt-get purge`

### Delete files and directories
*   Delete a folder recursively
    *   `rm -rf <directoryPath>`


# Sources
1.  [Connecting to the network](https://github.com/ethereum/go-ethereum/wiki/Connecting-to-the-network)