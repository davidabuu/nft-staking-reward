// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/RewardToken.sol";
import "../src/NFTCollection.sol";
import "../src/NFTStaking.sol";

contract DeployScript is Script {
    function run() external {
        // Start broadcast
        vm.startBroadcast();

        // Deploy RewardToken
        RewardToken rewardToken = new RewardToken();

        // Deploy NFTCollection
        NFTCollection nftCollection = new NFTCollection();

        // Deploy NFTStaking with both addresses
        NFTStaking nftStaking = new NFTStaking(
            address(rewardToken),
            address(nftCollection)
        );

        // Set the staking contract as minter on the reward token
        rewardToken.setMinter(address(nftStaking));

        vm.stopBroadcast();
    }
}
