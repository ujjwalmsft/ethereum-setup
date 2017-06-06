pragma solidity 0.4.8;

contract Parameters {

    uint public input1;
    uint public input2;

    function Parameters (uint in1, uint in2) {
        input1 = in1;
        input2 = in2;
    }

    function multiplyByThree (uint in1) returns (uint m3) {
        // no return necessary, the assignment is enough
        m3 = 3 * in1;
    }

    function multiplyByThreeWithReturn (uint in1) returns (uint) {
        m3 = 3 * in1;
        // return type must be uint in this case
        return m3;
    }

    // it is possible to return more than one value
    function multiplyByThreeMultipleReturns (uint in1) returns (uint s, uint m) {
        s = 3 * in1;
        m = 3 * in1;
    }

    function multiplyAndSumMultipleReturns (uint in1, uint in2) returns (uint, uint) {
        s = in1 + in2;
        m = in1 * in2;
        return (s, m);
    }

}