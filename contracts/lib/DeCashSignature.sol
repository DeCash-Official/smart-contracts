// SPDX-License-Identifier: MIT
// Source code: https://github.com/DeCash-Official/smart-contracts
pragma solidity ^0.7.6;

library Signature {
    enum Std {typed, personal, stringHex}

    enum Dest {transfer, transferFrom, transferMany, approve, approveAndCall}

    bytes public constant ETH_SIGNED_MESSAGE_PREFIX =
        "\x19Ethereum Signed Message:\n";

    // `transferViaSignature`: keccak256(abi.encodePacked(address(this), from, to, value, fee, deadline, sigId))
    bytes32 public constant DEST_TRANSFER =
        keccak256(
            abi.encodePacked(
                "address Contract",
                "address Sender",
                "address Recipient",
                "uint256 Amount (last 2 digits are decimals)",
                "uint256 Fee Amount (last 2 digits are decimals)",
                "address Fee Address",
                "uint256 Expiration",
                "uint256 Signature ID"
            )
        );

    // `transferManyViaSignature`: keccak256(abi.encodePacked(address(this), from, to/value array, deadline, sigId))
    bytes32 public constant DEST_TRANSFER_MANY =
        keccak256(
            abi.encodePacked(
                "address Contract",
                "address Sender",
                "bytes32 Recipient/Amount Array hash",
                "uint256 Fee Amount (last 2 digits are decimals)",
                "address Fee Address",
                "uint256 Expiration",
                "uint256 Signature ID"
            )
        );

    // `transferFromViaSignature`: keccak256(abi.encodePacked(address(this), signer, from, to, value, fee, deadline, sigId))
    bytes32 public constant DEST_TRANSFER_FROM =
        keccak256(
            abi.encodePacked(
                "address Contract",
                "address Approved",
                "address From",
                "address Recipient",
                "uint256 Amount (last 2 digits are decimals)",
                "uint256 Fee Amount (last 2 digits are decimals)",
                "address Fee Address",
                "uint256 Expiration",
                "uint256 Signature ID"
            )
        );

    // `approveViaSignature`: keccak256(abi.encodePacked(address(this), from, spender, value, fee, deadline, sigId))
    bytes32 public constant DEST_APPROVE =
        keccak256(
            abi.encodePacked(
                "address Contract",
                "address Approval",
                "address Recipient",
                "uint256 Amount (last 2 digits are decimals)",
                "uint256 Fee Amount (last 2 digits are decimals)",
                "address Fee Address",
                "uint256 Expiration",
                "uint256 Signature ID"
            )
        );

    // `approveAndCallViaSignature`: keccak256(abi.encodePacked(address(this), from, spender, value, extraData, fee, deadline, sigId))
    bytes32 public constant DEST_APPROVE_AND_CALL =
        keccak256(
            abi.encodePacked(
                "address Contract",
                "address Approval",
                "address Recipient",
                "uint256 Amount (last 2 digits are decimals)",
                "bytes Data to Transfer",
                "uint256 Fee Amount (last 2 digits are decimals)",
                "address Fee Address",
                "uint256 Expiration",
                "uint256 Signature ID"
            )
        );

    /**
     * Utility costly function to encode bytes HEX representation as string.
     *
     * @param sig - signature as bytes32 to represent as string
     */
    function hexToString(bytes32 sig) internal pure returns (bytes memory) {
        bytes memory str = new bytes(64);

        for (uint8 i = 0; i < 32; ++i) {
            str[2 * i] = bytes1(
                (uint8(sig[i]) / 16 < 10 ? 48 : 87) + uint8(sig[i]) / 16
            );
            str[2 * i + 1] = bytes1(
                (uint8(sig[i]) % 16 < 10 ? 48 : 87) + (uint8(sig[i]) % 16)
            );
        }

        return str;
    }

    /**
     * Internal method that makes sure that the given signature corresponds to a given data and is made by `signer`.
     * It utilizes three (four) standards of message signing in Ethereum, as at the moment of this smart contract
     * development there is no single signing standard defined. For example, Metamask and Geth both support
     * personal_sign standard, SignTypedData is only supported by Matamask, Trezor does not support "widely adopted"
     * Ethereum personal_sign but rather personal_sign with fixed prefix and so on.
     * Note that it is always possible to forge any of these signatures using the private key, the problem is that
     * third-party wallets must adopt a single standard for signing messages.
     *
     * @param _data      - original data which had to be signed by `signer`
     * @param _signer    - account which made a signature
     * @param _sig       - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
     * @param _sigStd    - chosen standard for signature validation. The signer must explicitly tell which standard they use
     * @param _sigDest   - for which type of action this signature was made for
     */
    function requireSignature(
        bytes32 _data,
        address _signer,
        bytes memory _sig,
        Std _sigStd,
        Dest _sigDest
    ) internal {
        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // solium-disable-line security/no-inline-assembly
            r := mload(add(_sig, 32))
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }

        if (v < 27) v += 27;

        if (_sigStd == Std.typed) {
            bytes32 dest;

            if (_sigDest == Dest.transfer) {
                dest = DEST_TRANSFER;
            } else if (_sigDest == Dest.transferMany) {
                dest = DEST_TRANSFER_MANY;
            } else if (_sigDest == Dest.transferFrom) {
                dest = DEST_TRANSFER_FROM;
            } else if (_sigDest == Dest.approve) {
                dest = DEST_APPROVE;
            } else if (_sigDest == Dest.approveAndCall) {
                dest = DEST_APPROVE_AND_CALL;
            }

            // Typed signature. This is the most likely scenario to be used and accepted
            require(
                _signer ==
                    ecrecover(
                        keccak256(abi.encodePacked(dest, _data)),
                        v,
                        r,
                        s
                    ),
                "Invalid typed signature"
            );
        } else if (_sigStd == Std.personal) {
            // Ethereum signed message signature (Geth and Trezor)
            require(
                _signer ==
                    ecrecover(
                        keccak256(
                            abi.encodePacked(
                                ETH_SIGNED_MESSAGE_PREFIX,
                                "32",
                                _data
                            )
                        ),
                        v,
                        r,
                        s
                    ) || // Geth-adopted
                    _signer ==
                    ecrecover(
                        keccak256(
                            abi.encodePacked(
                                ETH_SIGNED_MESSAGE_PREFIX,
                                "\x20",
                                _data
                            )
                        ),
                        v,
                        r,
                        s
                    ), // Trezor-adopted
                "Invalid personal signature"
            );
        } else {
            // == 2; Signed string hash signature (the most expensive but universal)
            require(
                _signer ==
                    ecrecover(
                        keccak256(
                            abi.encodePacked(
                                ETH_SIGNED_MESSAGE_PREFIX,
                                "64",
                                hexToString(_data)
                            )
                        ),
                        v,
                        r,
                        s
                    ) || // Geth
                    _signer ==
                    ecrecover(
                        keccak256(
                            abi.encodePacked(
                                ETH_SIGNED_MESSAGE_PREFIX,
                                "\x40",
                                hexToString(_data)
                            )
                        ),
                        v,
                        r,
                        s
                    ), // Trezor
                "Invalid stringHex signature"
            );
        }
    }

    /**
     * This function return the signature of the array of recipient/value pair
     *
     * @param _tos[]         - array of account recipients
     * @param _values[]      - array of amount
     */
    function calculateManySig(address[] memory _tos, uint256[] memory _values)
        internal
        pure
        returns (bytes32)
    {
        bytes32 tv = keccak256(abi.encodePacked(_tos[0], _values[0]));

        uint256 ln = _tos.length;

        for (uint8 x = 1; x < ln; x++) {
            tv = keccak256(abi.encodePacked(tv, _tos[x], _values[x]));
        }

        return tv;
    }
}
