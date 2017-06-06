pragma solidity 0.4.8;

contract Scoping {

    // variable created -> zero state of the related type;
    // global variables are available in the whole contract;
    uint i; // == 0

    // in static arrays each element is initialized to the zero value;
    // in dynamic arrays -> empty array / string

    function Scoping () {
        // variables created in a function are available all over in the function (that is in every code block) 
        // but not outside the function
        uint same1= 0;
    }
}