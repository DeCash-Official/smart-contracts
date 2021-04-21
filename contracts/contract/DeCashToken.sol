pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT

import "../interface/token/ERC20.sol";
import "../lib/SafeMath.sol";
import "../lib/DeCashSignature.sol";
import "./DeCashBase.sol";
import "./DeCashMultisignature.sol";

/// @title DeCash Token implementation based on the DeCash perpetual storage
/// @author Fabrizio Amodio (ZioFabry)

contract DeCashToken is DeCashBase, DeCashMultisignature, ERC20 {
    using SafeMath for uint256;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    modifier onlyLastest {
        require(
            address(this) ==
                _getAddress(
                    keccak256(abi.encodePacked("contract.address", "token"))
                ) ||
                address(this) ==
                _getAddress(
                    keccak256(abi.encodePacked("contract.address", "proxy"))
                ),
            "Invalid or outdated contract"
        );
        _;
    }

    modifier whenNotPaused {
        require(!isPaused(), "Contract is paused");
        _;
    }
    modifier whenPaused {
        require(isPaused(), "Contract is not paused");
        _;
    }

    event Paused(address indexed from);
    event Unpaused(address indexed from);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    // Construct
    constructor(address _decashStorageAddress)
        DeCashBase(_decashStorageAddress)
    {
        version = 1;
    }

    function initialize(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint8 _tokenDecimals
    ) public onlyOwner {
        uint256 currentVersion =
            _getUint(keccak256(abi.encodePacked("token.version", _tokenName)));

        if (currentVersion == 0) {
            _name = _tokenName;
            _symbol = _tokenSymbol;
            _decimals = _tokenDecimals;

            _setString(keccak256(abi.encodePacked("token.name", _name)), _name);
            _setString(
                keccak256(abi.encodePacked("token.symbol", _name)),
                _symbol
            );
            _setUint(
                keccak256(abi.encodePacked("token.decimals", _name)),
                _decimals
            );
            _setBool(
                keccak256(abi.encodePacked("contract.paused", _name)),
                false
            );
            _setUint(keccak256(abi.encodePacked("mint.reqSign", _name)), 1);
        }

        if (currentVersion != version) {
            _setUint(
                keccak256(abi.encodePacked("token.version", _name)),
                version
            );
        }
    }

    function isPaused() public view returns (bool) {
        return _getBool(keccak256(abi.encodePacked("contract.paused", _name)));
    }

    /**
     * @dev Allows owners to change number of required signature for multiSignature Operations
     * @param _reqsign defines how many signature is required
     */
    function changeRequiredSigners(uint256 _reqsign)
        external
        onlySuperUser
        onlyLastest
        returns (uint256)
    {
        _setReqSign(_reqsign);

        uint256 _generation = _getSignGeneration() + 1;
        _setSignGeneration(_generation);

        emit RequiredSignerChanged(_reqsign, _generation);

        return _generation;
    }

    // ERC20 Implementation
    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external view returns (uint8) {
        return _decimals;
    }

    function totalSupply() external view returns (uint256) {
        return _getTotalSupply();
    }

    function pause() external onlySuperUser onlyLastest whenNotPaused {
        _setBool(keccak256(abi.encodePacked("contract.paused", _name)), true);
        emit Paused(msg.sender);
    }

    function unpause() external onlySuperUser onlyLastest whenPaused {
        _setBool(keccak256(abi.encodePacked("contract.paused", _name)), false);
        emit Unpaused(msg.sender);
    }

    function balanceOf(address _owner)
        external
        view
        override
        returns (uint256)
    {
        return _getBalance(_owner);
    }

    function allowance(address _owner, address _spender)
        external
        view
        override
        returns (uint256)
    {
        return _getAllowed(_owner, _spender);
    }

    function transfer(address _to, uint256 _value)
        external
        override
        onlyLastest
        whenNotPaused
        returns (bool)
    {
        return _transfer(msg.sender, _to, _value);
    }

    function transferMany(address[] calldata _tos, uint256[] calldata _values)
        external
        override
        onlyLastest
        whenNotPaused
        returns (bool)
    {
        return _transferMany(msg.sender, _tos, _values);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external override onlyLastest whenNotPaused returns (bool) {
        return _transferFrom(msg.sender, _from, _to, _value);
    }

    function approve(address _spender, uint256 _value)
        external
        override
        onlyLastest
        whenNotPaused
        returns (bool)
    {
        return _approve(msg.sender, _spender, _value);
    }

    function burn(uint256 _value)
        external
        override
        onlyLastest
        whenNotPaused
        returns (bool)
    {
        return _burn(msg.sender, _value);
    }

    function burnFrom(address _from, uint256 _value)
        external
        override
        onlyLastest
        whenNotPaused
        returns (bool)
    {
        _approve(_from, msg.sender, _getAllowed(_from, msg.sender).sub(_value));

        return _burn(_from, _value);
    }

    function mint(address _to, uint256 _value)
        external
        override
        onlySuperUser
        onlyLastest
        whenNotPaused
        onlyMultiSignature(_getReqSign(), _getSignGeneration())
        returns (bool success)
    {
        _addBalance(_to, _value);
        _addTotalSupply(_value);

        emit Transfer(address(0), _to, _value);

        return true;
    }

    /**
     * This function distincts transaction signer from transaction executor. It allows anyone to transfer tokens
     * from the `from` account by providing a valid signature, which can only be obtained from the `from` account owner.
     * Note that passed parameter sigId is unique and cannot be passed twice (prevents replay attacks). When there's
     * a need to make signature once again (because the first on is lost or whatever), user should sign the message
     * with the same sigId, thus ensuring that the previous signature won't be used if the new one passes.
     * Use case: the user wants to send some tokens to other user or smart contract, but don't have ether to do so.
     *
     * @param _from          - the account giving its signature to transfer `value` tokens to `to` address
     * @param _to            - the account receiving `value` tokens
     * @param _value         - the value in tokens to transfer
     * @param _fee           - a fee to pay to `feeRecipient`
     * @param _feeRecipient  - account which will receive fee
     * @param _deadline      - until when the signature is valid
     * @param _sigId         - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
     * @param _sig           - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
     * @param _sigStd        - chosen standard for signature validation. The signer must explicitly tell which standard they use
     */
    function transferViaSignature(
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        address _feeRecipient,
        uint256 _deadline,
        uint256 _sigId,
        bytes calldata _sig,
        Signature.Std _sigStd
    ) external onlyLastest {
        _validateViaSignatureParams(
            msg.sender,
            _from,
            _feeRecipient,
            _deadline,
            _sigId
        );

        Signature.requireSignature(
            keccak256(
                abi.encodePacked(
                    address(this),
                    _from,
                    _to,
                    _value,
                    _fee,
                    _feeRecipient,
                    _deadline,
                    _sigId
                )
            ),
            _from,
            _sig,
            _sigStd,
            Signature.Dest.transfer
        );

        _subBalance(_from, _value.add(_fee)); // Subtract (value + fee)
        _addBalance(_to, _value);
        emit Transfer(_from, _to, _value);

        if (_fee > 0) {
            _addBalance(_feeRecipient, _fee);
            emit Transfer(_from, _feeRecipient, _fee);
        }

        _burnSigId(_from, _sigId);
    }

    /**
     * This function distincts transaction signer from transaction executor. It allows anyone to transfer tokens
     * from the `from` account to multiple recipient address by providing a valid signature, which can only be obtained from the `from` account owner.
     * Note that passed parameter sigId is unique and cannot be passed twice (prevents replay attacks). When there's
     * a need to make signature once again (because the first on is lost or whatever), user should sign the message
     * with the same sigId, thus ensuring that the previous signature won't be used if the new one passes.
     * Also note that the 1st recipient must be a valid fee receiver
     * Use case: the user wants to send some tokens to multiple users or smart contracts, but don't have ether to do so.
     *
     * @param _from          - the account giving its signature to transfer `value` tokens to `to` address
     * @param _tos[]         - array of account recipients
     * @param _values[]      - array of amount
     * @param _fee           - a fee to pay to `feeRecipient`
     * @param _feeRecipient  - account which will receive fee
     * @param _deadline      - until when the signature is valid
     * @param _sigId         - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
     * @param _sig           - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
     * @param _sigStd        - chosen standard for signature validation. The signer must explicitly tell which standard they use
     */
    function transferManyViaSignature(
        address _from,
        address[] calldata _tos,
        uint256[] calldata _values,
        uint256 _fee,
        address _feeRecipient,
        uint256 _deadline,
        uint256 _sigId,
        bytes calldata _sig,
        Signature.Std _sigStd
    ) external onlyLastest {
        uint256 tosLen = _tos.length;

        require(tosLen == _values.length, "Wrong array parameters");
        require(tosLen <= 100, "Too many receiver");

        _validateViaSignatureParams(
            msg.sender,
            _from,
            _feeRecipient,
            _deadline,
            _sigId
        );

        bytes32 multisig = Signature.calculateManySig(_tos, _values);

        Signature.requireSignature(
            keccak256(
                abi.encodePacked(
                    address(this),
                    _from,
                    multisig,
                    _fee,
                    _feeRecipient,
                    _deadline,
                    _sigId
                )
            ),
            _from,
            _sig,
            _sigStd,
            Signature.Dest.transferMany
        );

        _subBalance(_from, _calculateTotal(_values).add(_fee));

        for (uint8 x = 0; x < tosLen; x++) {
            _addBalance(_tos[x], _values[x]);
            emit Transfer(_from, _tos[x], _values[x]);
        }

        if (_fee > 0) {
            _addBalance(_feeRecipient, _fee);
            emit Transfer(_from, _feeRecipient, _fee);
        }

        _burnSigId(_from, _sigId);
    }

    /**
     * Same as `transferViaSignature`, but for `approve`.
     * Use case: the user wants to set an allowance for the smart contract or another user without having ether on their
     * balance.
     *
     * @param _from          - the account to approve withdrawal from, which signed all below parameters
     * @param _spender       - the account allowed to withdraw tokens from `from` address
     * @param _value         - the value in tokens to approve to withdraw
     * @param _fee           - a fee to pay to `feeRecipient`
     * @param _feeRecipient  - account which will receive fee
     * @param _deadline      - until when the signature is valid
     * @param _sigId         - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
     * @param _sig           - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
     * @param _sigStd        - chosen standard for signature validation. The signer must explicitely tell which standard they use
     */
    function approveViaSignature(
        address _from,
        address _spender,
        uint256 _value,
        uint256 _fee,
        address _feeRecipient,
        uint256 _deadline,
        uint256 _sigId,
        bytes calldata _sig,
        Signature.Std _sigStd
    ) external onlyLastest {
        _validateViaSignatureParams(
            msg.sender,
            _from,
            _feeRecipient,
            _deadline,
            _sigId
        );

        Signature.requireSignature(
            keccak256(
                abi.encodePacked(
                    address(this),
                    _from,
                    _spender,
                    _value,
                    _fee,
                    _feeRecipient,
                    _deadline,
                    _sigId
                )
            ),
            _from,
            _sig,
            _sigStd,
            Signature.Dest.approve
        );

        if (_fee > 0) {
            _subBalance(_from, _fee);
            _addBalance(_feeRecipient, _fee);
            emit Transfer(_from, _feeRecipient, _fee);
        }

        _setAllowed(_from, _spender, _value);
        emit Approval(_from, _spender, _value);

        _burnSigId(_from, _sigId);
    }

    /**
     * Same as `transferViaSignature`, but for `transferFrom`.
     * Use case: the user wants to withdraw tokens from a smart contract or another user who allowed the user to
     * do so. Important note: the fee is subtracted from the `value`, and `to` address receives `value - fee`.
     *
     * @param _signer       - the address allowed to call transferFrom, which signed all below parameters
     * @param _from         - the account to make withdrawal from
     * @param _to           - the address of the recipient
     * @param _value        - the value in tokens to withdraw
     * @param _fee          - a fee to pay to `feeRecipient`
     * @param _feeRecipient - account which will receive fee
     * @param _deadline     - until when the signature is valid
     * @param _sigId        - signature unique ID. Signatures made with the same signature ID cannot be submitted twice
     * @param _sig          - signature made by `from`, which is the proof of `from`'s agreement with the above parameters
     * @param _sigStd       - chosen standard for signature validation. The signer must explicitly tell which standard they use
     */
    function transferFromViaSignature(
        address _signer,
        address _from,
        address _to,
        uint256 _value,
        uint256 _fee,
        address _feeRecipient,
        uint256 _deadline,
        uint256 _sigId,
        bytes calldata _sig,
        Signature.Std _sigStd
    ) external onlyLastest {
        _validateViaSignatureParams(
            msg.sender,
            _from,
            _feeRecipient,
            _deadline,
            _sigId
        );

        Signature.requireSignature(
            keccak256(
                abi.encodePacked(
                    address(this),
                    _from,
                    _to,
                    _value,
                    _fee,
                    _feeRecipient,
                    _deadline,
                    _sigId
                )
            ),
            _signer,
            _sig,
            _sigStd,
            Signature.Dest.transferFrom
        );

        _subAllowed(_from, _signer, _value.add(_fee));

        _subBalance(_from, _value.add(_fee)); // Subtract (value + fee)
        _addBalance(_to, _value);
        emit Transfer(_from, _to, _value);

        if (_fee > 0) {
            _addBalance(_feeRecipient, _fee);
            emit Transfer(_from, _feeRecipient, _fee);
        }

        _burnSigId(_from, _sigId);
    }

    // Total Supply Handling
    function _getTotalSupply() internal view returns (uint256) {
        return
            _getUint(keccak256(abi.encodePacked("token.totalSupply", _name)));
    }

    function _setTotalSupply(uint256 _supply) internal {
        _setUint(
            keccak256(abi.encodePacked("token.totalSupply", _name)),
            _supply
        );
    }

    function _addTotalSupply(uint256 _supply) internal {
        _setTotalSupply(_getTotalSupply().add(_supply));
    }

    function _subTotalSupply(uint256 _supply) internal {
        _setTotalSupply(_getTotalSupply().sub(_supply));
    }

    // Allowed Handling
    function _getAllowed(address _owner, address _spender)
        internal
        view
        returns (uint256)
    {
        return
            _getUint(
                keccak256(
                    abi.encodePacked("token.allowed", _name, _owner, _spender)
                )
            );
    }

    function _setAllowed(
        address _owner,
        address _spender,
        uint256 _remaining
    ) internal {
        _setUint(
            keccak256(
                abi.encodePacked("token.allowed", _name, _owner, _spender)
            ),
            _remaining
        );
    }

    function _addAllowed(
        address _owner,
        address _spender,
        uint256 _balance
    ) internal {
        _setAllowed(
            _owner,
            _spender,
            _getAllowed(_owner, _spender).add(_balance)
        );
    }

    function _subAllowed(
        address _owner,
        address _spender,
        uint256 _balance
    ) internal {
        _setAllowed(
            _owner,
            _spender,
            _getAllowed(_owner, _spender).sub(_balance)
        );
    }

    // Balance Handling
    function _getBalance(address _owner) internal view returns (uint256) {
        return
            _getUint(
                keccak256(abi.encodePacked("token.balance", _name, _owner))
            );
    }

    function _setBalance(address _owner, uint256 _balance) internal {
        require(!_isBlacklisted(_owner), "Blacklisted");
        _setUint(
            keccak256(abi.encodePacked("token.balance", _name, _owner)),
            _balance
        );
    }

    function _addBalance(address _owner, uint256 _balance) internal {
        _setBalance(_owner, _getBalance(_owner).add(_balance));
    }

    function _subBalance(address _owner, uint256 _balance) internal {
        _setBalance(_owner, _getBalance(_owner).sub(_balance));
    }

    // Other Variable Handling
    function _getReqSign() internal view returns (uint256) {
        return _getUint(keccak256(abi.encodePacked("mint.reqSign", _name)));
    }

    function _getSignGeneration() internal view returns (uint256) {
        return _getUint(keccak256(abi.encodePacked("sign.generation", _name)));
    }

    function _getUsedSigIds(address _signer, uint256 _sigId)
        internal
        view
        returns (bool)
    {
        return
            _getBool(
                keccak256(
                    abi.encodePacked("sign.generation", _name, _signer, _sigId)
                )
            );
    }

    function _setReqSign(uint256 _reqsign) internal {
        _setUint(keccak256(abi.encodePacked("mint.reqSign", _name)), _reqsign);
    }

    function _setSignGeneration(uint256 _generation) internal {
        _setUint(
            keccak256(abi.encodePacked("sign.generation", _name)),
            _generation
        );
    }

    function _setUsedSigIds(
        address _signer,
        uint256 _sigId,
        bool _used
    ) internal {
        _setBool(
            keccak256(
                abi.encodePacked("sign.generation", _name, _signer, _sigId)
            ),
            _used
        );
    }

    function _burn(address _from, uint256 _value) internal returns (bool) {
        _subBalance(_from, _value);
        _subTotalSupply(_value);

        emit Transfer(_from, address(0), _value);

        return true;
    }

    function _transfer(
        address _sender,
        address _to,
        uint256 _value
    ) internal returns (bool) {
        _subBalance(_sender, _value);
        _addBalance(_to, _value);

        emit Transfer(_sender, _to, _value);

        return true;
    }

    function _transferMany(
        address _sender,
        address[] calldata _tos,
        uint256[] calldata _values
    ) internal returns (bool) {
        uint256 tosLen = _tos.length;

        require(tosLen == _values.length, "Wrong array parameter");
        require(tosLen <= 100, "Too many receiver");

        _subBalance(_sender, _calculateTotal(_values));

        for (uint8 x = 0; x < tosLen; x++) {
            _addBalance(_tos[x], _values[x]);

            emit Transfer(_sender, _tos[x], _values[x]);
        }

        return true;
    }

    function _transferFrom(
        address _sender,
        address _from,
        address _to,
        uint256 _value
    ) internal returns (bool) {
        _subAllowed(_from, _sender, _value);
        _subBalance(_from, _value);
        _addBalance(_to, _value);

        emit Transfer(_from, _to, _value);

        return true;
    }

    function _approve(
        address _sender,
        address _spender,
        uint256 _value
    ) internal returns (bool) {
        _setAllowed(_sender, _spender, _value);

        emit Approval(_sender, _spender, _value);

        return true;
    }

    function _calculateTotal(uint256[] memory _values)
        internal
        pure
        returns (uint256)
    {
        uint256 total = 0;
        uint256 ln = _values.length;

        for (uint8 x = 0; x < ln; x++) {
            total = total.add(_values[x]);
        }

        return total;
    }

    // Delegated functions

    /**
     * These functions are used to avoid the use of the modifiers that can cause the "stack too deep" error
     * also for code optimization
     */
    function _validateViaSignatureParams(
        address _delegator,
        address _from,
        address _feeRecipient,
        uint256 _deadline,
        uint256 _sigId
    ) internal view {
        require(!isPaused(), "Contract paused");
        require(_isDelegator(_delegator), "Sender is not a delegator");
        require(_isFeeRecipient(_feeRecipient), "Invalid fee recipient");
        require(block.timestamp <= _deadline, "Request expired");
        require(!_getUsedSigIds(_from, _sigId), "Request already used");
    }

    function _burnSigId(address _from, uint256 _sigId) internal {
        _setUsedSigIds(_from, _sigId, true);
    }
}
