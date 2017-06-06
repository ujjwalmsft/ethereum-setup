pragma solidity 0.4.8;

// a contract can create a new contract with the "new" keyword
// the contract has to be defined separately
// recursive creation is not possible

contract D {

    uint x;

    function D (uint a) payable {
        x = a;
    }
}

contract C {
    D d = new D(4);

    function createD (uint arg) {
        D newD = new D(arg);
        D newD2 = (new D).value(amountEther)(arg)
    }
}