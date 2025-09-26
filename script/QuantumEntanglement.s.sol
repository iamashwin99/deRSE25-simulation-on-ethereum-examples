// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/QuantumEntanglement.sol";

contract QuantumEntanglementScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        // Deploy the contract
        QuantumEntanglement quantum = new QuantumEntanglement();
        console.log("QuantumEntanglement deployed at:", address(quantum));

        // Create Bell state
        int256[4] memory bellState = quantum.createBellState();
        console.log("Bell state created with amplitudes:");
        console.log("  |00>:", int256(bellState[0]));
        console.log("  |01>:", int256(bellState[1]));
        console.log("  |10>:", int256(bellState[2]));
        console.log("  |11>:", int256(bellState[3]));

        vm.stopBroadcast();
    }
}
