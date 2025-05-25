// SPDX-License-Identifier: MIT
import {RewardToken} from "./RewardToken.sol";
import {IERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
pragma solidity ^0.8.18;

contract NFTStaking {
    IERC721 public nftCollection;
    address public owner;
    RewardToken rewardToken;
    mapping(address => uint256) public rewardTokens;

    constructor(address _rewardToken, address _nftCollection) {
        nftCollection = IERC721(_nftCollection);
        owner = msg.sender;
        rewardToken = RewardToken(_rewardToken);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function setAsMinter() public onlyOwner {
        rewardToken.setMinter(address(this));
    }

    function stakeNft(uint256 tokenId) public {
        require(
            nftCollection.ownerOf(tokenId) == msg.sender,
            "Not the NFT owner"
        );
        nftCollection.transferFrom(msg.sender, address(this), tokenId);
        rewardTokens[msg.sender] += 1;
    }

    function pickWinner(address winner, uint256 amount) public onlyOwner {
        require(rewardTokens[winner] > 0, "No NFTs staked by this address");
        rewardToken.mint(winner, amount);
        delete rewardTokens[winner];
      
    }
}
