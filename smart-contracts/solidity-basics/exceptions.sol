pragma solidity 0.4.8;

contract Exceptions {
    // Exception -> the transaction is stopped and reverted completely
    // All changes to the state and balances is undone
    // Catching the exception is not yet possible -> will be added

    function sendHalf (address addr) payable returns (uint balance) {
        // Option 1
        if (!addr.send(msg.value/2)){
            throw;
        }
        // Option 2 (= 1)
        assert(addr.send(msg.value/2))
        
        return this.balance;
    }
}