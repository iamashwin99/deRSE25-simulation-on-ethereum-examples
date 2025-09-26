// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract QuantumEntanglement {
    // Events to track state changes
    event StateUpdate(int256[2] state);
    event EntangledState(int256[4] state);

    // Scaling factor for fixed-point arithmetic (since Solidity doesn't support floating point)
    uint256 private constant SCALE = 1000;

    // Apply Hadamard gate to a single qubit state
    // Hadamard = 1/√2 * [1  1]
    //                   [1 -1]
    function applyHadamard(int256[2] memory state) public returns (int256[2] memory) {
        int256 scaling = 707; // Approximately 1/√2 * 1000
        int256[2] memory result;

        result[0] = (state[0] * scaling + state[1] * scaling) / int256(SCALE);
        result[1] = (state[0] * scaling - state[1] * scaling) / int256(SCALE);

        emit StateUpdate(result);
        return result;
    }

    // Apply CNOT gate to two-qubit state
    // CNOT = [1 0 0 0]
    //        [0 1 0 0]
    //        [0 0 0 1]
    //        [0 0 1 0]
    function applyCNOT(int256[4] memory state) public returns (int256[4] memory) {
        int256[4] memory result;

        result[0] = state[0]; // |00⟩ stays |00⟩
        result[1] = state[1]; // |01⟩ stays |01⟩
        result[2] = state[3]; // |10⟩ becomes |11⟩
        result[3] = state[2]; // |11⟩ becomes |10⟩

        emit EntangledState(result);
        return result;
    }

    // Create Bell state (maximally entangled state)
    // Starting from |00⟩, applies Hadamard to first qubit then CNOT
    function createBellState() public returns (int256[4] memory) {
        // Start with |0⟩ state for first qubit
        int256[2] memory initialState = [int256(SCALE), int256(0)];

        // Apply Hadamard to first qubit
        int256[2] memory hadamardState = applyHadamard(initialState);

        // Expand to two-qubit state (tensor product with |0⟩)
        int256[4] memory twoQubitState = [
            hadamardState[0], // amplitude for |00⟩
            int256(0), // amplitude for |01⟩
            hadamardState[1], // amplitude for |10⟩
            int256(0) // amplitude for |11⟩
        ];

        // Apply CNOT to create entanglement
        return applyCNOT(twoQubitState);
    }
}
