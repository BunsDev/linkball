// SPDX-License-Identifier: Copyright
pragma solidity ^0.8.19;

import "./LinkBallApi.sol";
import "./LinkBallRandom.sol";

contract LinkBall {

    constructor(string memory sentence_) {

        rootUser = payable(msg.sender);
        rootKey = keccak256(abi.encodePacked(sentence_));
        availableBalanceETH = 0;
        availableBalanceLINK = 0;

    }

    // ###################
    // # ADMIN VARIABLES #
    // ###################

    address payable private rootUser;
    bytes32 private rootKey;
    uint256 private availableBalanceETH;
    uint256 private availableBalanceLINK;
    LinkBallApi private  contractAPI;
    LinkBallRandom private contractVRF;

    // ###########
    // # STRUCTS #
    // ###########

    struct Team {
        uint userId;
        string Name;
        uint256 teamRandom;
        uint8 state;
    }

    struct User {
        uint teamId;
        address wallet;
        string name;
        string email;
        bytes32 hash;
        uint256 personalRandom;
        uint8 state;
    }

    // ####################
    // # PUBLIC VARIABLES #
    // ####################

    // #####################
    // # PRIVATE VARIABLES #
    // #####################

    User[] private users;
    Team[] private teams;

    // ##########
    // # EVENTS #
    // ##########



}