// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployAddr;
    BasicNft public basicNft;
    address public USER = makeAddr("USER");
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        deployAddr = new DeployBasicNft();
        basicNft = deployAddr.run();
    }

    function testNameIsCorrect() public {
        string memory expectedName = "Doggie";
        string memory actualName = basicNft.name();
        // string 是 bytes array, 不能直接比较
        assertEq(keccak256(abi.encodePacked(expectedName)), keccak256(abi.encodePacked(actualName)));
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);
        assertEq(basicNft.balanceOf(USER), 1);
        assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(PUG)));
    }
}