//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Subscription.sol";
import "./GovTok.sol";

contract AddKyC is Subscription , GovernanceToken {
    event KycAdded(uint indexed _id , address indexed adder);
    event KycUpdated(uint indexed _id , address indexed updator , uint numOfUpdates);
    
    struct info{
        bytes identityInfo1;
        bytes identityInfo2;
        
        uint numOfUpdates;

        uint numOfConfirmations;
        uint numOfDeConfirmations;
        address kycadder;
    }

    mapping (uint => info) internal Users;
    mapping (uint => bool) internal isPresent;
    mapping (uint => mapping(address => bool)) Confirmed;

    modifier onlyAllowed(){
        require(isFiSubscriber[msg.sender] == true);
        _;
    }

    function addUser(uint _id , string memory _encodedIdentity1 , string memory _encodedIdentity2 ) public onlyAllowed {
        require(isPresent[_id] == false , "User already present");
        
        bytes memory IdentityInfo1 = abi.encode(_encodedIdentity1);
        bytes memory IdentityInfo2 = abi.encode(_encodedIdentity2);

        info memory Info ;
        Info.identityInfo1 = IdentityInfo1;
        Info.identityInfo2 = IdentityInfo2;
        Info.kycadder = msg.sender;
        
        Users[_id] = Info;
        isPresent[_id] = true;

        _mint(msg.sender, 1);
        emit KycAdded(_id, msg.sender);
    }

    function updateInfo(uint _id , string memory _encodedIdentity1 , string memory _encodedIdentity2) public onlyAllowed {
        require(isPresent[_id] == true , "User not present");

        bytes memory IdentityInfo1 = abi.encode(_encodedIdentity1);
        bytes memory IdentityInfo2 = abi.encode(_encodedIdentity2);

        Users[_id].identityInfo1 = IdentityInfo1;
        Users[_id].identityInfo2 = IdentityInfo2;
        Users[_id].numOfUpdates += 1;

        emit KycUpdated(_id, msg.sender, Users[_id].numOfUpdates);

    }

}