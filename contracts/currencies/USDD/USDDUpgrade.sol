pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT
// Source code: https://github.com/DeCash-Official/smart-contracts

import "../../contract/DeCashUpgrade.sol";

contract USDDUpgrade is DeCashUpgrade {
    constructor(address _storage) DeCashUpgrade(_storage) {}
}
