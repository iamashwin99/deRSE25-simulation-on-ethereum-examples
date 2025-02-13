// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PopulationGrowth {
    event PopulationUpdate(uint year, uint population);
    function simulateGrowth(uint _initialPopulation, uint _growthRatePercent, uint _years) public {
        uint currentPopulation = _initialPopulation;
        for(uint i = 1; i <= _years; i++) {
            uint increase = (currentPopulation * _growthRatePercent) / 100;
            currentPopulation += increase;
            emit PopulationUpdate(i, currentPopulation);
        }
    }
}
