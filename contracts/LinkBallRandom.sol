// SPDX-License-Identifier: Copyright
pragma solidity ^0.8.19;

import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract LinkBallRandom is VRFConsumerBaseV2 {

    // ###############
    // # CONSTRUCTOR #
    // ###############

    constructor(uint64 subscriptionId_, address vrfCoordinator_, bytes32 keyHash_) VRFConsumerBaseV2(vrfCoordinator_) {

        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator_);
        keyHash = keyHash_;
        owner = msg.sender;
        subscriptionId = subscriptionId_;

    }

    // ####################
    // # PUBLIC FUNCTIONS #
    // ####################

    function requestRandomWords() external {

        requestId = COORDINATOR.requestRandomWords(keyHash, subscriptionId, REQUEST_CONFIRMATIONS, CALLBACK_GAS_LIMIT, NUM_NUMBERS);

    }

    function fulfillRandomWords(uint256, uint256[] memory randomNumbers_) internal override  {

        for (uint i = 0; i < randomNumbers_.length; i++)
            allRandomNumbers.push(randomNumbers_[i]);
        emit NewRandomNumbers(randomNumbers_);

    }

    function getRandomNumber() public returns (uint256) {

        require(allRandomNumbers.length > 0, "No random numbers stored.");
        uint256 lastElement = allRandomNumbers[allRandomNumbers.length - 1];
        allRandomNumbers.pop();
        return lastElement;

    }

    function getRandomNumbersCount() external view returns (uint) {

        return allRandomNumbers.length;

    }

    function getSubscriptionId() public view returns (uint64) {

        return subscriptionId;

    }

    // ###################
    // # ADMIN VARIABLES #
    // ###################

    VRFCoordinatorV2Interface private immutable COORDINATOR;
    bytes32 private immutable keyHash;
    address private owner;
    uint64 private immutable subscriptionId;

    // #############
    // # CONSTANTS #
    // #############

    uint32 constant CALLBACK_GAS_LIMIT = 100000;
    uint16 constant REQUEST_CONFIRMATIONS = 3;
    uint32 constant NUM_NUMBERS = 2;

    // ####################
    // # PUBLIC VARIABLES #
    // ####################

    // #####################
    // # PRIVATE VARIABLES #
    // #####################

    uint256[] private allRandomNumbers;
    uint256 private requestId;

    // ##########
    // # EVENTS #
    // ##########

    event NewRandomNumbers(uint256[] randomNumbers);

}