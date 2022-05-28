// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract GlobVars {
    
    // Subscription Global Variables

    uint public SubscriptionFee;                                   // Subscription Fee
    mapping(address => bool) public isSubscriber;               // Mapping wheather a address is a subscriber or not

    /* A User subscription is not yet been implemented . So technically all the accounts that will be allowed to access 
       the contracts on the private blockchain network will be subscribers. So this mapping has no use right now .
       but it can be useful in case a user subscription is to be implemented */


    /*    User subscriptiom
    The concept is that the chain can also act as cryptographically secured decentralized storage of user documents(proof of identity and other proofs)
    A service can be started where users can pay small subscription fee to enter the network and can access these documents 
    from anywhere using a private key.  
    */ 

    modifier onlyAllowed(){
        require(isSubscriber[msg.sender] == true , "not a subscriber");
        _;
    }


// KYC global variables

    // User information Struct

    struct info{
        bytes identityInfo1;               // information1
        bytes identityInfo2;               // information2
        
        uint numOfUpdates;                 // number of updates to the kyc

        uint numOfConfirmations;           // number of Financial institutions that confirmed the KYC
        uint numOfDeConfirmations;         // number of Financial institutions that deconfirmed the KYC
        address kycadder;                  // address of Financial institution that added the kyc
    }


/*   DeConfirmations Allowed for kyc to be regarded
 */
    uint internal DeConfirmationsAllowed;

    mapping (uint => info) internal Users;              // mapping of users id number (aadhar number -India) to their info
    mapping (uint => bool) internal isPresent;          // mappping if a user kyc is done
    mapping (uint => mapping(address => bool)) Confirmed; // mapping for other financial institutions to confirm of discondirm the kyc



}