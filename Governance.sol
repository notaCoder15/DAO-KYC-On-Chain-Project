//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "./GovTok.sol";
import "./globalVar.sol";
import "./Voting.sol";
import "./Subscription.sol";
import "./AddKyc.sol";

// Governance contract to change the deployed global variable parameters.
// This does not add new features or listen for praposals.
// That can be done off chain with voting rights accoriding to number of tokens
// To Do it on chain openZepplins Governance contract is used in another branch of the project

contract Governance is  GlobVars , AddKyC {
    // state variables that can change -- SubscriptionFee , DeConfirmationsAllowed
    event Praposalsubmitted(uint newFeeAmount , uint newDeConfAmount , uint timeStamp );
    event ValuesChanged(uint newValue1 , uint newValue2);

    uint totalVotes = totalSupply();
    bool praposalActive;                // to check if praposal is active or not . One praposal at a time.

    voting Voting;                      // Initiating a variable Voting of type voting contarct.
                                        // For every praposal a voting contract gets created with time of 1 day for voters to vote
                                        // Users can vote by calling in the casre vote function of the contract whose address is output of Praposal function



//function to sublit a praposal
// creates a new contract for voting
// only be called again after results are out
    function Praposal(uint newFeeAmount , uint newDeConfAmount) public onlyAllowed returns(address) {
        require(praposalActive == false , "Praposal already active");
        praposalActive = true;
        Voting = new voting();
        Voting.setup(newFeeAmount, newDeConfAmount , totalVotes);
        emit Praposalsubmitted(newFeeAmount, newDeConfAmount, block.timestamp);
        return address(Voting);
    }

// function to directly vote in the Voting contract using delegate call so msg.sender remains same
    function castevote(bool vote) public onlyAllowed returns(bool){
        require(praposalActive == true , "No praposals active");
        (bool success , bytes memory data)=address(Voting).delegatecall(abi.encodeWithSignature("castVote(bool vote)", vote));
        return success;
    }

// fucntion to get results of voting
// can be called only after one day;
// if reult > 50 % changes are made to the state variables
    function Change() public onlyAllowed{
        require(praposalActive == true , "No praposals active");
        uint newValue1;
        uint newValue2;
        bool result;
        (newValue1 , newValue2 , result) = Voting.result();
        if(result){
            changeSubscriptionFee(newValue1);
            changeDeletedConfirmationsAllowed(newValue2);
            emit ValuesChanged(newValue1, newValue2);
            praposalActive = false;
        }else{
            praposalActive = false;
        }
    }

}