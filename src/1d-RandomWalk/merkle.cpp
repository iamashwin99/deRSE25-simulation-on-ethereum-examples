#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <openssl/evp.h>
#include <sstream>
#include <iomanip>

// Function to convert bytes to hex string
std::string bytes_to_hex(const unsigned char* bytes, size_t len) {
    std::stringstream ss;
    ss << std::hex << std::setfill('0');
    for (size_t i = 0; i < len; i++) {
        ss << std::setw(2) << static_cast<int>(bytes[i]);
    }
    return ss.str();
}

// Function to compute SHA256 hash using EVP interface
std::string sha256(const std::string& input) {
    unsigned char hash[EVP_MAX_MD_SIZE];
    unsigned int hash_len;

    EVP_MD_CTX* ctx = EVP_MD_CTX_new();
    EVP_DigestInit_ex(ctx, EVP_sha256(), NULL);
    EVP_DigestUpdate(ctx, input.c_str(), input.length());
    EVP_DigestFinal_ex(ctx, hash, &hash_len);
    EVP_MD_CTX_free(ctx);

    return bytes_to_hex(hash, hash_len);
}

// Function to compute the next level of the Merkle tree
std::vector<std::string> compute_tree_level(const std::vector<std::string>& hashes) {
    std::vector<std::string> next_level;

    for (size_t i = 0; i < hashes.size(); i += 2) {
        if (i + 1 < hashes.size()) {
            // Concatenate and hash pair of nodes
            std::string combined = hashes[i] + hashes[i + 1];
            next_level.push_back(sha256(combined));
        } else {
            // If odd number of nodes, promote the last one
            next_level.push_back(hashes[i]);
        }
    }

    return next_level;
}

int main() {
    std::ifstream infile("function_trace.txt");
    std::ofstream outfile("merkle_root.txt");
    std::string line;
    std::vector<std::string> leaf_hashes;

    // Read each line and compute its hash
    while (std::getline(infile, line)) {
        std::string hash = sha256(line);
        leaf_hashes.push_back(hash);
        std::cout << "Line hash: " << hash << " for: " << line << std::endl;
    }

    // Build the Merkle tree
    std::vector<std::string> current_level = leaf_hashes;
    while (current_level.size() > 1) {
        std::cout << "\nCurrent level (" << current_level.size() << " nodes):" << std::endl;
        for (const auto& hash : current_level) {
            std::cout << hash << std::endl;
        }

        current_level = compute_tree_level(current_level);
    }

    // Output the Merkle root
    if (!current_level.empty()) {
        std::cout << "\nMerkle root: " << current_level[0] << std::endl;
        outfile << current_level[0] << std::endl;
    }

    return 0;
}