# Listing of relevant commands

## Account Handling
*   List accounts on the node: 
    *   `eth.accounts`
    *   `eth.accounts[0]`
*   Create account on node: 
    *   `personal.newAccount("passphrase")`
*   Show balance of an account
    *   `eth.getBalance(eth.accounts[0])`

## Transaction Handling
*   Unlock the account
    *   `personal.unlockAccount(eth.accounts[0])`
*   Make the transaction
    *   `eth.sendTransaction({from: eth.accounts[0], to: 'addressTX0Account', value: web3.toWei(5, "ether")})`

## Make a test transaction
*  Go to MN0 and unlock the account to able to transfer ether
    *   `personal.unlockAccount(eth.accounts[0])`
    *  Transfer ether to the account at TX0
        *   `eth.sendTransaction({from: eth.accounts[0], to: 'addressTX0Account', value: web3.toWei(5, "ether")})`
