# 1D Random Walk Simulation with Merkle Tree Verification

This project implements a 1D random walk simulation and creates a cryptographic proof of the simulation results using a Merkle tree. The simulation results can be verified and stored on the Ethereum blockchain.

## Components

### 1. Random Walk Simulation

The simulation implements a basic 1D random walk where a particle moves either left or right at each step. The complete trace of the particle's movements is logged to [function_trace.txt](function_trace.txt).

### 2. Merkle Tree Generation

After the simulation runs, a Merkle tree is constructed from the simulation trace using SHA-256 hashing. The final Merkle root is stored in [merkle_root.txt](merkle_root.txt). This root represents a cryptographic commitment to the entire simulation history.

## How it Works

### Function Call Tracing

The simulation process:

- The random walk simulation logs each step to `function_trace.txt`
- Each line represents one step of the simulation
- The format includes position and movement information

### Merkle Tree Calculation

The merkle.cpp program:

1. Reads each line from function_trace.txt
2. Computes SHA-256 hash for each line
3. Pairs adjacent hashes and computes their combined hash
4. Continues this process until a single root hash remains
5. Stores the final Merkle root in merkle_root.txt

## Build and Run

The project includes several make targets:

- `make build`: Builds both the random walk simulator and merkle tree generator
- `make random_walk`: Builds only the random walk simulator
- `make merkle`: Builds only the merkle tree generator
- `make run`: Executes the complete pipeline (simulation followed by merkle tree generation)
- `make instrumentation_comparison`: Builds and compares performance with/without function tracing
- `make clean`: Removes all generated files and executables

## Performance Analysis

### Instrumentation Overhead Comparison

The project includes a performance analysis feature that measures the overhead of function call tracing instrumentation.

#### How to Run Performance Comparison

```bash
make instrumentation_comparison
```

This target will:

1. **Build two versions** of the random walk simulator:
   - **Instrumented version**: With detailed function call tracing enabled
   - **Non-instrumented version**: With tracing code compiled out

2. **Run performance tests** using 1,000,000 random walk iterations:
   - Each version is executed 3 times to account for system variability
   - Execution times are measured using the GNU time command

3. **Generate detailed report** (`performance_comparison.txt`) containing:
   - Execution times for both versions
   - Size of generated trace file
   - Timestamp and test configuration

#### Typical Results

The instrumentation typically shows:

- **7-8x performance overhead** when tracing is enabled (2s vs 0.24s on single core of Intel Core Ultra 5 135U CPU)
- **Large trace files** (80-90MB for 1M iterations)


## Blockchain Integration

The Merkle root can be stored on the Ethereum blockchain to provide a permanent, immutable record of the simulation results. To do this:

1. Take the Merkle root from merkle_root.txt
2. Use a smart contract to store this hash on-chain
3. The hash serves as a cryptographic commitment to the entire simulation history

This allows anyone to:

- Verify the integrity of the simulation results
- Challenge the results by providing a different simulation trace
- Prove that specific steps occurred in the simulation using Merkle proofs

For implementing the blockchain storage, you can use the existing Solidity contracts in this repository to store the Merkle root as a permanent record of the simulation.
