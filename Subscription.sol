//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./globalVar.sol";

/* This contract is chaincoded into the private network . Users must buy the subscription 
    to enter the network and use the kyc chain*/

contract Subscription is GlobVars{

    event SubscriptonBought(address indexed _user , uint32 _timestamp);
    event FeeChanged(uint indexed newVal);

    constructor(){
        SubscriptionFee = 1 ether;        // Sets the initial subscription fee to 1 ether . Can be changed via Governance protocol.
    }



    // Function to become a subscriber to use the chain and contribute to it.
    function becomeSub() public payable {
        require(msg.value == SubscriptionFee , "Not right amount of fee to get Financial Institution Subscription");
        require(isSubscriber[msg.sender] == false , "already subscribed");

        isSubscriber[msg.sender] = true;
        emit SubscriptonBought(msg.sender, uint32(block.timestamp));
    }

    // function to change subscription fee
    // can only be called in governance contract
    function changeSubscriptionFee(uint newVal) internal {
        SubscriptionFee = newVal;
        emit FeeChanged(newVal);
    }
}  