pragma solidity 0.4.8;

contract BaseClass {
    // all function calls are virtual
    // most recent function will be called except you specify the concrete contract with the specific function definition
    // it is only one contract created on the contract even if this contract inherits from other contracts
    // the code from the base contract is copied in the final contract
    // multiple inheritance possible
    
    address owner;

    function BaseClass () {
        owner = msg.sender;
    }
}

contract Inherited is BaseClass {
    // all variables and functions from BaseClass will be available in the inherited contract

    function kill() {
        selfdestruct(owner);
    }
}

// the order is important -> Inherited overwrites BaseClass
// Diamond Problem -> if it is the other way around ->
//  i.e. InheritedMultiple with Inherited, BaseClass ->
//  That is Inherited would be overwritten by BaseClass but Inherited also inherits from BaseClass
//      -> not resolvable -> Compiler Error (Serialization not possible)
//  -> provide the correct order
//  -> it is also recommended to create the contracts in the right order from Base to most recent
contract InheritedMultiple is BaseClass, Inherited {
    string public userName;

    function InheritedMultiple (string _name) {
        userName = _name;
    }
}