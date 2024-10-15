// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // if on local chain (anvil), deploy mock
    // otherwise, grab existing contract address from live network

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_ANSWER = 2000e8;


    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return NetworkConfig(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        
        if (activeNetworkConfig.priceFeed != address(0)) {
            // so that we dont deploy a new mock contract everytime, saving the environment
            return activeNetworkConfig;
        }


        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_ANSWER);

        vm.stopBroadcast();

        NetworkConfig memory avilConfig = NetworkConfig(address(mockPriceFeed));
        return avilConfig;
    }
}

// 1. deploy mock on local anvil chain
// 2. keep track of the contract address accross the different chains

// Sepolia ETH / USD Address
// Mainnet ETH / USD Address
