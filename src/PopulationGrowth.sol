// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PopulationGrowth {
    event PopulationUpdate(uint256 year, uint256 population);

    function simulateGrowth(uint256 _initialPopulation, uint256 _growthRatePercent, uint256 _years) public {
        uint256 currentPopulation = _initialPopulation;
        for (uint256 i = 1; i <= _years; i++) {
            uint256 increase = (currentPopulation * _growthRatePercent) / 100;
            currentPopulation += increase;
            emit PopulationUpdate(i, currentPopulation);
        }
    }
}
