//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./IGovernance.sol";
import "./GovTok.sol";
import "./globalVar.sol";

// Voting Contract
// New contract for new praposal

contract voting is GovernanceToken , GlobVars{

    uint totalsupply;                       // max number of votes
    uint newValue1;                         // new value of Subscription Fee
    uint newValue2;                         // new value of deconfirmations required
    uint deadline;                          // deadline timestamp for voting (origin + 1 day)

    mapping (address => bool) isVoteCasted;  // check if the subscriber has casted vote of not
    uint forThePraposal;                     // total number of votes in favor of the praposals

    IGovernance governance;                 

// function to setup the contract . Called while initializing the contract in Governance . Can be called only once.
    function setup(uint amount1, uint amount2 , uint _totalSupply) public {
        require(address(governance) == address(0) , "Setup already done");
        governance = IGovernance(msg.sender);
        totalsupply = _totalSupply;
        newValue1 = amount1;
        newValue2 = amount2;
        deadline = block.timestamp + 1 days;
    }
// function to cast vote
// used before deadline is over
    function castVote(bool vote) public onlyAllowed {
        require(isVoteCasted[msg.sender] == false , "Vote already casted");
        require(block.timestamp < deadline , "Deadline Passed");
        uint power = balanceOf(msg.sender);
        if(vote){
            forThePraposal += power;
        }
        isVoteCasted[msg.sender] = true;
    }
    // function to get the result of the voting
    // can be called after deadline is over
    function result() public view returns(uint,uint , bool){
        require(block.timestamp > deadline, "Voting still going on");
        uint percent = (forThePraposal/totalsupply)*100;
        if(percent >= 50){
            return (newValue1, newValue2 ,true);
        }else{
            return (newValue1 , newValue2 , false);
        }
    }

}
