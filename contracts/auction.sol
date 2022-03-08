// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;


contract AuctionCreator {
    Auction[] public auctions;

    function createAuction() public {
        Auction newAuction = new Auction(msg.sender);
        auctions.push(newAuction);
    }
}


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


    constructor(address eoa) {
        owner = payable(eoa);
        auctionState = State.Running;
        startBlock = block.number;
        endBlock = startBlock + 3; // = a week, block is created in every 15 seconds
        ipfsHash = "";
        bidIncrement = 1000000000000000000; // = 1 ether
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

    modifier onlyOwner() {
        require(msg.sender == owner, "Not Allowed. Owner Only");
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
        require(msg.value >= 100, "You have to transfer more then 100.");

        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestBindingBid, "You didn't meet proper auction bid.");

        bids[msg.sender] = currentBid;
        
        if (currentBid <= bids[highestBidder]) {
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        }
        else {
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }
    }

    function cancelAuction() public onlyOwner {
        auctionState = State.Canceled;        
    }

    function finalizeAuction() public {
        require(auctionState == State.Canceled || block.number > endBlock, "Auction has been ended.");
        require(msg.sender == owner || bids[msg.sender] > 0, "Member Only.");

        address payable recipient;
        uint value;

        // When the auction was canceled
        if (auctionState == State.Canceled) {
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        }
        // When the auction ended (Not canceled)
        else {
            // Owner
            if (msg.sender == owner) {
                recipient = owner;
                value = highestBindingBid;
            }
            // Bidder
            else {
                if (msg.sender == highestBidder) {
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingBid;
                }
                else {
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
            }
        }

        // Reset
        bids[recipient] = 0;

        // Transfer ETH
        recipient.transfer(value);
    }
}