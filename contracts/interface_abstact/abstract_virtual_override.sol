// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

abstract contract BaseContract {
    int public num;
    address public owner;

    constructor() {
        num = 5;
        owner = msg.sender;
    }

    // function setNum(int _num) public {
    //     num = _num;
    // }

    function setNum(int _num) public virtual;
}

contract Contract is BaseContract {

    function setNum(int _num) public override {
        num = _num;
    }
}