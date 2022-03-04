// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface BaseContract {
    // int public num;
    // address public owner;

    // constructor() {
    //     num = 5;
    //     owner = msg.sender;
    // }

    function setNum(int _num) external;
}

contract Contract is BaseContract {
    int public num;

    function setNum(int _num) public override {
        num = _num;
    }
}