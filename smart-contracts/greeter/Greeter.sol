pragma solidity ^0.4.9;

/** @title Mortal.*/
contract mortal {
    /* Define variable owner of the type address*/
    address owner;

    /**@dev this function is executed at initialization and sets the owner of the contract.
     */
    function mortal() { 
        owner = msg.sender; 
    }

    /**@dev Function to recover the funds on the contract.
     */
    function kill() { 
        if (msg.sender == owner) {
            selfdestruct(owner);
        }
    }
}

/** @title Greeter.*/
contract greeter is mortal {
    /* define variable greeting of the type string */
    string greeting;

    /**@dev This function runs when the contract is executed.
     * @param _greeting Greeting message.
     */
    function greeter(string _greeting) public {
        greeting = _greeting;
    }

    /* main function */
    /**@dev This function returns the greeting message.
     * @return greeting The greeting message.
     */
    function greet() constant returns (string) {
        return greeting;
    }
}