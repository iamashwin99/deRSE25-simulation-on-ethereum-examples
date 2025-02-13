# Simulation on Ethereum

The reproducibility of scientific simulations (ie Research Group A can run and verify the results produced by Research Group B exactly) is one of the key challenges of scientific research.

The proposed solution is to bring the entire computation on chain.
Each state transition is then emmited as logs along with any inputs for the state transition.
This would allow anyone to verify each step of the simulation and confirm the accuracy of the final results.

This project acts as a proof of concept.
In this repo we collect examples of scientific simulations that are run on the Ethereum blockchain.
Each example has a

- Solidity contract written in Solidity that represents the simulation in `src/` directory (Eg. [`PopulationGrowth.sol](src/PopulationGrowth.sol)).
- An accompanying test file in `test/` directory that tests the simulation contract also written in Solidity (Eg. [`PopulationGrowth.t.sol](test/PopulationGrowth.t.sol)).
- A deploy script to deploy the contract as well as start the simulation with the right inputs in `script/` directory (Eg. [`PopulationGrowth.s.sol](script/PopulationGrowth.s.sol)).
Thus demonstrating how these example simulations can be run entirely on a blockchain.

# Examples of simulations

## [Population growth](src/PopulationGrowth.sol)

A simple simulation of population growth.
Entry point is the `simulateGrowth` function.
Takes inputs:

- Initial population
- Growth rate per year (as a percentage)
- Number of years to simulate
Example deployment on testnet:

- [Contract deployment](https://sepolia.etherscan.io/tx/0x593b84e8b4a99b51bd28afd15cf7683d3a9f0199032c021d59d3a2237f6c3a81)
- [Contract](https://sepolia.etherscan.io/address/0x57a18da55088581055defa7cb584b55dd7d33b66)
- [Simulation transition](https://sepolia.etherscan.io/tx/0x23c38ce613260b145ad53d7a6f43d96a22db7c7c23247249b071988074679768)
- [Simulation logs](https://sepolia.etherscan.io/tx/0x23c38ce613260b145ad53d7a6f43d96a22db7c7c23247249b071988074679768#eventlog)