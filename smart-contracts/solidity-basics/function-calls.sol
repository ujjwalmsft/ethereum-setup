pragma solidity 0.4.8;

contract FunctionCall {

    // create the contract
    Miner m;

    // constructor is automatically called when the contract gets created
    function FunctionCall () {
        // Definiton of state variables
    }

    function setMiner (address addr) {
        // casted address to a Miner address of the Miner contract stored in m
        m = Miner(addr);
    }

    function callMinerInfo () {
        // send 10 ether to the contract
        m.info.value(10).gas(800)();
    }

    function someFunction (uint key, uint value) {
        // ...
    }

    function demoFunction() {
        someFunction ({
            value: 3,
            key: "me"
        });
    }
}

contract Miner {

    // The modifier payable allows sending ether to the contract
    function info () payable return (uint ret) {
        return 42;
    }
}