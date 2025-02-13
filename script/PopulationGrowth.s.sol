// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {PopulationGrowth} from "../src/PopulationGrowth.sol";

contract PopulationGrowthScript is Script {
    PopulationGrowth public populationGrowth;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        populationGrowth = new PopulationGrowth();

        vm.stopBroadcast();
    }
}
