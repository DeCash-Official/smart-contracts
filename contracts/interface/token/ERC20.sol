pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT
// Source code: https://github.com/DeCash-Official/smart-contracts

interface ERC20 {
    function balanceOf(address _owner) external view returns (uint256);

    function allowance(address _owner, address _spender)
        external
        view
        returns (uint256);

    function transfer(address _to, uint256 _value) external returns (bool);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool);

    function transferMany(address[] calldata _tos, uint256[] calldata _values)
        external
        returns (bool);

    function approve(address _spender, uint256 _value) external returns (bool);

    function mint(address _to, uint256 _value) external returns (bool);

    function burn(uint256 _value) external returns (bool);

    function burnFrom(address _from, uint256 _value) external returns (bool);
}
