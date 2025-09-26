// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/QuantumEntanglement.sol";

contract QuantumEntanglementTest is Test {
    QuantumEntanglement quantum;
    uint256 constant SCALE = 1000;

    function setUp() public {
        quantum = new QuantumEntanglement();
    }

    function testHadamardGate() public {
        // Test Hadamard on |0⟩ state
        int256[2] memory initialState = [int256(SCALE), int256(0)];
        int256[2] memory result = quantum.applyHadamard(initialState);

        // Should approximately result in 1/√2(|0⟩ + |1⟩)
        // With our scaling factor, each component should be around 707 (1000/√2)
        assertApproxEqual(result[0], 707, 1);
        assertApproxEqual(result[1], 707, 1);
    }

    function testCNOTGate() public {
        // Test CNOT on |10⟩ state
        int256[4] memory initialState = [
            int256(0), // |00⟩
            int256(0), // |01⟩
            int256(SCALE), // |10⟩
            int256(0) // |11⟩
        ];

        int256[4] memory result = quantum.applyCNOT(initialState);

        // CNOT should flip the second qubit when first qubit is |1⟩
        // So |10⟩ should become |11⟩
        assertEq(uint256(int256(result[0])), 0); // |00⟩ amplitude
        assertEq(uint256(int256(result[1])), 0); // |01⟩ amplitude
        assertEq(uint256(int256(result[2])), 0); // |10⟩ amplitude
        assertEq(uint256(int256(result[3])), uint256(SCALE)); // |11⟩ amplitude
    }

    function testBellStateCreation() public {
        int256[4] memory bellState = quantum.createBellState();

        // Bell state should be 1/√2(|00⟩ + |11⟩)
        // With our scaling, each non-zero component should be around 707
        assertApproxEqual(bellState[0], 707, 1); // |00⟩ component
        assertEq(uint256(int256(bellState[1])), 0); // |01⟩ component
        assertEq(uint256(int256(bellState[2])), 0); // |10⟩ component
        assertApproxEqual(bellState[3], 707, 1); // |11⟩ component
    }

    // Helper function to assert approximate equality
    function assertApproxEqual(int256 a, int256 b, int256 margin) internal pure {
        int256 diff = a > b ? a - b : b - a;
        assertTrue(diff <= margin, "Values not approximately equal");
    }
}
