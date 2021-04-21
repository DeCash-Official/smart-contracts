pragma solidity ^0.7.6;

// SPDX-License-Identifier: MIT

/// @title DeCash Token Multisignature Management
/// @author Fabrizio Amodio (ZioFabry)

abstract contract DeCashMultisignature {
    bytes32[] public allOperations;
    mapping(bytes32 => uint256) public allOperationsIndicies;
    mapping(bytes32 => uint256) public votesCountByOperation;
    mapping(bytes32 => address) public firstByOperation;
    mapping(bytes32 => mapping(address => uint8)) public votesOwnerByOperation;
    mapping(bytes32 => address[]) public votesIndicesByOperation;

    uint256 public signerGeneration;
    address internal _insideCallSender;
    uint256 internal _insideCallCount;

    event RequiredSignerChanged(
        uint256 newRequiredSignature,
        uint256 generation
    );
    event OperationCreated(bytes32 operation, address proposer);
    event OperationUpvoted(bytes32 operation, address voter);
    event OperationPerformed(bytes32 operation, address performer);
    event OperationCancelled(bytes32 operation, address performer);

    /**
     * @dev Allows to perform method only after many owners call it with the same arguments
     * @param _howMany defines how mant signature are required
     * @param _generation multiusignature generation
     */
    modifier onlyMultiSignature(uint256 _howMany, uint256 _generation) {
        if (_checkMultiSignature(_howMany, _generation)) {
            bool update = (_insideCallSender == address(0));
            if (update) {
                _insideCallSender = msg.sender;
                _insideCallCount = _howMany;
            }

            _;

            if (update) {
                _insideCallSender = address(0);
                _insideCallCount = 0;
            }
        }
    }

    /**
     * @dev Allows owners to change their mind by cacnelling votesMaskByOperation operations
     * @param operation defines which operation to delete
     */
    function cancelOperation(bytes32 operation) external {
        require(votesCountByOperation[operation] > 0, "Operation not found");

        _deleteOperation(operation);

        emit OperationCancelled(operation, msg.sender);
    }

    /**
     * @dev onlyManyOwners modifier helper
     * @param _howMany defines how mant signature are required
     * @param _generation multiusignature generation
     */
    function _checkMultiSignature(uint256 _howMany, uint256 _generation)
        internal
        returns (bool)
    {
        if (_howMany < 2) return true;

        if (_insideCallSender == msg.sender) {
            require(_howMany <= _insideCallCount, "howMany > _insideCallCount");
            return true;
        }

        bytes32 operation = keccak256(abi.encodePacked(msg.data, _generation));

        uint256 operationVotesCount = votesCountByOperation[operation] + 1;
        votesCountByOperation[operation] = operationVotesCount;

        if (firstByOperation[operation] == address(0)) {
            firstByOperation[operation] = msg.sender;

            allOperationsIndicies[operation] = allOperations.length;
            allOperations.push(operation);

            emit OperationCreated(operation, msg.sender);
        } else {
            require(
                votesOwnerByOperation[operation][msg.sender] == 0,
                "[operation][msg.sender] != 0"
            );
        }

        votesIndicesByOperation[operation].push(msg.sender);
        votesOwnerByOperation[operation][msg.sender] = 1;

        emit OperationUpvoted(operation, msg.sender);

        if (operationVotesCount < _howMany) return false;

        _deleteOperation(operation);

        emit OperationPerformed(operation, msg.sender);

        return true;
    }

    /**
     * @dev Used to delete cancelled or performed operation
     * @param operation defines which operation to delete
     */
    function _deleteOperation(bytes32 operation) internal {
        uint256 index = allOperationsIndicies[operation];
        if (index < allOperations.length - 1) {
            // Not last
            allOperations[index] = allOperations[allOperations.length - 1];
            allOperationsIndicies[allOperations[index]] = index;
        }

        delete allOperations[allOperations.length - 1];
        delete allOperationsIndicies[operation];
        delete votesCountByOperation[operation];
        delete firstByOperation[operation];

        uint8 x;
        uint256 ln = votesIndicesByOperation[operation].length;

        for (x = 0; x < ln; x++) {
            delete votesOwnerByOperation[operation][
                votesIndicesByOperation[operation][x]
            ];
        }

        for (x = 0; x < ln; x++) {
            votesIndicesByOperation[operation].pop();
        }
    }
}
