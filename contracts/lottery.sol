// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Lottery {
    address payable[] public players;
    address public manager;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 0.00001 ether, "The player must send 0.00001 ETH."); // = 10000000000000 wei

        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint) {
        require(msg.sender == manager, "Not Allowed. Manager Only");

        return address(this).balance;
    }

    function random() public view returns(uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickWinner() public {
        require(msg.sender == manager, "Not Allowed. Manager Only");
        require(players.length >= 3, "Not Enough Players Has Joined Yet.");

        uint randomNumber = random(); // Generate random number
        address payable winner;

        uint index = randomNumber % players.length;
        winner = players[index]; // Pick winner

        winner.transfer(getBalance()); // Transfer all ballance of this contract account to the winner

        players = new address payable[](0); // Reset dynamic array with length 0
    }
}