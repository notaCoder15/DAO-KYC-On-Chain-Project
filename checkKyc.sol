//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./AddKyc.sol";

contract CheckKyc is AddKyC {

    function isUserPresent(uint _id) public view returns(bool){
        return isPresent[_id];
    }

    function getInfo(uint _id) public view onlyAllowed returns (uint id , string memory info1 , string memory info2 , address adder , uint numOfconf){
        id = _id;
        info1 = abi.decode(Users[_id].identityInfo1 , (string));
        info2 = abi.decode(Users[_id].identityInfo2 , (string));
        adder = Users[_id].kycadder;
        numOfconf = Users[_id].numOfConfirmations;
    }

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