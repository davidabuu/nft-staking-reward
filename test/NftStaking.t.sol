// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../src/RewardToken.sol";
import "../src/NFTCollection.sol";
import "../src/NFTStaking.sol";

contract NFTStakingTest is Test {
    RewardToken rewardToken;
    NFTCollection nftCollection;
    NFTStaking nftStaking;

    address alice = address(0xA11CE);
    address bob = address(0xB0B);
    string baseURI = "ipfs://metadata-uri/";// set a base URI for the NFT metadata

    function setUp() public {
        rewardToken = new RewardToken();
        nftCollection = new NFTCollection();
        nftStaking = new NFTStaking(
            address(rewardToken),
            address(nftCollection)
        );

        // Grant minter role to staking contract
        rewardToken.setMinter(address(nftStaking));

       
        vm.label(alice, "Alice");
        vm.label(bob, "Bob");
    }

    function testStakeAndRewardFlow() public {
        // Mint NFT to Alice
        vm.prank(alice);
        nftCollection.mintNft(baseURI);

        // Approve staking contract to transfer Alice's NFT`
        vm.prank(alice);
        nftCollection.approve(address(nftStaking), 0); // tokenId = 0

        // Alice stakes the NFT
        vm.prank(alice);
        nftStaking.stakeNft(0);

        // Confirm staking record
        assertEq(nftCollection.ownerOf(0), address(nftStaking));
        assertEq(nftStaking.rewardTokens(alice), 1);

        // Admin picks Alice as winner and rewards her
        uint256 rewardAmount = 100 ether;
        nftStaking.pickWinner(alice, rewardAmount);

        // Check balance
        assertEq(rewardToken.balanceOf(alice), rewardAmount);
        assertEq(nftStaking.rewardTokens(alice), 0);
    }

    function testRevertIfNotOwner() public {
        // Mint NFT to Bob
        vm.prank(bob);
        nftCollection.mintNft(baseURI);

        // Try staking without approving
        vm.expectRevert(); // should revert due to lack of approval
        vm.prank(bob);
        nftStaking.stakeNft(0);
    }

    function testRevertIfZeroStakeOnPickWinner() public {
        vm.expectRevert("No NFTs staked by this address");
        nftStaking.pickWinner(bob, 50 ether);
    }
}
