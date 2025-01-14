#include <filesystem>
#include <format>
#include <iostream>

namespace fs = std::filesystem;

auto naive_walk() -> std::pair<uint32_t, uintmax_t> {
    uint32_t number_of_files = 0;
    uintmax_t total_size = 0;
    for (const auto& entry : fs::recursive_directory_iterator(".")) {
        if (entry.is_regular_file()) {
            ++number_of_files;
            total_size += entry.file_size();
        }
    }
    return {number_of_files, total_size};
}

int main(int argc, char *argv[]) {
    auto [number_of_files, total_size] = naive_walk();
    std::cout << std::format("{} files with a total size of {}\n", number_of_files, total_size);
    return 0;
}