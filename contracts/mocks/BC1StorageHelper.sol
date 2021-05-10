// SPDX-License-Identifier: MIT

pragma solidity ^0.7.1;

import "../interface/DeCashStorageInterface.sol";

contract BC1StorageHelper {
		DeCashStorageInterface internal _decashStorage;

		constructor(address decashStorageAddress) {
				_decashStorage = DeCashStorageInterface(decashStorageAddress);
		}

		function getTokenVersionByName(string memory name) external view returns (uint) {
				return _decashStorage.getUint(keccak256(abi.encodePacked("token.version", name)));
		}

		function getContractAddressByName(string memory name) external view returns (address) {
				return _decashStorage.getAddress(keccak256(abi.encodePacked("contract.address", name)));
		}

		function hasRole(address user, string memory role) external view returns (bool) {
				return _decashStorage.getBool(keccak256(abi.encodePacked("access.role", role, user)));
		}

		function getHash(string memory rawString) external pure returns (bytes32) {
				return keccak256(abi.encodePacked(rawString));
		}
}
