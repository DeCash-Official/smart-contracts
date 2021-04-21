pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT
// Source code: https://github.com/DeCash-Official/smart-contracts

import "../../contract/DeCashToken.sol";

contract CHFDToken is DeCashToken {
    constructor(address _storage) DeCashToken(_storage) {}
}
