//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AddKyc.sol";

contract CheckKyc is AddKyC {

    // functions that checks wheather a user's KYC has been completed or not
    function isUserPresent(uint _id) public view returns(bool){
        return isPresent[_id];
    }

    // function to retrive on chain information about the user
    // function returns encoded string that can be decoded using user's private key

    function getInfo(uint _id) public view onlyAllowed returns (uint id , string memory info1 , string memory info2 , address adder , uint numOfconf){
        id = _id;
        info1 = abi.decode(Users[_id].identityInfo1 , (string));
        info2 = abi.decode(Users[_id].identityInfo2 , (string));
        adder = Users[_id].kycadder;
        numOfconf = Users[_id].numOfConfirmations;
    }

    // Function for other Financial Institutions to confirm wheather the Kyc performed was correct or wrong

    function confirm(uint _id , bool _valid) public onlyAllowed {
        require(Confirmed[_id][msg.sender] ==  false , "vote already given");
        if(_valid){
            Users[_id].numOfConfirmations += 1;
        }else{
            Users[_id].numOfDeConfirmations += 1;
        }

        Confirmed[_id][msg.sender] == true;
    }


}
