// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MusicStreamingRevenue {
    address public artist;
    address public platform;
    mapping(address => uint256) public collaborators; // Shares for collaborators
    address[] private collaboratorList; // Array to store collaborator addresses
    uint256 public platformShare; // Percentage in basis points (e.g., 500 = 5%)
    uint256 public constant totalShares = 10000; // Total shares excluding platform

    event PaymentReceived(address indexed from, uint256 amount);
    event PaymentDistributed(address indexed to, uint256 amount);

    modifier onlyArtist() {
        require(
            msg.sender == artist,
            "Only the artist can perform this action"
        );
        _;
    }

    constructor(
        address _artist,
        address _platform,
        uint256 _platformShareBasisPoints
    ) {
        artist = _artist;
        platform = _platform;
        platformShare = _platformShareBasisPoints;
        collaborators[artist] = 10000 - platformShare;
    }

    // Add a collaborator and assign a share
    function addCollaborator(
        address collaborator,
        uint256 share
    ) external onlyArtist {
        require(collaborator != address(0), "Invalid collaborator address");
        require(share > 0, "Share must be greater than 0");
        require(
            collaborators[collaborator] == 0,
            "Collaborator already exists"
        );
        require(
            share <= collaborators[artist] / 2,
            "The share of a collaborator cannot exceed 50% of the artist's share"
        );

        collaborators[artist] -= share;
        collaborators[collaborator] = share;
        collaboratorList.push(collaborator); // Store the collaborator in the list
    }

    receive() external payable {
        emit PaymentReceived(msg.sender, msg.value);
        _distributePayment(msg.value);
    }

    function _distributePayment(uint256 amount) internal {
        // Platform's share
        uint256 platformAmount = (amount * platformShare) / totalShares;
        payable(platform).transfer(platformAmount);
        emit PaymentDistributed(platform, platformAmount);

        uint256 remaining = amount - platformAmount;

        // Distribute to collaborators
        for (uint256 i = 0; i < collaboratorList.length; i++) {
            address collaboratorAddress = collaboratorList[i];
            uint256 collaboratorAmount = (remaining *
                collaborators[collaboratorAddress]) / totalShares;

            payable(collaboratorAddress).transfer(collaboratorAmount);
            emit PaymentDistributed(collaboratorAddress, collaboratorAmount);
        }

        // Remaining amount to artist
        uint256 artistAmount = (remaining * collaborators[artist]) /
            totalShares;
        payable(artist).transfer(artistAmount);
        emit PaymentDistributed(artist, artistAmount);
    }

    function getCollaborators() external view returns (address[] memory) {
        return collaboratorList;
    }
}
