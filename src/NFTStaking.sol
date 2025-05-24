// SPDX-License-Identifier: MIT
import {RewardToken} from "./RewardToken.sol";

pragma solidity 0.8.19;


contract NFTStaking {
    address public owner;
    RewardToken rewardToken;
    constructor(address _rewardToken) {
        owner = msg.sender;
        rewardToken = RewardToken(_rewardToken);

    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function setAsMinter() public onlyOwner{
        rewardToken.setMinter(address(this))
    }
}