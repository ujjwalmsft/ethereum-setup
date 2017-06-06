pragma solidity 0.4.8;

contract FallBack {

    function FallBack () {

    }

    // default function that is called when the function called from outside does not exist
    function () {
        throw;
    }

}