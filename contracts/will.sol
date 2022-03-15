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
        deceased = false;
    }

    // receive() external payable {}

    // fallback() external payable {}

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

    // 상속 리스트 설정(상속자 - 상속금)
    function setInheritance(address payable wallet, uint amount) public onlyOwner {
        familyWallets.push(wallet);
        inheritance[wallet] = amount;
    }

    // 상속 멤버 수
    function checkFamilyWalletLength() public view returns(uint) {
        return familyWallets.length;
    }

    // 지급
    function payout() private mustBeDeceased {
        for(uint i=0; i<familyWallets.length; i++) {
            familyWallets[i].transfer(inheritance[familyWallets[i]]); // transfer funds from contract address to reciever address
        }
    }

    // Trigger
    function hasDeceased() public onlyOwner {
        deceased = true;
        payout();
    }
}