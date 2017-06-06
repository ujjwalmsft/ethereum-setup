// see also: http://solidity.readthedocs.io/en/develop/units-and-global-variables.html

// These variables are parsed by value
// Always copied

pragma solidity 0.4.9;

contract Value {

    // Signed integer
    int var00;
    int var0 = 1;
    // Same as
    int256 var1 = 1;

    // Unsigned integer
    uint var2 = 1;
    // Same as
    uint256 var3 = 1;
    // it is possible to assign the bit in 8 bit steps
    //      8 to 256

    // can't be changed after initialized
    int constant var4 = 4;

    // Casting
    uint128 b;
    int x = int(b),

    bool status;
    bool constant status = true;

    // The value defines the type of the variable
    var a;
    a = "Hallo"; // -> string

    // stores the Ethereum address of 30 bytes
    address public owner;
    address private owner1;

    // up to 32
    byte a;
    bytes2 b;
    bytes20 c;
    bytes m; // -> dynamically sized == byte[] m

    // "" necessary
    string s = "test";

    // static array
    bytes32[5] byteAr;
    // dynamic array -> "unlimited" size
    bytes32[] byteAr1;
    // array operations
    uint lengthOfArrayAfterPush = byteAr1.push("test");


    // Mapping (from any type to any type)
    //  Similar to a hash table
    mapping (string => uint) public balance;
    balance["test"] = 100;


    // enumerations
    enum State {
        Created,
        Locked,
        Inactive
    }
    State public state;
    state = State.Created;

    uint stateValue = uint(state); // = 0 as it is the first value in the enum 


    // Struct
    struct Person {
        uint height;
        uint age;
        address add;
    }

    person public a;
    a.height = 1;
    a.age = 2;
    a.add = 0x123;

    function Value () {

    }
}