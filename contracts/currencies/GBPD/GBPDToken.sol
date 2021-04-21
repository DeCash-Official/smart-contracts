pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT

import "../../contract/DeCashToken.sol";

contract GBPDToken is DeCashToken {
    constructor(address _storage) DeCashToken(_storage) {}
}
