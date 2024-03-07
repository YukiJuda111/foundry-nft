// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";

contract MintBasicNft is Script {
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentlyDeployed = 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512; // need to update by our self
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) internal {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
}