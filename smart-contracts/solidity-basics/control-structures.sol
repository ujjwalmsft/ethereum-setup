pragma solidity 0.4.8;

contract ControlStructures {

    // Not Available: switch, goto



    function ControlStructures(){
        // if
        if (input == 2){
            // ...
        } 
        else if (input == 2) {
            // ...
        }
        else {
            // ...
        }

        // while
        while (input >= 0) {
            if (input == 1) {
                continue;
            }
            input++;
        }

        // do while
        do {
            input++;
        } while ( input >= 0);

        // for
        for (uint i = 0; i <= 50; i++) {
            break;
        }

        // boolean
        bool isTrue = (a == 1);
        bool isTrue = (a == 1) ? true : false;
    }
}