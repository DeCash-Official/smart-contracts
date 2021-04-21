pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT

import "../interface/DeCashProxyInterface.sol";
import "../lib/Address.sol";
import "./DeCashBase.sol";
import "./Proxy.sol";

/// @title DeCash Proxy Contract
/// @author Fabrizio Amodio (ZioFabry)

contract DeCashProxy is DeCashBase, Proxy {
    bytes32 private constant _IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    event ProxyInitiated(address indexed implementation);
    event ProxyUpgraded(address indexed implementation);

    // Construct
    constructor(address _decashStorageAddress)
        DeCashBase(_decashStorageAddress)
    {
        assert(
            _IMPLEMENTATION_SLOT ==
                bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
        );
        version = 1;
    }

    function upgrade(address _address)
        public
        onlyLatestContract("upgrade", msg.sender)
    {
        _setImplementation(_address);

        emit ProxyUpgraded(_address);
    }

    function initialize(address _address) external onlyOwner {
        require(
            !_getBool(keccak256(abi.encodePacked("proxy.init", address(this)))),
            "Proxy already initialized"
        );

        _setImplementation(_address);
        _setBool(keccak256(abi.encodePacked("proxy.init", address(this))), true);

        emit ProxyInitiated(_address);
    }

    /**
     * @dev Stores a new address in the EIP1967 implementation slot.
     */
    function _setImplementation(address _address) private {
        require(Address.isContract(_address), "address is not a contract");

        bytes32 slot = _IMPLEMENTATION_SLOT;

        // solhint-disable-next-line no-inline-assembly
        assembly {
            sstore(slot, _address)
        }
    }

    /**
     * @dev Returns the current implementation address.
     */
    function _implementation() internal view override returns (address impl) {
        bytes32 slot = _IMPLEMENTATION_SLOT;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            impl := sload(slot)
        }
    }
}
