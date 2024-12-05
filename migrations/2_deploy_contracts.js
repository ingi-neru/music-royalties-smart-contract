const MusicStreamingRevenue = artifacts.require("MusicStreamingRevenue");

module.exports = function (deployer) {
    const artistAddress = "0xBC1a730Dd598ad142cdf5D457C7d6a9eF83a46Fb";
    const platformAddress = "0xd8426549316cA3A76fc9E0199810815d3dF42FDd";
    const platformShareBasisPoints = 500; // e.g., 5% as 500 basis points

    deployer.deploy(MusicStreamingRevenue, artistAddress, platformAddress, platformShareBasisPoints);
};
