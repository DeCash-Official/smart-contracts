pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT
// Source code: https://github.com/DeCash-Official/smart-contracts

interface DeCashRoleInterface {
    function transferOwnership(address _newOwner) external;

    function addRole(string memory _role, address _address) external;

    function removeRole(string memory _role, address _address) external;
}
