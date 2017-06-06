// see also: http://solidity.readthedocs.io/en/develop/units-and-global-variables.html

pragma solidity 0.4.8;

contract Contract {

    // msg
    // sender of the message
    address owner = msg.sender;
    // Ether send
    uint amount = msg.value;
    // Data like parameters
    bytes data = msg.data;
    // Gas provided
    uint gas = msg.gas;
    // First four bytes of the calldata
    bytes4 sig = msg.sig;

    // tx data
    address send = tx.origin;
    // ...

    // block data
    uint blockNumer = block.number;
    // ...


    // Mathematical and Cryptographic Functions
    //  throws if the condition is not met
    assert(bool condition);
    assert(1 ether == 1000 finney);

    sha3("ab" , "c") == sha3("abc");

    // functions to stop / revert
    //  Abort execution and revert state changes
    revert();


    function Contract () {

    }
}