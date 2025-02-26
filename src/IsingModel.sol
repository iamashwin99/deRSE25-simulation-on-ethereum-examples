// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IsingModel {
    // State variables
    int256[] private spins;            // Array to store spin states (+1 or -1)
    uint256 private constant N = 100;   // Number of spins in the chain
    int256 private J = 1;              // Coupling constant
    int256 private B = 0;              // External magnetic field
    uint256 private constant SCALE = 1000;  // Scaling factor for fixed-point arithmetic

    // Events
    event SpinConfigurationUpdated(int256[] spins);
    event EnergyCalculated(int256 energy);
    event AcceptanceRate(uint256 accepted, uint256 total);

    constructor() {
        // TODO: Initialize spins randomly
        spins = new int256[](N);
        for (uint256 i = 0; i < N; i++) {
            // Initially all spins up
            spins[i] = 1;
        }
    }

    // Calculate energy of a single spin with its neighbors
    function calculateLocalEnergy(uint256 index) public view returns (int256) {
        int256 leftSpin = spins[(index + N - 1) % N];  // Periodic boundary conditions
        int256 rightSpin = spins[(index + 1) % N];
        int256 currentSpin = spins[index];

        // E = -J * (Si * Si+1 + Si * Si-1) - B * Si
        return -J * (currentSpin * leftSpin + currentSpin * rightSpin) - B * currentSpin;
    }

    // Calculate total energy of the system
    function calculateTotalEnergy() public returns (int256) {
        int256 totalEnergy = 0;
        for (uint256 i = 0; i < N; i++) {
            totalEnergy += calculateLocalEnergy(i);
        }
        totalEnergy = totalEnergy / 2;  // Each bond was counted twice
        emit EnergyCalculated(totalEnergy);
        return totalEnergy;
    }

    // This function should be implemented separately
    // Returns e^(-deltaE/kT) * SCALE
    function exponential(int256 x) public pure returns (int256) {
        // TODO: Implement exponential function
        // Should return exp(-x) * SCALE
        revert("Not implemented");
    }

    // This function should be implemented separately
    function getRandomNumber() public view returns (uint256) {
        // TODO: Implement secure random number generation
        revert("Not implemented");
    }

    // Perform one Monte Carlo step using Metropolis algorithm
    function metropolisStep(int256 temperature) public returns (bool) {
        require(temperature > 0, "Temperature must be positive");

        // Choose a random spin
        uint256 index = getRandomNumber() % N;

        // Calculate energy change if we flip this spin
        int256 oldEnergy = calculateLocalEnergy(index);
        spins[index] = -spins[index];  // Flip the spin
        int256 newEnergy = calculateLocalEnergy(index);
        int256 deltaE = newEnergy - oldEnergy;

        // Metropolis acceptance criterion
        bool accepted = false;
        if (deltaE <= 0) {
            accepted = true;
        } else {
            // Calculate acceptance probability = exp(-deltaE/kT)
            int256 probability = exponential((deltaE * SCALE) / temperature);
            uint256 randomNum = getRandomNumber() % SCALE;
            if (int256(randomNum) < probability) {
                accepted = true;
            }
        }

        // If not accepted, revert the spin flip
        if (!accepted) {
            spins[index] = -spins[index];
        }

        emit SpinConfigurationUpdated(spins);
        return accepted;
    }

    // Perform multiple Monte Carlo steps
    function runSimulation(uint256 steps, int256 temperature) public {
        uint256 acceptedMoves = 0;

        for (uint256 i = 0; i < steps; i++) {
            bool accepted = metropolisStep(temperature);
            if (accepted) {
                acceptedMoves++;
            }
        }

        emit AcceptanceRate(acceptedMoves, steps);
    }

    // Getter function for the current spin configuration
    function getSpins() public view returns (int256[] memory) {
        return spins;
    }

    // Set coupling constant J
    function setCouplingConstant(int256 _J) public {
        J = _J;
    }

    // Set external magnetic field B
    function setExternalField(int256 _B) public {
        B = _B;
    }
}