//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFTCollection is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenURIs;

    constructor() ERC721("Dogie", "DOG") {
        s_tokenCounter = 0;
    }

    function mintNft(string memory tokenURI) public {
        s_tokenURIs[s_tokenCounter] = tokenURI;

        _safeMint(msg.sender, s_tokenCounter);
        s_tokenCounter++;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenURIs[tokenId];
    }
}
