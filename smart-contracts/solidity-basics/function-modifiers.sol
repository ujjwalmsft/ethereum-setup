pragma solidity 0.4.8;

contract FunctionModifiers {
    // used to change the behavior of functions -> inherited by the contracts, can be overwritten
    //  e.g. check conditions before executing a function
    //      this can be done even before the function calls -> reject function call before executed (e.g. save gas)
    address public creator;
    
    function FunctionModifiers () {
        creator = msg.sender;
    }

    modifier onlyCreator () {
        if (msg.sender != creator) {
            throw;
        }
        _;
    }

    function killContract () onlyCreator {
        // creator receives all the ether available in the Smart Contract
        selfdestruct(creator);
    }
}