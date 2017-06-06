pragma solidity 0.4.9;

contract Contract {

    // Ether units
    //  avaialable units: wei, finney, szabo, ether
    //      can't be used as var nams
    bool isEqual = (2 ether == 2000 finney);
    uint 2kwei = 2000 wei;

    // Time units
    //  Time: second, minutes, hours, days, weeks, years
    //      can't be used as var nams
    bool isEqual = (1 == 1 seconds);
    bool isEqual = (1 minutes == 60 seconds);

    uint timestamp = now;

    function Contract () {

    }
}