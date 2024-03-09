// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenId;
    string private s_sadSvgImgUri;
    string private s_happySvgImgUri;

    enum Mood{
        Happy,
        Sad
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(
        string memory sadSvgImgUri,
        string memory happySvgImgUri
    ) ERC721("Mood NFT", "MOOD") {
        s_tokenId = 0;
        s_sadSvgImgUri = sadSvgImgUri;
        s_happySvgImgUri = happySvgImgUri;
    }

    /**
     * @dev 铸造NFT
     * 铸造NFT时,将tokenId和mood映射关系存储到s_tokenIdToMood中
     * 通过调用_safeMint方法,将NFT铸造给调用者
     */
    function mintNft() public {
        _safeMint(msg.sender, s_tokenId);
        s_tokenIdToMood[s_tokenId] = Mood.Happy; // default mood
        s_tokenId++;
    }

    function flipMood(uint256 tokenId) public {
        if(ownerOf(tokenId) != msg.sender) {    // OpenZeppelin删除了isApprovedOrOwner方法
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if(s_tokenIdToMood[tokenId] == Mood.Happy) {
            s_tokenIdToMood[tokenId] = Mood.Sad;
        } else {
            s_tokenIdToMood[tokenId] = Mood.Happy;
        }
    }

    // 重写了baseURI和tokenURI方法(这两个方法是ERC721中的虚函数,相互调用,用于生成NFT的元数据URI)
    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageUri;
        if (s_tokenIdToMood[tokenId] == Mood.Happy) {
            imageUri = s_happySvgImgUri;
        } else {
            imageUri = s_sadSvgImgUri;
        }
        
        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name": "', 
                            name(), 
                            '", "description": "A mood NFT", "attributes": [{"trait_type": "mood", "value": 100}], "image": "', 
                            imageUri, 
                            '"}'
                        )
                    )
                )          
            )
        );
    }
    
}