pragma solidity 0.4.8;

contract Events {

    // inform external entities about activities
    // e.g. for logging

    event EventName (
        // the indexed parameter allows to search for events by the indexed variable
        address indexed addr,
        uint in
    );

    function Events (address addr, uint in) {
        EventName (addr, in);
    }
}