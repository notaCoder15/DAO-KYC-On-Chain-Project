//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Subscription{

    event FiSubscriptonBought(address indexed _user , uint32 _timestamp);



    uint public fiSubscription;


    mapping(address => bool) public isFiSubscriber;

    constructor(){

        fiSubscription = 1 ether;
    }



    function becomeFiSub() public payable {
        require(msg.value == fiSubscription , "Not right amount of fee to get Financial Institution Subscription");
        isFiSubscriber[msg.sender] = true;
        emit FiSubscriptonBought(msg.sender, uint32(block.timestamp));
    }

}  