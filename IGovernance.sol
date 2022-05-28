//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

// Interface for the governance contrct

interface IGovernance {

    function subFeePraposal(uint newFeeAmount , uint newDeConfAmount) external;
    function Change() external;


    event Praposalsubmitted(uint newFeeAmount , uint newDeConfAmount , uint timeStamp );
    event ValuesChanged(uint newValue1 , uint newValue2);
}