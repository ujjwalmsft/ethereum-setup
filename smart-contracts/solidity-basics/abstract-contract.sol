pragma solidity 0.4.8;

contract AbstractContract {

    // declare definitions of functions
    //  overwritten during the inheritance
    //  make the interface know to the compiler
    function foo (uint i) returns (uint j);
}

contract NewContract is AbstractContract {
    function foo (uint i) returns (uint j) {
        j = 3 * i;
    }
}