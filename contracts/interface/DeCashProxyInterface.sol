pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT
// Source code: https://github.com/DeCash-Official/smart-contracts

interface DeCashProxyInterface {
    function initialize(string memory _tokenName, address _tokenAddr) external;

    function upgrade(address _new) external;
}
