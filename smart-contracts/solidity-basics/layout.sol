// Define which compiler to use
// Will only work with compilers >= the given version
pragma solidity 0.4.9;

// Will only work version >= the given version and < the next major release (e.g. 0.5.0)
// pragma solidity ^0.4.9;

// Import other contracts
import "coin";

// Contract section
contract ContractName {
    // Documentation of a contract
    /*
    * @title title
    * @author author
    * @notice notes
    * @dev notesForDevs
    */

    // single line comment

    /*
    Multiline comment
    */

    // State variables -> define the state of a Smart Contract
    // Can be theoretically anywhere
    address public stateVar1;
    uint public stateVar2;
    uint private stateVar3;
    string public constant HOST_ID = 0x1234;

    // Events
    // Log values in an interface, also used for debugging
    event Event1 (address param1, uint param2);
    event Event2 (address param1);
    event Event3 ();

    // Function modifiers
    // Used for restricting use of functions
    modifier onlyIfOwnerModifier() {
        if (msg.sender != owner) {
            throw;
        };
        _;
    }

    // Struct, array, enum
    enum enum1 {val1, val2, val3};
    struct struct1 {
        uint var1,
        uint var2,
        address addr
    };
    mapping (address => uint) balances;

    // Constructor
    // Called when the Contract is initialized
    function ContractName (uint param1) {
        // ...
    }

    // Function

    /**@dev ...
     * @param var1 ...
     * @return ret1 ...
     */
    function functionName (uint param1) {
        // ...
    }

    // Default function
    // Function that is executed if there is not function that matches the name of the function called
    function () {
        // ...
    }
}
