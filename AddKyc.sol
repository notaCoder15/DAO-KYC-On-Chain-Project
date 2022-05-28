//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./Subscription.sol";
import "./GovTok.sol";
import "./globalVar.sol";

contract AddKyC is GlobVars ,Subscription , GovernanceToken {
    event KycAdded(uint indexed _id , address indexed adder);
    event KycUpdated(uint indexed _id , address indexed updator , uint numOfUpdates);
    event KycDeleted(uint indexed _id , address indexed adder , uint numberOfDeConf);
    
    constructor(){
        DeConfirmationsAllowed = 5;          // Sets the initial number of deconfirmatons allowed to 5
    }

// Function for Financial Institution to add user Kyc
// User information encoded off chain with user private key is given in argument as a string
// By adding a kyc the institution mints a governance token

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

// function to updateInfo 

    function updateInfo(uint _id , string memory _encodedIdentity1 , string memory _encodedIdentity2) public onlyAllowed {
        require(isPresent[_id] == true , "User not present");
        require(msg.sender == Users[_id].kycadder , "Not the same address");

        bytes memory IdentityInfo1 = abi.encode(_encodedIdentity1);
        bytes memory IdentityInfo2 = abi.encode(_encodedIdentity2);

        Users[_id].identityInfo1 = IdentityInfo1;
        Users[_id].identityInfo2 = IdentityInfo2;
        Users[_id].numOfUpdates += 1;
        

        emit KycUpdated(_id, msg.sender, Users[_id].numOfUpdates);

    }

    // function to remove the kyc when disconfirmed by other financial institutions
    // the function burns the minted token

    function removeInfo(uint _id) public onlyAllowed {
        require(Users[_id].numOfDeConfirmations >= DeConfirmationsAllowed , "Not enough Deconfirmations");
        delete Users[_id];
        _burn(Users[_id].kycadder, 1);
        emit KycDeleted(_id, Users[_id].kycadder, Users[_id].numOfDeConfirmations);
    }

    // function to change the Deletion Confirmations Allowed Value
    // can only be called in Governance contract
    function changeDeletedConfirmationsAllowed(uint newValue) internal {
        DeConfirmationsAllowed = newValue;
    }
}