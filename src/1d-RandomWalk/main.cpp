#include <iostream>
#include <cstdlib>

/**
 * @brief Simulates a single step in a 1D random walk.
 *
 * Given a current position and a random integer, this function determines the next position
 * in the random walk. The step direction (either +1 or -1) is determined by whether the
 * random integer is even or odd.
 *
 * @param position The current position in the 1D random walk.
 * @param rand_int A random integer used to determine the step direction. If even, the step is +1; otherwise, it's -1.
 * @return The new position after taking a single step.
 */
int random_walk_step(int position, int rand_int) {
    return position + (rand_int % 2 == 0 ? 1 : -1);
}

/**
 * @brief Main function to simulate a 1D random walk.
 *
 * This function initializes the random seed, the initial position, and then iterates through a loop to simulate the random walk.
 * In each iteration, it calls the random_walk_step function to update the position based on a random integer and prints the current position.
 *
 * @param None
 * @return 0 upon successful execution.
 */
int main() {
    std::srand(42);  // Seed for reproducibility
    int position = 0;
    int rand_int = 0;

    for (int i = 0; i < 100; ++i) {
        rand_int = std::rand();
        position = random_walk_step(position, rand_int);
        std::cout << "Step " << i << ": " << position << "\n";
    }
}