// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Auction {
    address payable public owner;
    uint public startBlock;
    uint public endBlock;
    string public ipfsHash; // IFS, IPFS

    enum State { Started, Running, Ended, Canceled }
    State public auctionState;

    uint public highestBindingBid;
    address payable public highestBidder;

    mapping(address => uint) public bids;

    uint bidIncrement;


    constructor() {
        owner = payable(msg.sender);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock + 40320; // = a week, block is created in every 15 seconds
        ipfsHash = "";
        bidIncrement = 100;
    }


    modifier notOwner() {
        require(owner != msg.sender, "Not Allowed. Owner can't join in this auction.");
        _;
    }

    modifier afterStart() {
        require(block.number >= startBlock, "You can't participate in this auction yet.");
        _;
    }

    modifier beforeEnd() {
        require(block.number <= endBlock, "The Auction is ended. You can't participate in.");
        _;
    }


    function min(uint a, uint b) pure internal returns (uint) {
        if (a <= b) {
            return a;
        }
        else {
            return b;
        }
    }

    function placeBid() public payable notOwner afterStart beforeEnd {
        require(auctionState == State.Running, "Auction is not open.");
        require(msg.value >= 100, "You have to transfer ");

        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestBindingBid);

        bids[msg.sender] = currentBid;
        
        if (currentBid <= bids[highestBidder]) {
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        }
        else {
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }
    }
}