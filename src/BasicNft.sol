// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BasicNft is ERC721 {
    uint256 private s_tokenId;
    mapping (uint256 => string) private s_tokenIdToUri;
    constructor() ERC721("Doggie", "DOG") {
        s_tokenId = 0;
    }

    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenId] = tokenUri;
        _safeMint(msg.sender, s_tokenId); // 铸造NFT
        s_tokenId++;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
    }
    
}