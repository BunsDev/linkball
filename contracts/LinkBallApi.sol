// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract LinkBallApi is ChainlinkClient {
    
    using Chainlink for Chainlink.Request;

    // ###############
    // # CONSTRUCTOR #
    // ###############

    constructor(address oracle_, bytes32 jobId_, uint256 fee_, address link_) {

        oracle = oracle_;
        fee = fee_;
        jobId = jobId_;
        if (link_ == address(0)) _setPublicChainlinkToken();
        else _setChainlinkToken(link_);

    }

    // ####################
    // # PUBLIC FUNCTIONS #
    // ####################

    function startSimulation() public returns (bytes32 requestId) {

        Chainlink.Request memory request = _buildChainlinkRequest(jobId, address(this), this.fulfill.selector);
        request._add("get", "https://hyperrixel.com/hackathon/linkball/simulate.php");
        request._add("path", "result");
        return _sendChainlinkRequestTo(oracle, request, fee);

    }

    function fulfill(bytes32 requestId_, uint256 state_) public recordChainlinkFulfillment(requestId_) {

        log.push(LogEntry(block.timestamp, state_));
        emit NewLogEntry(LogEntry(block.timestamp, state_));

    }

    function getLogEntryCount() public view returns (uint)  {

        return log.length;

    }

    function getLogEntryById(uint id_) public view returns (LogEntry memory) {

        require(id_ < log.length, "Invalid Id.");
        return log[id_];

    }

    // ###########
    // # STRUCTS #
    // ###########

    struct LogEntry {
        uint256 timestamp;
        uint256 state;
    }


    // ###################
    // # ADMIN VARIABLES #
    // ###################

    address private immutable oracle;
    bytes32 private immutable jobId;
    uint256 private immutable fee;

    // ####################
    // # PUBLIC VARIABLES #
    // ####################

    // #####################
    // # PRIVATE VARIABLES #
    // #####################

    LogEntry[] private log;

    // ##########
    // # EVENTS #
    // ##########

    event NewLogEntry(LogEntry logEntry);

}