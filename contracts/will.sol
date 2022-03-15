// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Will {

    /************************ Variable ************************/

    address     owner;
    uint        fortune;
    bool        deceased;

    address payable[]           familyWallets; // list of family wallets
    mapping(address => uint)    inheritance; // map through inheritance

    /************************ Constructor ************************/

    constructor() payable {
        owner = msg.sender; // msg sender represents address being called
        fortune = msg.value; //msg value tells us how much ether is being sent  
    }

    /************************ Modifier ************************/

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    modifier mustBeDeceased {
        require(deceased == true);
        _;
    }

    /************************ Function ************************/    

    // set inheritance for each address 
    function payout() private mustBeDeceased {
        for(uint i=0; i<familyWallets.length; i++) {
            familyWallets[i].transfer(inheritance[familyWallets[i]]); // transfer funds from contract address to reciever address
        }
    }

    // oracle switch
    function hasDeceased() public onlyOwner {
        deceased = true;
        payout();
    }
}