// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test, console2} from "forge-std/Test.sol";
import {PopulationGrowth} from "../src/PopulationGrowth.sol";

contract PopulationGrowthTest is Test {
    PopulationGrowth public population;

    event PopulationUpdate(uint256 year, uint256 population);

    function setUp() public {
        population = new PopulationGrowth();
    }

    function test_InitialSimulation() public {
        // Test with initial population of 1000, 5% growth rate, for 3 years
        vm.expectEmit(true, true, false, true);
        emit PopulationUpdate(1, 1050); // Year 1: 1000 + 5% = 1050

        vm.expectEmit(true, true, false, true);
        emit PopulationUpdate(2, 1102); // Year 2: 1050 + 5% = 1102.5 (rounded down due to uint)

        vm.expectEmit(true, true, false, true);
        emit PopulationUpdate(3, 1157); // Year 3: 1102 + 5% = 1157.1 (rounded down due to uint)

        population.simulateGrowth(1000, 5, 3);
    }

    function test_ZeroInitialPopulation() public {
        // Test with zero initial population
        vm.expectEmit(true, true, false, true);
        emit PopulationUpdate(1, 0); // Should remain 0 as 0 + 5% of 0 = 0

        population.simulateGrowth(0, 5, 1);
    }

    function test_ZeroGrowthRate() public {
        // Test with zero growth rate
        vm.expectEmit(true, true, false, true);
        emit PopulationUpdate(1, 1000); // Should remain 1000 as growth rate is 0

        population.simulateGrowth(1000, 0, 1);
    }
}
