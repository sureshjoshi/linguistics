#include <format>
#include <iostream>

auto fib(int n) -> int {
    if (n <= 1) {
        return n;
    }
    return fib(n-2) + fib(n-1);
}

int main(int argc, char *argv[]) {
    auto result = fib(42);
    std::cout << std::format("Fib({}) = {}\n", 42, result);
    return 0;
}