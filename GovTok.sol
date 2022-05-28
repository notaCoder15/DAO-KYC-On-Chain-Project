// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GovernanceToken is ERC20 {
    constructor() ERC20("Governance Token", "KyCdao") {}
    // Makes an ERC20 governance token
    // Initial value is 0
    // Users can mint the tokens by adding User kYC's
}

