pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT
// Source code: https://github.com/DeCash-Official/smart-contracts

import "./DeCashBase.sol";
import "../interface/DeCashUpgradeInterface.sol";
import "../interface/DeCashProxyInterface.sol";
import "../interface/token/ERC20.sol";

// Handles network contract upgrades

contract DeCashUpgrade is DeCashBase, DeCashUpgradeInterface {
    // Events
    event ContractUpgraded(
        bytes32 indexed name,
        address indexed oldAddress,
        address indexed newAddress,
        uint256 time
    );
    event ContractAdded(
        bytes32 indexed name,
        address indexed newAddress,
        uint256 time
    );
    event ABIUpgraded(bytes32 indexed name, uint256 time);
    event ABIAdded(bytes32 indexed name, uint256 time);

    // Construct
    constructor(address _decashStorageAddress)
        DeCashBase(_decashStorageAddress)
    {
        version = 1;
    }

    // Upgrade a network contract
    function upgradeContract(
        string memory _name,
        address _contractAddress,
        string memory _contractAbi
    )
        external
        override
        onlyLatestContract("upgrade", address(this))
        onlySuperUser
    {
        // Check contract being upgraded
        bytes32 nameHash = keccak256(abi.encodePacked(_name));
        require(nameHash != keccak256(abi.encodePacked("proxy")), "Cannot upgrade proxy contracts");
        // require(nameHash != keccak256(abi.encodePacked("token")), "Cannot upgrade token contracts");

        // Get old contract address & check contract exists
        address oldContractAddress =
            _getAddress(keccak256(abi.encodePacked("contract.address", _name)));
        require(oldContractAddress != address(0x0), "Contract does not exist");

        // Check new contract address
        require(_contractAddress != address(0x0), "Invalid contract address");
        require(
            _contractAddress != oldContractAddress,
            "The contract address cannot be set to its current address"
        );

        // Register new contract
        _setBool(
            keccak256(abi.encodePacked("contract.exists", _contractAddress)),
            true
        );
        _setString(
            keccak256(abi.encodePacked("contract.name", _contractAddress)),
            _name
        );
        _setAddress(
            keccak256(abi.encodePacked("contract.address", _name)),
            _contractAddress
        );
        _setString(
            keccak256(abi.encodePacked("contract.abi", _name)),
            _contractAbi
        );

        // Deregister old contract
        _deleteString(
            keccak256(abi.encodePacked("contract.name", oldContractAddress))
        );
        _deleteBool(
            keccak256(abi.encodePacked("contract.exists", oldContractAddress))
        );

        // Emit contract upgraded event
        emit ContractUpgraded(
            nameHash,
            oldContractAddress,
            _contractAddress,
            block.timestamp
        );

        // if the upgraded contract is the token, I updated also the proxy contract
        if (nameHash == keccak256(abi.encodePacked("token"))) {
            DeCashProxyInterface proxy =
                DeCashProxyInterface(
                    _getAddress(
                        keccak256(abi.encodePacked("contract.address", "proxy"))
                    )
                );
            proxy.upgrade(_contractAddress);
        }
    }

    // Add a new network contract
    function addContract(
        string memory _name,
        address _contractAddress,
        string memory _contractAbi
    )
        external
        override
        onlyLatestContract("upgrade", address(this))
        onlySuperUser
    {
        // Check contract name
        bytes32 nameHash = keccak256(abi.encodePacked(_name));
        require(
            nameHash != keccak256(abi.encodePacked("")),
            "Invalid contract name"
        );
        require(
            _getAddress(
                keccak256(abi.encodePacked("contract.address", _name))
            ) == address(0x0),
            "Contract name is already in use"
        );

        string memory existingAbi =
            _getString(keccak256(abi.encodePacked("contract.abi", _name)));
        require(
            keccak256(abi.encodePacked(existingAbi)) ==
                keccak256(abi.encodePacked("")),
            "Contract name is already in use"
        );

        // Check contract address
        require(_contractAddress != address(0x0), "Invalid contract address");
        require(
            !_getBool(
                keccak256(abi.encodePacked("contract.exists", _contractAddress))
            ),
            "Contract address is already in use"
        );

        // Register contract
        _setBool(
            keccak256(abi.encodePacked("contract.exists", _contractAddress)),
            true
        );
        _setString(
            keccak256(abi.encodePacked("contract.name", _contractAddress)),
            _name
        );
        _setAddress(
            keccak256(abi.encodePacked("contract.address", _name)),
            _contractAddress
        );
        _setString(
            keccak256(abi.encodePacked("contract.abi", _name)),
            _contractAbi
        );

        // Emit contract added event
        emit ContractAdded(nameHash, _contractAddress, block.timestamp);
    }

    // Upgrade a network contract ABI
    function upgradeABI(string memory _name, string memory _contractAbi)
        external
        override
        onlyLatestContract("upgrade", address(this))
        onlySuperUser
    {
        // Check ABI exists
        string memory existingAbi =
            _getString(keccak256(abi.encodePacked("contract.abi", _name)));
        require(
            keccak256(abi.encodePacked(existingAbi)) !=
                keccak256(abi.encodePacked("")),
            "ABI does not exist"
        );

        // Set ABI
        _setString(
            keccak256(abi.encodePacked("contract.abi", _name)),
            _contractAbi
        );

        // Emit ABI upgraded event
        emit ABIUpgraded(keccak256(abi.encodePacked(_name)), block.timestamp);
    }

    // Add a new network contract ABI
    function addABI(string memory _name, string memory _contractAbi)
        external
        override
        onlyLatestContract("upgrade", address(this))
        onlySuperUser
    {
        // Check ABI name
        bytes32 nameHash = keccak256(abi.encodePacked(_name));
        require(
            nameHash != keccak256(abi.encodePacked("")),
            "Invalid ABI name"
        );
        require(
            _getAddress(
                keccak256(abi.encodePacked("contract.address", _name))
            ) == address(0x0),
            "ABI name is already in use"
        );

        string memory existingAbi =
            _getString(keccak256(abi.encodePacked("contract.abi", _name)));
        require(
            keccak256(abi.encodePacked(existingAbi)) ==
                keccak256(abi.encodePacked("")),
            "ABI name is already in use"
        );

        // Set ABI
        _setString(
            keccak256(abi.encodePacked("contract.abi", _name)),
            _contractAbi
        );

        // Emit ABI added event
        emit ABIAdded(nameHash, block.timestamp);
    }
}
