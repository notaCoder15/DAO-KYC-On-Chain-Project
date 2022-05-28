//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./IGovernance.sol";
import "./GovTok.sol";
import "./globalVar.sol";

// Voting Contract


contract voting is GovernanceToken , GlobVars{

    uint totalSupply;
    uint newValue1;
    uint newValue2;
    uint deadline;

    mapping (address => bool) isVoteCasted;
    uint forThePraposal;

    IGovernance Governance;

    function setup(uint amount1, uint amount2 , uint _totalSupply) public {
        require(address(Governance) == address(0) , "Setup already done");
        Governance = IGovernance(msg.sender);
        totalSupply = _totalSupply;
        newValue1 = amount1;
        newValue2 = amount2;
        deadline = block.timestamp + 1 days;
    }

    function castVote(bool vote) public onlyAllowed {
        require(isVoteCasted[msg.sender] == false , "Vote already casted");
        require(block.timestamp < deadline , "Deadline Passed");
        uint power = balanceOf(msg.sender);
        if(vote){
            forThePraposal += power;
        }
        isVoteCasted[msg.sender] = true;
    }

    function result() public view returns(uint,uint , bool){
        require(block.timestamp > deadline, "Voting still going on");
        uint percent = (forThePraposal/totalSupply)*100;
        if(percent >= 50){
            return (newValue1, newValue2 ,true);
        }else{
            return (newValue1 , newValue2 , false);
        }
    }

}