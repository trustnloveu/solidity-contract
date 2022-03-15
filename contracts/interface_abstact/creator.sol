// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Contract {
    address public ownerA;
    
    constructor(address eoa) {
        ownerA = eoa;
    }
}

contract ContractCreator {
    address public ownerCreator;
    Contract[] public deployedContracts;

    constructor() {
        ownerCreator = msg.sender;
    }

    function deployContract() public {
        Contract newContract = new Contract(msg.sender);

        deployedContracts.push(newContract);
    }
}