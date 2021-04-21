pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT

interface DeCashProxyInterface {
    function initialize(string memory _tokenName, address _tokenAddr) external;

    function upgrade(address _new) external;
}
