pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";

contract MusicStreamingRevenue is ChainlinkClient {
    using Chainlink for Chainlink.Request;

    uint256 public volume;

    address public artist;
    address public platform;
    uint256 public streamingRevenue;

    address private oracle;
    bytes32 private jobId;
    uint256 private fee;

    event StreamingRevenueUpdated(uint256 revenue);

    modifier onlyArtist() {
        require(
            msg.sender == artist,
            "Only the artist can perform this action"
        );
        _;
    }

    constructor(address _artist, address _platform) {
        _setPublicChainlinkToken();
        artist = _artist;
        platform = _platform;

        // Set Chainlink Oracle details
        oracle = 0xc57B33452b4F7BB189bB5AfaE9cc4aBa1f7a4FD8;
        jobId = "d5270d1c311941d0b08bead21fea7747";
        fee = 0.1 * 10 ** 18; // 0.1 LINK
    }

    function requestStreamingRevenue(
        string memory artistName
    ) public onlyArtist returns (bytes32 requestId) {
        Chainlink.Request memory request = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        // Add the API URL to fetch artist data
        request.add(
            "get",
            string(
                abi.encodePacked(
                    "http://127.0.0.1:5000/api/artist/",
                    artistName
                )
            )
        );

        // Specify the JSON path to the streams value
        request.add("path", "streams");

        // Sends the request
        return _sendChainlinkRequestTo(oracle, request, fee);
    }

    function fulfill(
        bytes32 _requestId,
        uint256 _revenue
    ) public recordChainlinkFulfillment(_requestId) {
        streamingRevenue = _revenue;
        emit StreamingRevenueUpdated(_revenue);
    }
}
