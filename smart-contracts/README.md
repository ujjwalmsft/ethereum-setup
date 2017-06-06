# Get started with Smart Contracts

## Extensions
*   Visual Studio Code
    *   [solidity](https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity)
*   Visual Studio 2015
    *   [Solidity](https://marketplace.visualstudio.com/items?itemName=ConsenSys.Solidity)
*   Atom
    *   `language-ethereum`
    *   `autocomplete-solidity`


## Deploy a Smart Contract
### Via Command Line
*   Install the compiler on Ubuntu
```
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get update
sudo apt-get install solc
which solc
```
*   Check if the compiler is available
    *   `eth.getCompilers()`
*   Compile the contract
```
var contractCode = 'contract ...';
var compiledCode = web3.eth.compile.solidity(contractCode);

var _initVariable = ...;

var contract = web3.eth.contract(compiledCode.contractName.info.abiDefinition);
var contractDeployment = contract.new(_initVariable,{from:web3.eth.accounts[0], data: compiledCode.contractName.code, gas: 1000000}, function(e, contract){
  if(!e) {

    if(!contract.address) {
      console.log("Contract transaction send: TransactionHash: " + contract.transactionHash + " waiting to be mined...");

    } else {
      console.log("Contract mined! Address: " + contract.address);
      console.log(contract);
    }

  }
})
```
*   Copy and store the address and the ABI of the contract!

### Online Compiler and then command line
*   Go to [Ethereum Online Compiler](https://remix.ethereum.org/#version=soljson-v0.4.11+commit.68ef5810.js)
*   Paste the code of the contract
*   Click on `Contract details`
*   Copy the code in `Web3 deploy`
*   Enter a value for inital variables
*   Connect to a transaction node
*   Unlock the account specified -> `personal.unlockAccount(eth.accounts[0])`
*   Paste the code and run it
*   Copy and store the address and the ABI of the contract!

### Via tools like Mist
*   Important: Increase maximum fee to be provided (e.g. x 10). The provided amount is usually not enough.


## Run functions via command line
### Get the contract
*   You need
    *   The address of the contract
    *   The ABI (Application Binary Interface)
*   Then
    *   `var address = 0x...;`
    *   `var abi = [{...`
    *   `var contract = eth.contract(abi).at(address);`

### Run functions
...
